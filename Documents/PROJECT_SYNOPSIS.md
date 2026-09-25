# 💎 Vijayraj Gems and Jewellery Shop Management System
## Academic & Technical Project Synopsis

---

### 1. Project Identification
- **Project Title**: Vijayraj Gems and Jewellery Shop Management System
- **Domain**: Enterprise Resource Planning (ERP) / Retail Point of Sale (POS) & Inventory Management
- **Key Beneficiary**: Retail Jewellery Store Management and Sales Staff

---

### 2. Technology Stack
- **Frontend Layer**: Semantic HTML5, Vanilla CSS3 (Custom Gold & White theme), ES6+ Vanilla JavaScript (Fetch API, Chart.js for data visualization).
- **Backend Layer**: Python 3.10+ with Flask Web Micro-framework (Modular Blueprint Architecture).
- **Database Layer**: MySQL 9.5 (Relational tables with foreign key constraints, Stored Procedures, Views, and Triggers).
- **Driver**: PyMySQL with Connection Pooling and Parameterized Queries (SQL Injection Prevention).
- **Security**: PBKDF2 Password Hashing (Werkzeug Security), Secure HttpOnly & SameSite Session Cookies.

---

### 3. Folder Organization
1. **`Frontend/`**: HTML presentation pages (`dashboard.html`, `billing.html`, `products.html`, `customers.html`, `invoices.html`, `reports.html`, `employees.html`, `metal_rates.html`, `login.html`), custom CSS (`css/style.css`), and UI/API JavaScript handlers (`js/api.js`, `js/ui.js`).
2. **`Backend/`**: Core Flask application (`app.py`), configuration management (`config.py`), database layer (`db.py`), package dependencies (`requirements.txt`), and utility scripts (`scripts/`).
3. **`Database/`**: Complete database definitions (`schema.sql`), 50-record seed data (`seed.sql`), stored procedures & triggers (`procedures.sql`), and database snapshots (`backups/`).
4. **`Documents/`**: Project documentation, thesis/report documents (`archita.docx`), presentation/wireframe specifications (`project.pdf`), and comprehensive README.
5. **`Private (api's)/`**: Sensitive environment configuration (`.env`), modular REST API route controllers (`blueprints/`), and endpoint specifications (`API_DOCUMENTATION.md`).

---

### 4. Key Functional Modules
1. **Authentication & Role-Based Authorization**:
   - Distinct roles: `Admin`, `Manager`, `Staff`.
   - Access control via route decorators `@login_required` and `@role_required`.
2. **Real-time Inventory & Stock Tracking**:
   - Multi-category support (Gold, Silver, Diamond, Platinum, Gems) with purity categorization (24K, 22K, 18K, 925).
   - Dynamic weight, making charge, and low stock threshold tracking.
3. **Customer Relationship & Loyalty Management**:
   - Unique customer sequence numbering (`C01`, `C02`, ...).
   - Automated reward calculation: 1 loyalty point per ₹1,000 billed.
4. **Point of Sale (POS) & Tax Invoicing**:
   - Fast customer mobile number search and item auto-fill.
   - Statutory 3% jewellery GST automatic calculation.
   - Print-optimized tax invoices with legal hallmark disclaimers.
5. **Business Intelligence & Analytics**:
   - Interactive charts powered by MySQL Views (`v_monthly_sales`, `v_sales_by_category`, `v_top_products`, `v_low_stock`).
   - One-click CSV auditing export.
6. **Disaster Recovery & Backup**:
   - Automated MySQL dump generation and direct file download for store owners.
