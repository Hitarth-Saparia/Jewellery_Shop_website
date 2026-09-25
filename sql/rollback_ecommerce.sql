-- ==============================================================================
-- Vijayraj Gems & Jewellery — E-Commerce Database Rollback
-- Drops ONLY what the e-commerce migration added, leaving pre-existing objects intact
-- ==============================================================================

-- 1. Drop foreign key constraint on products
SET @fk_exists = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE() AND TABLE_NAME = 'products' AND CONSTRAINT_NAME = 'fk_products_category');
SET @sql_fk = IF(@fk_exists > 0, 'ALTER TABLE products DROP FOREIGN KEY fk_products_category', 'SELECT 1');
PREPARE drop_fk FROM @sql_fk;
EXECUTE drop_fk;
DEALLOCATE PREPARE drop_fk;

-- 2. Drop new columns from products
SET @dbname = DATABASE();
SET @tablename = "products";

-- List of columns to drop
SET @drop_cols = "
  DROP COLUMN IF EXISTS category_id,
  DROP COLUMN IF EXISTS jewellery_type,
  DROP COLUMN IF EXISTS stone_type,
  DROP COLUMN IF EXISTS specifications,
  DROP COLUMN IF EXISTS is_featured,
  DROP COLUMN IF EXISTS is_active,
  DROP COLUMN IF EXISTS created_at
";

-- Safely drop columns
ALTER TABLE products
  DROP COLUMN IF EXISTS category_id,
  DROP COLUMN IF EXISTS jewellery_type,
  DROP COLUMN IF EXISTS stone_type,
  DROP COLUMN IF EXISTS specifications,
  DROP COLUMN IF EXISTS is_featured,
  DROP COLUMN IF EXISTS is_active,
  DROP COLUMN IF EXISTS created_at;

-- 3. Drop e-commerce tables in reverse order of foreign key dependencies
DROP TABLE IF EXISTS `order_status_history`;
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `order_items`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `cart_items`;
DROP TABLE IF EXISTS `product_images`;
DROP TABLE IF EXISTS `customer_accounts`;
DROP TABLE IF EXISTS `categories`;
