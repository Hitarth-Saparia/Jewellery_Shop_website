#!/bin/bash
# ==============================================================================
# 💎 Vijayraj Gems & Jewellery Shop Management System 💍
# Unified All-in-One Startup Script
# ==============================================================================

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "=================================================================="
echo "💎 Starting Vijayraj Gems & Jewellery Shop Management System 💍"
echo "=================================================================="

# 1. Check Python
if ! command -v python3 &>/dev/null; then
    echo "❌ Error: Python 3 is not installed or not in PATH."
    exit 1
fi

# 2. Check / Create Virtual Environment
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment in venv/..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# 3. Check / Install Python Dependencies
if ! python -c "import flask, pymysql, dotenv" &>/dev/null; then
    echo "📦 Installing required Python packages..."
    pip install -q -r requirements.txt
fi

# 4. Check & Start MySQL Server
MYSQLD_PATH=""
if [ -x "/usr/local/mysql/bin/mysqld" ]; then
    MYSQLD_PATH="/usr/local/mysql/bin/mysqld"
elif command -v mysqld &>/dev/null; then
    MYSQLD_PATH="$(command -v mysqld)"
fi

STARTED_MYSQL=0
if ! nc -z 127.0.0.1 3306 &>/dev/null; then
    echo "🔍 MySQL server is not running on port 3306. Starting local MySQL instance..."
    
    # Initialize data dir if needed
    if [ ! -d "mysql_data" ] || [ ! -d "mysql_data/mysql" ]; then
        echo "⚙️  Initializing MySQL data directory..."
        mkdir -p mysql_data
        if [ -n "$MYSQLD_PATH" ]; then
            "$MYSQLD_PATH" --initialize-insecure --datadir="$PROJECT_DIR/mysql_data" --basedir=/usr/local/mysql
        else
            echo "❌ Error: mysqld binary not found to initialize data directory."
            exit 1
        fi
    fi

    # Start mysqld in background
    if [ -n "$MYSQLD_PATH" ]; then
        echo "🚀 Starting mysqld background process..."
        "$MYSQLD_PATH" --datadir="$PROJECT_DIR/mysql_data" --basedir=/usr/local/mysql --port=3306 --socket="/tmp/mysql.sock" &>/dev/null &
        MYSQL_PID=$!
        STARTED_MYSQL=1
        
        # Wait up to 15 seconds for MySQL to be ready
        echo -n "⏳ Waiting for MySQL to be ready..."
        READY=0
        for i in {1..15}; do
            if nc -z 127.0.0.1 3306 &>/dev/null; then
                READY=1
                echo " ✓ Ready!"
                break
            fi
            sleep 1
            echo -n "."
        done

        if [ $READY -ne 1 ]; then
            echo ""
            echo "❌ Error: Timed out waiting for MySQL to start."
            exit 1
        fi
    else
        echo "⚠️ Warning: mysqld binary not found. Please start MySQL manually."
    fi
else
    echo "✓ MySQL server is active on port 3306."
fi

# 5. Check if database is accessible
DB_CHECK=$(python -c "
import sys, os
sys.path.insert(0, 'backend')
from config import Config
import pymysql
try:
    conn = pymysql.connect(host=Config.DB_HOST, port=Config.DB_PORT, user=Config.DB_USER, password=Config.DB_PASSWORD)
    with conn.cursor() as cur:
        cur.execute(\"SHOW DATABASES LIKE 'vijayraj_jewellery'\")
        exists = cur.fetchone()
    conn.close()
    print('1' if exists else '0')
except Exception:
    print('0')
" 2>/dev/null || echo "0")

if [ "$DB_CHECK" = "1" ]; then
    echo "✓ Existing MySQL database 'vijayraj_jewellery' connected."
else
    echo "⚠️ Database 'vijayraj_jewellery' not detected or credentials in .env need review."
fi

# 6. Cleanup trap if we started MySQL
cleanup() {
    echo ""
    echo "🛑 Stopping application server..."
    if [ $STARTED_MYSQL -eq 1 ] && [ -n "$MYSQL_PID" ]; then
        echo "🛑 Stopping local MySQL server (PID: $MYSQL_PID)..."
        kill "$MYSQL_PID" 2>/dev/null || true
    fi
    echo "👋 Good bye!"
    exit 0
}
trap cleanup SIGINT SIGTERM EXIT

# 7. Print Launch Information
echo ""
echo "=================================================================="
echo "✨ Application is starting!"
echo "🌐 URL:              http://127.0.0.1:5001"
echo ""
echo "🔑 Demo Credentials:"
echo "   Admin:            admin       /  Admin@123"
echo "   Manager:          rohit.mgr   /  Rohit@456"
echo "   Manager:          priya.mgr   /  Priya@456"
echo "   Staff:            amit.staff  /  Amit@789"
echo "   Staff:            sneha.staff /  Sneha@789"
echo "=================================================================="
echo "Press Ctrl+C to stop the application."
echo ""

# 8. Ensure Port 5001 is free
OCCUPIED_PID=$(lsof -ti :5001 2>/dev/null || true)
if [ -n "$OCCUPIED_PID" ]; then
    echo "⚠️  Port 5001 was in use by PID $OCCUPIED_PID. Freeing port..."
    kill -9 $OCCUPIED_PID 2>/dev/null || true
    sleep 1
fi

# 9. Start Flask Application
python backend/app.py
