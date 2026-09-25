-- ============================================================
-- Stored Procedure and Triggers
-- Run with: mysql -u root -p vijayraj_jewellery < sql/procedures.sql
-- (Requires DELIMITER support — cannot run via Python connector directly)
-- ============================================================

USE vijayraj_jewellery;

-- Drop existing
DROP TRIGGER IF EXISTS trg_after_insert_invoice_items;
DROP TRIGGER IF EXISTS trg_after_insert_invoices;
DROP PROCEDURE IF EXISTS sp_create_invoice;

-- ============================================================
-- STORED PROCEDURE: sp_create_invoice
-- Creates an invoice in a single transaction.
-- items_json: JSON array like [{"product_id":1,"quantity":2},...]
-- ============================================================

DELIMITER //

CREATE PROCEDURE sp_create_invoice(
  IN p_customer_id INT,
  IN p_user_id INT,
  IN p_discount_percent DECIMAL(5,2),
  IN p_payment_mode VARCHAR(10),
  IN p_items_json JSON
)
BEGIN
  DECLARE v_invoice_id INT;
  DECLARE v_invoice_no VARCHAR(30);
  DECLARE v_subtotal DECIMAL(14,2) DEFAULT 0.00;
  DECLARE v_discount_amount DECIMAL(14,2) DEFAULT 0.00;
  DECLARE v_gst_amount DECIMAL(14,2) DEFAULT 0.00;
  DECLARE v_grand_total DECIMAL(14,2) DEFAULT 0.00;
  DECLARE v_item_count INT DEFAULT 0;
  DECLARE v_i INT DEFAULT 0;
  DECLARE v_product_id INT;
  DECLARE v_quantity INT;
  DECLARE v_unit_price DECIMAL(14,2);
  DECLARE v_line_total DECIMAL(14,2);
  DECLARE v_stock INT;
  DECLARE v_product_name VARCHAR(150);

  -- Generate unique invoice number
  SET v_invoice_no = CONCAT('INV-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0'));

  -- Ensure uniqueness
  WHILE EXISTS (SELECT 1 FROM invoices WHERE invoice_no = v_invoice_no) DO
    SET v_invoice_no = CONCAT('INV-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0'));
  END WHILE;

  SET v_item_count = JSON_LENGTH(p_items_json);

  IF v_item_count = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No items provided in the invoice.';
  END IF;

  -- Validate stock for all items first
  SET v_i = 0;
  WHILE v_i < v_item_count DO
    SET v_product_id = JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].product_id'));
    SET v_quantity = JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].quantity'));

    SELECT stock_qty, name, price INTO v_stock, v_product_name, v_unit_price
    FROM products WHERE id = v_product_id;

    IF v_stock IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found.';
    END IF;

    IF v_quantity > v_stock THEN
      SET @err_msg = CONCAT('Insufficient stock for "', v_product_name, '". Available: ', v_stock, ', Requested: ', v_quantity);
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @err_msg;
    END IF;

    SET v_line_total = v_unit_price * v_quantity;
    SET v_subtotal = v_subtotal + v_line_total;

    SET v_i = v_i + 1;
  END WHILE;

  -- Calculate totals
  SET v_discount_amount = ROUND(v_subtotal * p_discount_percent / 100, 2);
  SET v_gst_amount = ROUND((v_subtotal - v_discount_amount) * 3 / 100, 2);
  SET v_grand_total = (v_subtotal - v_discount_amount) + v_gst_amount;

  -- Insert the invoice (triggers are disabled during seeding, active in normal use)
  INSERT INTO invoices (invoice_no, customer_id, user_id, invoice_date, subtotal,
                        discount_percent, gst_percent, gst_amount, grand_total, payment_mode)
  VALUES (v_invoice_no, p_customer_id, p_user_id, NOW(), v_subtotal,
          p_discount_percent, 3.00, v_gst_amount, v_grand_total, p_payment_mode);

  SET v_invoice_id = LAST_INSERT_ID();

  -- Insert each item
  SET v_i = 0;
  WHILE v_i < v_item_count DO
    SET v_product_id = JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].product_id'));
    SET v_quantity = JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].quantity'));

    SELECT price INTO v_unit_price FROM products WHERE id = v_product_id;
    SET v_line_total = v_unit_price * v_quantity;

    INSERT INTO invoice_items (invoice_id, product_id, quantity, unit_price, line_total)
    VALUES (v_invoice_id, v_product_id, v_quantity, v_unit_price, v_line_total);

    SET v_i = v_i + 1;
  END WHILE;

  -- Return the created invoice
  SELECT i.*, c.name AS customer_name, c.phone AS customer_phone,
         u.full_name AS billed_by
  FROM invoices i
  JOIN customers c ON c.id = i.customer_id
  JOIN users u ON u.id = i.user_id
  WHERE i.id = v_invoice_id;

END //

-- ============================================================
-- TRIGGER: After insert on invoice_items -> decrease stock
-- ============================================================
CREATE TRIGGER trg_after_insert_invoice_items
AFTER INSERT ON invoice_items
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock_qty = stock_qty - NEW.quantity
  WHERE id = NEW.product_id;
END //

-- ============================================================
-- TRIGGER: After insert on invoices -> add loyalty points
-- (1 point per Rs.1000 of grand_total)
-- ============================================================
CREATE TRIGGER trg_after_insert_invoices
AFTER INSERT ON invoices
FOR EACH ROW
BEGIN
  UPDATE customers
  SET loyalty_points = loyalty_points + FLOOR(NEW.grand_total / 1000)
  WHERE id = NEW.customer_id;
END //

DELIMITER ;
