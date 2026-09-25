-- ============================================================
-- Vijayraj Gems and Jewellery Shop Management System
-- Database Schema (MySQL 8.0+ / InnoDB / utf8mb4)
-- ============================================================

CREATE DATABASE IF NOT EXISTS vijayraj_jewellery
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE vijayraj_jewellery;

-- ── Drop existing objects in reverse-dependency order ─────────
DROP TRIGGER IF EXISTS trg_after_insert_invoice_items;
DROP TRIGGER IF EXISTS trg_after_insert_invoices;
DROP PROCEDURE IF EXISTS sp_create_invoice;
DROP VIEW IF EXISTS v_low_stock;
DROP VIEW IF EXISTS v_daily_sales;
DROP VIEW IF EXISTS v_monthly_sales;
DROP VIEW IF EXISTS v_top_products;
DROP VIEW IF EXISTS v_sales_by_category;
DROP VIEW IF EXISTS v_sales_by_payment_mode;
DROP VIEW IF EXISTS v_customer_purchase_history;
DROP TABLE IF EXISTS invoice_items;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS metal_rates;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS users;

-- ── 1. USERS ─────────────────────────────────────────────────
CREATE TABLE users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  full_name     VARCHAR(100) NOT NULL,
  username      VARCHAR(50)  NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role          ENUM('admin','manager','staff') NOT NULL DEFAULT 'staff',
  phone         VARCHAR(15),
  email         VARCHAR(100),
  salary        DECIMAL(12,2) DEFAULT 0.00,
  joined_date   DATE DEFAULT (CURRENT_DATE),
  is_active     TINYINT(1) NOT NULL DEFAULT 1,
  INDEX idx_users_role (role),
  INDEX idx_users_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 2. PRODUCTS ──────────────────────────────────────────────
CREATE TABLE products (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  product_code  VARCHAR(20)  NOT NULL UNIQUE,
  name          VARCHAR(150) NOT NULL,
  category      ENUM('Gold','Silver','Diamond','Platinum','Gems') NOT NULL,
  purity        VARCHAR(20)  DEFAULT NULL,
  weight_grams  DECIMAL(10,3) DEFAULT 0.000,
  making_charge DECIMAL(12,2) DEFAULT 0.00,
  price         DECIMAL(14,2) NOT NULL,
  stock_qty     INT NOT NULL DEFAULT 0,
  reorder_level INT NOT NULL DEFAULT 5,
  design_code   VARCHAR(30)  DEFAULT NULL,
  description   TEXT,
  CHECK (price >= 0),
  CHECK (stock_qty >= 0),
  CHECK (reorder_level >= 0),
  INDEX idx_products_category (category),
  INDEX idx_products_stock (stock_qty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 3. CUSTOMERS ─────────────────────────────────────────────
CREATE TABLE customers (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  customer_code   VARCHAR(20)  NOT NULL UNIQUE,
  name            VARCHAR(100) NOT NULL,
  phone           VARCHAR(15)  NOT NULL UNIQUE,
  email           VARCHAR(100) DEFAULT NULL,
  address         TEXT,
  city            VARCHAR(50)  DEFAULT NULL,
  loyalty_points  INT NOT NULL DEFAULT 0,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  CHECK (loyalty_points >= 0),
  INDEX idx_customers_city (city),
  INDEX idx_customers_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 4. INVOICES ──────────────────────────────────────────────
CREATE TABLE invoices (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  invoice_no       VARCHAR(30)  NOT NULL UNIQUE,
  customer_id      INT NOT NULL,
  user_id          INT NOT NULL,
  invoice_date     DATETIME DEFAULT CURRENT_TIMESTAMP,
  subtotal         DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  discount_percent DECIMAL(5,2)  NOT NULL DEFAULT 0.00,
  gst_percent      DECIMAL(5,2)  NOT NULL DEFAULT 3.00,
  gst_amount       DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  grand_total      DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  payment_mode     ENUM('Cash','Card','UPI') NOT NULL DEFAULT 'Cash',
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
  CHECK (discount_percent >= 0 AND discount_percent <= 100),
  CHECK (gst_percent >= 0),
  INDEX idx_invoices_date (invoice_date),
  INDEX idx_invoices_customer (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 5. INVOICE ITEMS ─────────────────────────────────────────
CREATE TABLE invoice_items (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  invoice_id  INT NOT NULL,
  product_id  INT NOT NULL,
  quantity    INT NOT NULL DEFAULT 1,
  unit_price  DECIMAL(14,2) NOT NULL,
  line_total  DECIMAL(14,2) NOT NULL,
  FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
  CHECK (quantity > 0),
  INDEX idx_invoice_items_invoice (invoice_id),
  INDEX idx_invoice_items_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 6. METAL RATES ───────────────────────────────────────────
CREATE TABLE metal_rates (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  rate_date    DATE NOT NULL,
  metal        VARCHAR(30) NOT NULL,
  rate_per_gram DECIMAL(12,2) NOT NULL,
  CHECK (rate_per_gram > 0),
  UNIQUE KEY uq_metal_date (rate_date, metal),
  INDEX idx_metal_rates_date (rate_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- VIEWS
-- ============================================================

-- Low-stock products (stock_qty <= reorder_level)
CREATE VIEW v_low_stock AS
SELECT id, product_code, name, category, stock_qty, reorder_level
FROM products
WHERE stock_qty <= reorder_level;

-- Daily sales summary
CREATE VIEW v_daily_sales AS
SELECT
  DATE(invoice_date) AS sale_date,
  COUNT(*) AS total_invoices,
  SUM(grand_total) AS total_revenue
FROM invoices
GROUP BY DATE(invoice_date)
ORDER BY sale_date DESC;

-- Monthly sales summary
CREATE VIEW v_monthly_sales AS
SELECT
  YEAR(invoice_date) AS sale_year,
  MONTH(invoice_date) AS sale_month,
  DATE_FORMAT(invoice_date, '%Y-%m') AS month_label,
  COUNT(*) AS total_invoices,
  SUM(grand_total) AS total_revenue
FROM invoices
GROUP BY YEAR(invoice_date), MONTH(invoice_date), DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY sale_year DESC, sale_month DESC;

-- Top selling products
CREATE VIEW v_top_products AS
SELECT
  p.id,
  p.product_code,
  p.name,
  p.category,
  SUM(ii.quantity) AS total_qty_sold,
  SUM(ii.line_total) AS total_revenue
FROM invoice_items ii
JOIN products p ON p.id = ii.product_id
GROUP BY p.id, p.product_code, p.name, p.category
ORDER BY total_qty_sold DESC;

-- Sales by category
CREATE VIEW v_sales_by_category AS
SELECT
  p.category,
  COUNT(DISTINCT i.id) AS total_invoices,
  SUM(ii.quantity) AS total_qty_sold,
  SUM(ii.line_total) AS total_revenue
FROM invoice_items ii
JOIN products p ON p.id = ii.product_id
JOIN invoices i ON i.id = ii.invoice_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Sales by payment mode
CREATE VIEW v_sales_by_payment_mode AS
SELECT
  payment_mode,
  COUNT(*) AS total_invoices,
  SUM(grand_total) AS total_revenue
FROM invoices
GROUP BY payment_mode
ORDER BY total_revenue DESC;

-- Customer purchase history
CREATE VIEW v_customer_purchase_history AS
SELECT
  c.id AS customer_id,
  c.customer_code,
  c.name AS customer_name,
  c.phone,
  c.loyalty_points,
  i.id AS invoice_id,
  i.invoice_no,
  i.invoice_date,
  i.grand_total,
  i.payment_mode
FROM customers c
LEFT JOIN invoices i ON i.customer_id = c.id
ORDER BY c.id, i.invoice_date DESC;
