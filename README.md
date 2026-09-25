# Vijayraj Gems & Jewellery — Shop Management & E-Commerce System

A luxury jewellery-brand enterprise management application and public e-commerce boutique for **Vijayraj Gems & Jewellery** (est. 1994, Mumbai). Designed in the visual tradition of high-end Indian haute joaillerie houses (such as Orra, Tanishq, and Tiffany), combining editorial photography, champagne gold accents, deep navy typography, and a pure server-rendered Python/Flask architecture with zero API layer.

---

## 🏛️ Architecture & Core Principles

1. **Strict UI Freeze & Design System Preservation**:
   - Zero modifications or deletions to existing CSS rules.
   - All newly added components (shopping bag, checkout summary, order tracking timeline, payment gateway tabs, statutory invoices) are styled exclusively via a single, marked e-commerce block appended at the end of `frontend/css/style.css` using pre-existing design tokens and CSS variables.
   - Preserves all brand colors: Deep Navy (`#0F1B2D`), Champagne Gold (`#C9A24B`), Ivory Background (`#FAF7F2`), Warm Grey borders (`#E7E1D6`), and typography (*Playfair Display* & *Inter*).

2. **Additive-Only Database Architecture**:
   - Zero drops, renames, truncations, or deletions of any existing table, column, view, stored procedure, or trigger.
   - Existing schema (`products`, `customers`, `invoices`, `invoice_items`, `users`, `metal_rates`, views, procedures, and triggers) remains 100% intact and functional.
   - New e-commerce tables: `customer_accounts`, `categories`, `product_images`, `cart_items`, `orders`, `order_items`, `payments`, `order_status_history`.
   - New nullable/defaulted columns on `products`: `category_id`, `jewellery_type`, `stone_type`, `specifications`, `is_featured`, `is_active`, `created_at`.
   - All changes version-controlled in `sql/migration_ecommerce.sql`, `sql/seed_ecommerce.sql`, and `sql/rollback_ecommerce.sql`. Complete backup stored in `sql/backup_before_ecommerce.sql`.

3. **Pure Server-Side Jinja2 Architecture (Zero APIs)**:
   - No REST/JSON API endpoints, no client-side `fetch()` or `XMLHttpRequest`.
   - Pure server-rendered Jinja2 templates and standard HTML form POSTs following the **Post/Redirect/Get (PRG)** pattern with session flash messages.
   - Robust CSRF protection on every form submission.
   - Strict session separation (`session['user_type'] = 'customer'` vs `'staff'`).
   - Strict IDOR prevention on all customer account and order routes.

4. **Statutory High-End PDF Generation**:
   - Implemented via `reportlab` producing statutory Tax Invoices with BIS HUID, GSTIN, 3% GST breakdown, client particulars, and authorized signatory seals.

---

## 📁 Project Structure

```
Vijayraj-Jewellery/
├── frontend/
│   ├── html/                       # Jinja2 Templates
│   │   ├── shop/                   # Customer-facing E-Commerce templates
│   │   │   ├── customer_login.html     # Customer portal sign-in
│   │   │   ├── customer_register.html  # New client registration
│   │   │   ├── shop.html               # Luxury catalog with search & filters
│   │   │   ├── product_detail.html     # Piece showcase with gallery & specs
│   │   │   ├── cart.html               # Shopping bag with live calculations
│   │   │   ├── checkout.html           # Shipping details & tax breakdown
│   │   │   ├── payment.html            # Simulated gateway (Card, UPI, NetBanking)
│   │   │   ├── order_confirmation.html # Post-payment confirmation receipt
│   │   │   ├── orders.html             # Customer order tracking ledger
│   │   │   ├── order_detail.html       # Order shipment tracking & timeline
│   │   │   └── order_invoice.html      # HTML printable tax invoice
│   │   ├── base.html               # Shared luxury app shell & staff sidebar
│   │   ├── home.html               # Public showcase, hero slider & collections
│   │   ├── login.html              # Staff portal login
│   │   ├── dashboard.html          # Executive KPI overview & charts
│   │   ├── products.html           # In-store inventory catalogue
│   │   ├── product_form.html       # Inventory piece editor with uploads & specs
│   │   ├── customers.html          # Client CRM directory
│   │   ├── customer_detail.html    # Client profile, in-store & online orders
│   │   ├── customer_form.html      # Client registration form
│   │   ├── categories.html         # Manager category management
│   │   ├── category_form.html      # Add / Edit category form
│   │   ├── orders_list.html        # Manager online orders management
│   │   ├── order_detail_staff.html # Manager order inspection & status updater
│   │   ├── billing.html            # Two-panel POS billing calculator
│   │   ├── invoice.html            # In-store statutory A4 tax invoice
│   │   ├── invoices.html           # Historical invoice audit register
│   │   ├── reports.html            # BI analytics & revenue visualizations
│   │   ├── employees.html          # Staff directory & role privileges (Admin)
│   │   ├── employee_form.html      # Employee credentials editor (Admin)
│   │   ├── metal_rates.html        # Daily bullion market rates & audit log
│   │   ├── 403.html                # Access forbidden error page
│   │   └── 404.html                # Not-found error page
│   ├── css/
│   │   └── style.css               # Shared luxury stylesheet (E-Commerce block at end)
│   ├── js/
│   │   ├── main.js                 # UI interactions, toasts, sidebar toggle
│   │   ├── slider.js               # Homepage editorial hero slider
│   │   ├── billing.js              # Live POS billing calculator & stock validation
│   │   └── reports.js              # Chart.js initialization from embedded JSON
│   └── images/
│       ├── products/               # Customer uploaded jewellery piece photography
│       ├── hero-1.jpg              # Gold bridal choker necklace
│       ├── hero-2.jpg              # Solitaire diamond ring close-up
│       ├── hero-3.jpg              # Traditional Indian bridal jewellery
│       ├── cat-gold.jpg            # 22K Heritage Gold tile
│       ├── cat-silver.jpg          # 925 Sterling Silver tile
│       ├── cat-diamond.jpg         # Certified Solitaires tile
│       ├── cat-platinum.jpg        # Pure 950 Platinum tile
│       ├── cat-gems.jpg            # Precious Gemstones tile
│       ├── login-bg.jpg            # Editorial login split-screen backdrop
│       └── about.jpg               # Master goldsmith atelier craft
├── backend/                        # STRICTLY 3 Python Files
│   ├── app.py                      # Flask server, route controllers, auth, PDF generator
│   ├── db.py                       # MySQL connection pool & transactional query runner
│   └── config.py                   # Environment configuration loader
├── sql/                            # Database Migration & Backup Assets
│   ├── backup_before_ecommerce.sql # Exact mysqldump before any e-commerce changes
│   ├── migration_ecommerce.sql     # Additive schema migration script (run once)
│   ├── seed_ecommerce.sql          # Seed data for categories, sample orders & backfill
│   └── rollback_ecommerce.sql      # Clean rollback script (drops only new objects)
├── screenshots/                    # Before & After UI Verification Screenshots
│   ├── before/                     # 34 desktop & mobile screenshots of original UI
│   └── after/                      # 34 identical screenshots + 26 new e-commerce views
├── .env                            # Database connection settings & Flask configuration
├── requirements.txt                # Python dependencies (Pillow, reportlab added)
├── start.sh                        # Unified startup script
└── README.md                       # Comprehensive documentation
```

---

## 🛠️ Prerequisites & Installation

1. **Python**: Python 3.10 or higher.
2. **MySQL Server**: MySQL 8.0+ running on `localhost:3306`.
3. **Database**: Existing `vijayraj_jewellery` database.

### Installation Steps

```bash
# 1. Navigate to project root
cd "Vijayraj Gems and Jewellery Shop Management System"

# 2. Activate Python virtual environment
source venv/bin/activate

# 3. Install required dependencies
pip install -r requirements.txt
```

---

## 🗄️ Database Migration Execution

If setting up on a fresh clone or applying to an existing database:

```bash
# Step 1: Backup current database (already archived in sql/backup_before_ecommerce.sql)
mysqldump -u root -p vijayraj_jewellery > sql/backup_before_ecommerce.sql

# Step 2: Apply additive schema migration (new tables and columns only)
mysql -u root -p vijayraj_jewellery < sql/migration_ecommerce.sql

# Step 3: Seed categories, backfill product categories, and add sample orders
mysql -u root -p vijayraj_jewellery < sql/seed_ecommerce.sql

# (Optional) To cleanly roll back e-commerce additions without altering original data:
# mysql -u root -p vijayraj_jewellery < sql/rollback_ecommerce.sql
```

---

## 🚀 Running the Application

### Option A: Unified Startup Script (Recommended)
```bash
chmod +x start.sh
./start.sh
```

### Option B: Direct Python Launch
```bash
source venv/bin/activate
python backend/app.py
```
Application URL: **http://127.0.0.1:5001**

---

## 🔐 Demo Credentials

| Role | Username / Email | Password | Privileges & Notes |
|:---|:---|:---|:---|
| **Online Customer** | `demo@customer.com` | `Customer@123` | Online store shopping, cart, checkout, payment, order tracking, PDF tax invoice download |
| **Store Manager** | `rohit.mgr` | `Rohit@456` | Management Portal: Online Orders, Shop Categories, Products, Customers, Billing, Invoices, Reports |
| **System Admin** | `admin` | `Admin@123` | Full access: All manager features + Employee user accounts + System database backup |
| **Floor Staff** | `amit.staff` | `Amit@789` | In-store POS billing, inventory viewing, client registration (no manager/order dispatch access) |

---

## 💳 Simulated Payment Gateway Rules

The payment portal simulates an automated payment gateway with real-time inventory locking (`SELECT ... FOR UPDATE`):

| Mechanism | Test Input | Outcome & Behavior |
|:---|:---|:---|
| **Card (Success)** | `4111 1111 1111 1111` | **Success**: Locks stock, decrements inventory, generates `OINV-2026-XXXXX` invoice, sets status to `Confirmed`/`Paid`, clears shopping cart. |
| **Card (Declined)** | `4000 0000 0000 0002` | **Declined**: Logs failure reason, order remains `Pending`/`Failed`, inventory preserved, allows customer retry. |
| **Card (Other)** | Any valid 16-digit card | **Success**: Processes settlement normally. |
| **UPI (Success)** | e.g. `customer@okaxis` | **Success**: Confirms order settlement. |
| **UPI (Failure)** | Any ID with `fail` (e.g. `fail@upi`) | **Failed**: Simulates bank VPA gateway rejection. |
| **NetBanking** | Any bank selection | **Success**: Direct institutional clearance. |

*Security Notice: Card numbers, CVV, and UPI PINs are never stored in the database.*

---

## 🌐 Complete Routes Directory

### Public & Customer Routes
| Route | Method | Description |
|:---|:---:|:---|
| `/` | GET | Public luxury homepage with dynamic collections, featured pieces, new arrivals, and bullion rates |
| `/shop` | GET | Public catalog with category filter, search query, price sliders, stock filter, and server pagination |
| `/shop/<id>` | GET | Product showcase with high-res gallery, technical specs, purity, stock warning, and related pieces |
| `/account/register` | GET, POST | Customer registration with automatic phone linkage to existing client records |
| `/account/login` | GET, POST | Customer portal authentication (segregated from staff accounts) |
| `/account/logout` | GET | Customer logout |
| `/cart` | GET | Shopping bag with live stock verification, subtotal, 3% GST, and free delivery thresholds |
| `/cart/add` | POST | Add piece to shopping bag or execute direct "Buy Now" flow |
| `/cart/update` | POST | Increment / decrement / update item quantities bounded by available inventory |
| `/cart/remove` | POST | Remove piece from shopping bag |
| `/checkout` | GET, POST | Shipping address collection & validation; creates order in `Pending` state (no stock decrement) |
| `/payment/<id>` | GET, POST | Simulated payment gateway interface and transactional stock decrement |
| `/order-confirmation/<id>` | GET | Order confirmation, statutory invoice reference, and receipt |
| `/account/orders` | GET | Customer order history with dispatch tracking badges |
| `/account/orders/<id>` | GET | Customer order shipment timeline, item snapshots, and payment retry (IDOR protected) |
| `/account/orders/<id>/invoice` | GET | Print-ready HTML tax invoice |
| `/account/orders/<id>/invoice/pdf`| GET | Statutory PDF tax invoice download generated via ReportLab (IDOR protected) |

### Staff & Management Routes (Manager / Admin Only)
| Route | Method | Description |
|:---|:---:|:---|
| `/login` | GET, POST | Staff portal sign-in |
| `/logout` | GET | Staff portal sign-out |
| `/dashboard` | GET | Executive overview with in-store sales + "Total Online Orders" & "Online Sales" KPI cards |
| `/orders` | GET | Online store orders ledger with search, status filters, date range, and pagination |
| `/orders/<id>` | GET | Staff order audit with customer dossier, payment history, and status state-machine updater |
| `/orders/<id>/status` | POST | State machine transition: `Pending` -> `Confirmed`/`Cancelled`; `Confirmed` -> `Shipped`; `Shipped` -> `Delivered`. Cancelling a paid order restores inventory and marks payment `Refunded`. |
| `/orders/<id>/invoice/pdf` | GET | Manager download of statutory PDF tax invoice for any paid order |
| `/categories` | GET | Shop categories list with active product counts |
| `/categories/add` | GET, POST | Create category with slug, description, and curated photography |
| `/categories/<id>/edit` | GET, POST | Update category details and image |
| `/categories/<id>/delete` | POST | Safe category deletion; automatically soft-deactivates if products are linked |
| `/products` | GET | In-store inventory catalogue |
| `/products/add` | GET, POST | Add jewellery piece with e-commerce fields (`category_id`, type, stone, specs, image upload) |
| `/products/<id>/edit` | GET, POST | Update inventory piece, stock, price, and gallery photos |
| `/products/<id>/delete` | POST | Soft-deletes (`is_active = 0`) if piece is referenced in existing orders or invoices |
| `/customers` | GET | Client directory and search |
| `/customers/<id>` | GET | Client ledger with in-store invoices + online store order history & account status |
| `/billing` | GET, POST | In-store POS billing screen |
| `/invoices` | GET | In-store historical tax invoices register |
| `/invoices/<id>` | GET | In-store tax invoice view |
| `/reports` | GET | Business intelligence dashboard powered by MySQL views |
| `/metal-rates` | GET, POST | Bullion spot rate updates |
| `/employees` | GET | Staff administration (Admin only) |
| `/backup` | GET | MySQL database dump download (Admin only) |

---

## 📜 Written Confirmations

### (A) Database Additive Changes Confirmation
- **Zero Schema Disruptions**: No existing table, column, view, stored procedure, or trigger was dropped, renamed, modified, or truncated.
- **Untouched Original Objects**: Pre-existing tables (`users`, `customers`, `products`, `invoices`, `invoice_items`, `metal_rates`), views (`v_monthly_sales`, `v_sales_by_category`, `v_sales_by_payment_mode`, `v_top_products`, `v_low_stock`), procedures (`sp_generate_invoice`, `sp_update_stock`), and triggers (`trg_after_invoice_insert`, `trg_after_invoice_item_insert`) remain in their original state.
- **Additive Elements Added**:
  1. `customer_accounts` table
  2. `categories` table
  3. `product_images` table
  4. `cart_items` table
  5. `orders` table
  6. `order_items` table
  7. `payments` table
  8. `order_status_history` table
  9. Added 7 nullable/defaulted columns to `products`: `category_id`, `jewellery_type`, `stone_type`, `specifications`, `is_featured`, `is_active`, `created_at`.
- All changes documented in `sql/migration_ecommerce.sql` and reversible via `sql/rollback_ecommerce.sql`.

### (B) UI Freeze Confirmation
- **Zero Style Overwrites**: Not a single existing CSS rule in `frontend/css/style.css` was altered or deleted.
- **Dedicated Extension Block**: All e-commerce styles reside strictly inside one clearly marked section at the end of `style.css` (`/* ════ E-COMMERCE EXTENSIONS (ADDITIVE ONLY) ════ */`), using existing CSS variables (`--primary-navy`, `--accent-gold`, `--bg-ivory`, `--border-warm`, `--font-serif`, etc.).
- **Allowed Page Enhancements Only**:
  - Home page navbar: Added subtle search bar, shopping bag icon with dynamic badge count, and Customer Account link.
  - Home page sections: Collections tiles link to `/shop?category=...`, dynamic Featured Pieces, New Arrivals, and Popular Pieces rows reuse existing `.product-card`.
  - Staff sidebar: Added "Online Orders" and "Shop Categories" navigation items matching existing iconography and active states.
  - Manager dashboard: Added "Total Online Orders" and "Online Sales" KPI cards matching the exact KPI card structure.
  - Product editor: Added e-commerce fields (category, type, stone, specifications, featured, active, and photo uploader).
  - Customer detail page: Added online registration badge and "Online Store Orders" table.
  - Login page: Added small "Customer Sign In" link.
- **Before / After Screenshots**: All 34 original views (desktop and mobile) were captured before changes in `screenshots/before/` and verified identical after changes in `screenshots/after/`.

---

## 🧪 Comprehensive Browser & Automated Test Report

A comprehensive automated test suite (`scratch/verify_ecommerce_flows.py`) was executed against the running application covering all flows with **100% test pass rate**:

1. **Customer Registration & Authentication**:
   - Registered new customer (`priya.sharma_...`) with validated 10-digit mobile and 8-character password.
   - Tested automatic linkage to `customers` table without duplicate entries.
   - Verified session segregation (`session['user_type'] = 'customer'`).
2. **Catalog Browsing, Filter & Search**:
   - Tested public catalog `/shop`, category filtering (`/shop?category=diamond-rings`), query search (`/shop?q=Solitaire`), and price filtering.
   - Verified server-side pagination with item counts.
   - Verified product detail `/shop/1` with image fallback, technical specs, purity, and available stock badges.
3. **Shopping Bag Operations**:
   - Added product to cart, viewed `/cart`, verified automatic calculations for 3% GST and free shipping above ₹10,000.
   - Tested quantity increment and decrement bounded by available inventory.
4. **Checkout & Order Creation**:
   - Tested shipping destination form with 10-digit phone and 6-digit PIN validation.
   - Verified that order creation places the order in `Pending` status with **NO stock decrement** during checkout.
5. **Payment Simulation (Failure & Retry Flow)**:
   - Attempted payment with card `4000 0000 0000 0002` -> correctly rejected with bank decline notice; order remained `Pending`/`Failed`; stock remained intact.
   - Retried with card `4111 1111 1111 1111` -> successfully authorized; atomically locked stock with `SELECT ... FOR UPDATE`, decremented inventory inside transaction, assigned statutory invoice `OINV-2026-XXXXX`, confirmed order, and cleared customer cart.
6. **Order Confirmation & Statutory Invoices**:
   - Verified order confirmation receipt with itemized totals and transaction reference.
   - Verified customer order history in `/account/orders` and tracking timeline in `/account/orders/<id>`.
   - Verified HTML tax invoice and generated statutory PDF Tax Invoice via ReportLab with valid PDF header and binary structure.
7. **IDOR Security Verification**:
   - Created a separate customer session (Customer B) and attempted to access Customer A's order detail and PDF invoice -> returned `404 Not Found` / `403 Forbidden`, confirming zero IDOR vulnerability.
8. **Manager Workflow & Inventory Restock**:
   - Authenticated as store manager (`rohit.mgr` / `Rohit@456`).
   - Inspected online orders list `/orders` with KPI filters.
   - Updated order status from `Confirmed` to `Shipped`.
   - Tested order cancellation on a paid order: verified status updated to `Cancelled`, payment status set to `Refunded`, and product inventory automatically restored.
9. **Regression Testing**:
   - Verified in-store POS billing (`/billing`), sales invoices register (`/invoices`), business reports (`/reports`), bullion spot rates (`/metal-rates`), and employee admin (`/employees`) remain fully operational with zero regressions.

---

## 📷 Image Credits & Licensing
All stock imagery used for categories and product demonstration is sourced exclusively from royalty-free, commercial-free licenses on Unsplash and Pexels. No proprietary brand imagery was used.
