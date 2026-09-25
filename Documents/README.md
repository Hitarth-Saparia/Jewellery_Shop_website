# 💎 Vijayraj Gems and Jewellery Shop Management System 💍

A full-stack web application for managing a jewellery shop's daily operations including product inventory, customer management, billing, invoicing, reports, employee management, and metal rate tracking.

## 🏗️ Technology Stack

| Component | Technology |
|-----------|-----------|
| **Backend** | Python 3.10+ with Flask |
| **Database** | MySQL 8.0+ (InnoDB, utf8mb4) |
| **Frontend** | HTML5, CSS3, Vanilla JavaScript |
| **Charts** | Chart.js (CDN) |
| **DB Access** | PyMySQL with parameterized queries (no ORM) |
| **Auth** | Flask sessions + Werkzeug password hashing |

## 📁 Project Structure (5 Core Folders)

```
├── start.sh                # 🚀 Unified all-in-one script to run the entire project
├── run.py                  # Root launcher entrypoint
├── README.md               # Main project documentation
│
├── 📂 Frontend/            # Presentation Layer
│   ├── css/style.css       # Custom gold-and-white theme
│   ├── js/                 # Vanilla JS API & UI helpers
│   ├── login.html          # Authentication view
│   ├── dashboard.html      # KPI metrics & quick rate ticker
│   ├── products.html       # Inventory & stock management
│   ├── customers.html      # Customer CRM & loyalty points
│   ├── billing.html        # POS checkout & instant billing
│   ├── invoices.html       # Invoice register & audit search
│   ├── invoice_print.html  # Legal tax invoice layout
│   ├── reports.html        # Sales analytics & Chart.js charts
│   ├── employees.html      # Staff directory & role privileges
│   ├── metal_rates.html    # Daily gold/silver market rates
│   └── Legacy_Code_Drafts/ # Initial prototype files
│
├── 📂 Backend/             # Application Server & Business Logic
│   ├── app.py              # Flask application factory
│   ├── config.py           # Configuration management
│   ├── db.py               # MySQL pool & parameterized query engine
│   ├── requirements.txt    # Python dependencies
│   └── scripts/
│       └── init_db.py      # Database initialization script
│
├── 📂 Database/            # Data Layer & Storage
│   ├── schema.sql          # Tables, indexes & analytical views
│   ├── seed.sql            # Realistic seed records
│   ├── procedures.sql      # Stored procedures & triggers
│   ├── README_DATABASE.md  # Database schema & ER guide
│   └── backups/            # Database .sql dump snapshots
│
├── 📂 Documents/           # Project Reports & Deliverables
│   ├── archita.docx        # Project Report
│   ├── project.pdf         # Project Synopsis & Wireframes
│   ├── PROJECT_SYNOPSIS.md # Concise project sheet
│   └── README.md           # Documentation copy
│
└── 📂 Private (api's)/     # Private APIs & Sensitive Configuration
    ├── .env                # Database credentials & secret keys
    ├── .env.example        # Environment template
    ├── API_DOCUMENTATION.md# Complete REST API reference
    └── blueprints/         # Modular Flask Blueprint controllers
        ├── auth.py         # Login, logout, session
        ├── products.py     # Product inventory routes
        ├── customers.py    # Customer management routes
        ├── invoices.py     # Billing & invoicing routes
        ├── reports.py      # Business intelligence & CSV export
        ├── users.py        # Staff administration
        ├── metal_rates.py  # Metal price updates
        └── backup.py       # Live MySQL backup stream
```

## 🚀 Quick Start (One Command)

To run the whole project with MySQL, environment setup, database initialization, and web server:

```bash
./start.sh
```

The script automatically:
1. Verifies/creates Python virtual environment (`venv`).
2. Installs required packages.
3. Ensures MySQL service is active (or launches local MySQL instance).
4. Verifies/initializes the database and seed data.
5. Starts the Flask server at **http://127.0.0.1:5001**.

### Prerequisites
- **Python 3.10+**: [Download](https://www.python.org/downloads/)
- **MySQL 8.0+**: [Download](https://dev.mysql.com/downloads/) or use XAMPP's MySQL

### Step 1: Clone/Download the Project
```bash
cd "Disha's Project"
```

### Step 2: Create Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate    # macOS/Linux
# OR
venv\Scripts\activate       # Windows
```

### Step 3: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 4: Configure Environment
Copy `.env.example` to `.env` and update the MySQL credentials:
```bash
cp .env.example .env
```
Edit `.env`:
```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=vijayraj_jewellery
```

### Step 5: Initialize Database
Make sure MySQL is running, then:
```bash
python scripts/init_db.py
```
This will:
1. Create the `vijayraj_jewellery` database
2. Create all tables with constraints
3. Insert 50+ rows of seed data per table
4. Hash all user passwords
5. Install stored procedure and triggers

**Alternative (MySQL Workbench/phpMyAdmin):**
```sql
SOURCE sql/schema.sql;
SOURCE sql/seed.sql;
SOURCE sql/procedures.sql;
```
Then run `python scripts/init_db.py` just for password hashing (or manually update the password_hash fields).

### Step 6: Run the Application
```bash
python app.py
```
Open http://localhost:5000 in your browser.

## 🔑 Demo Credentials

| Role | Username | Password |
|------|----------|----------|
| **Admin** | `admin` | `Admin@123` |
| **Manager** | `rohit.mgr` | `Rohit@456` |
| **Manager** | `priya.mgr` | `Priya@456` |
| **Manager** | `nitin.mgr` | `Nitin@456` |
| **Staff** | `amit.staff` | `Amit@789` |
| **Staff** | `sneha.staff` | `Sneha@789` |
| **Staff** | `rajesh.staff` | `Rajesh@789` |

## 👤 Role-Based Access

| Feature | Admin | Manager | Staff |
|---------|-------|---------|-------|
| Dashboard | ✅ | ✅ | ✅ |
| Products (View) | ✅ | ✅ | ✅ |
| Products (Add/Edit/Delete) | ✅ | ✅ | ❌ |
| Customers | ✅ | ✅ | ✅ |
| Billing | ✅ | ✅ | ✅ |
| Invoices | ✅ | ✅ | ✅ |
| Reports | ✅ | ✅ | ❌ |
| Metal Rates | ✅ | ✅ | ❌ |
| Employees | ✅ | ❌ | ❌ |
| DB Backup | ✅ | ❌ | ❌ |

## 📄 Page-by-Page Feature List

### 1. Login
- Authenticate against `users` table
- Werkzeug password hash verification
- Session-based authentication with secure cookies
- Redirects to dashboard on success

### 2. Dashboard
- Summary cards: total products, customers, today's sales, month's sales, low-stock count
- Latest metal rates (Gold 24K/22K, Silver, Platinum)
- Recent 5 invoices table

### 3. Products
- Full CRUD operations with modal forms
- Search by name, code, or description
- Filter by category (Gold/Silver/Diamond/Platinum/Gems)
- Sort by any column, pagination
- Low-stock checkbox filter
- Low-stock rows highlighted (yellow), out-of-stock (red)
- Validation: unique product_code, required fields

### 4. Customers
- Full CRUD with modal forms
- Search by name, code, phone, city
- Auto-generated next customer code
- Phone validation (10-digit Indian mobile)
- Unique phone enforcement
- Customer detail view with purchase history and loyalty points
- Click customer name to see full details

### 5. Billing
- Search customer by phone number (dynamic dropdown)
- Quick-add new customer from billing page
- Add multiple products with dynamic rows
- Live calculation: subtotal → discount → 3% GST → grand total
- Stock validation (blocks overselling)
- Payment mode: Cash/Card/UPI
- Creates invoice via `sp_create_invoice` stored procedure
- Triggers auto-decrease stock and add loyalty points
- Success modal with print option

### 6. Invoices
- List all invoices with search (by invoice no, customer name, phone)
- Date range filter
- Detailed invoice view in modal
- Print/reprint via dedicated print page

### 7. Reports (Admin/Manager)
- **Monthly Sales**: Bar + line charts, table with revenue trends
- **Daily Sales**: Line chart, last 30 days
- **Sales by Category**: Doughnut + bar charts
- **Sales by Payment Mode**: Pie chart
- **Top Products**: Horizontal bar chart, ranked list
- **Low Stock Alert**: Table with status badges
- **CSV Export**: Download any report as CSV

### 8. Employees (Admin only)
- CRUD operations for user accounts
- Assign roles (admin/manager/staff)
- Reset passwords
- Activate/deactivate users
- Database backup download

### 9. Metal Rates (Admin/Manager)
- View latest rates per metal type
- Add daily rates (bulk form for all 4 metals)
- Gold 24K price trend chart
- Full rate history table

### 10. Backup (Admin)
- Download complete SQL dump via `mysqldump`

## 🗄️ Database Design

### Tables
1. **users** - Staff accounts with roles and salary
2. **products** - Jewellery inventory with categories and stock
3. **customers** - Customer records with loyalty points
4. **invoices** - Invoice headers with totals and payment mode
5. **invoice_items** - Line items for each invoice
6. **metal_rates** - Daily metal price tracking

### Views
| View | Purpose |
|------|---------|
| `v_low_stock` | Products below reorder level |
| `v_daily_sales` | Daily sales aggregation |
| `v_monthly_sales` | Monthly sales aggregation |
| `v_top_products` | Best-selling products by quantity |
| `v_sales_by_category` | Revenue breakdown by category |
| `v_sales_by_payment_mode` | Revenue by payment method |
| `v_customer_purchase_history` | Customer purchase records |

### Stored Procedure: `sp_create_invoice`
- Takes customer_id, user_id, discount_percent, payment_mode, items_json
- Runs in ONE transaction
- Validates stock for ALL items before proceeding
- Generates unique invoice number (INV-YYYYMMDD-XXXX)
- Computes: subtotal, discount, 3% GST, grand total
- Inserts invoice header and all line items
- Rolls back with SQLSTATE 45000 error if stock insufficient

### Triggers
| Trigger | Event | Action |
|---------|-------|--------|
| `trg_after_insert_invoice_items` | AFTER INSERT on invoice_items | Decreases product stock |
| `trg_after_insert_invoices` | AFTER INSERT on invoices | Adds loyalty points (1pt per ₹1000) |

## 🎨 UI Theme
- **Background**: `#fdf5e6` (old lace)
- **Header**: Gold gradient (`#ffd700` → `#daa520`)
- **Navigation**: `#333` dark bar
- **Headings**: `darkgoldenrod`
- **Branding**: 💎💍 emoji accents
- **Font**: Arial, Helvetica, sans-serif
- **Currency**: Indian format (₹12,00,000.00)

## 📝 License
This project was developed as an academic project for Vijayraj Gems and Jewellery Shop.
