"""
Configuration module for Vijayraj Gems and Jewellery Shop Management System.
Loads environment variables from .env file.
"""
import os
from dotenv import load_dotenv

# Search for .env in project root or current directory
base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
env_path = os.path.join(base_dir, '.env')
if os.path.exists(env_path):
    load_dotenv(env_path)
else:
    # Check Private (api's)/.env if migrating
    alt_env = os.path.join(base_dir, "Private (api's)", '.env')
    if os.path.exists(alt_env):
        load_dotenv(alt_env)
    else:
        load_dotenv()


class Config:
    """Application configuration."""
    SECRET_KEY = os.getenv('SECRET_KEY') or os.getenv('FLASK_SECRET_KEY') or 'vijayraj-luxury-secret-key-2026'
    DEBUG = os.getenv('FLASK_DEBUG', 'False').lower() in ('true', '1', 'yes')
    HOST = os.getenv('FLASK_HOST', '0.0.0.0')
    PORT = int(os.getenv('FLASK_PORT', 5001))

    # Detect cloud deployment (Render sets RENDER=true or PORT != 5001)
    IS_CLOUD = os.getenv('RENDER') == 'true' or (os.getenv('PORT') is not None and os.getenv('PORT') != '5001')

    # MySQL Database Connection (Configurable via environment variables)
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = int(os.getenv('DB_PORT', 3306))
    DB_USER = os.getenv('DB_USER', 'root')
    DB_PASSWORD = os.getenv('DB_PASSWORD', '')
    DB_NAME = os.getenv('DB_NAME', 'vijayraj_jewellery')
    DB_SSL = os.getenv('DB_SSL', 'false')

    # Path to mysqldump binary for database backup
    MYSQL_DUMP_PATH = os.getenv('MYSQL_DUMP_PATH') or (
        '/usr/local/mysql/bin/mysqldump' if os.path.exists('/usr/local/mysql/bin/mysqldump') else 'mysqldump'
    )

    # E-Commerce Configuration
    FREE_DELIVERY_THRESHOLD = float(os.getenv('FREE_DELIVERY_THRESHOLD', 10000.00))
    DELIVERY_FREE_THRESHOLD = FREE_DELIVERY_THRESHOLD
    STANDARD_DELIVERY_FEE = float(os.getenv('STANDARD_DELIVERY_FEE', 99.00))
    DELIVERY_CHARGE_STANDARD = STANDARD_DELIVERY_FEE
    GST_PERCENT = float(os.getenv('GST_PERCENT', 3.00))
    UPLOAD_FOLDER = os.path.join(base_dir, 'frontend', 'images', 'products')
    MAX_CONTENT_LENGTH = int(os.getenv('MAX_CONTENT_LENGTH', 2 * 1024 * 1024))  # 2MB max per image
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'webp'}
