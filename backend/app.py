"""
Vijayraj Gems and Jewellery Shop Management System
Main Flask Application Server (Server-side Jinja2 Rendering, No APIs)
"""
import os
import sys
import secrets
import json
import csv
import io
import subprocess
import time
from datetime import datetime, date
from urllib.parse import urlparse
from functools import wraps

from flask import (
    Flask, render_template, request, redirect, url_for,
    session, flash, abort, make_response, send_file, Response, jsonify
)
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import secure_filename
from PIL import Image

# ReportLab for Statutory PDF Tax Invoice Generation
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, HRFlowable
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle

# Add backend directory to sys.path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from config import Config
from db import query, execute, callproc, transaction, get_connection

# ── Flask Application Setup ──────────────────────────────────────────────────
app = Flask(
    __name__,
    template_folder="../frontend/html",
    static_folder="../frontend",
    static_url_path="/static"
)
app.secret_key = Config.SECRET_KEY
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
app.config['PERMANENT_SESSION_LIFETIME'] = 7200  # 2 hours

# Category to local image mapping
CATEGORY_IMAGES = {
    'Diamond': '/static/images/products/diamond-solitaire.jpg',
    'Diamond Rings': '/static/images/products/diamond-solitaire.jpg',
    'Gemstone Rings': '/static/images/products/emerald-ring.jpg',
    'Diamond Necklaces': '/static/images/products/diamond-choker.jpg',
    'Gemstone Necklaces': '/static/images/products/ruby-necklace.jpg',
    'Earrings': '/static/images/products/diamond-earrings-1.jpg',
    'Bracelets': '/static/images/products/diamond-bracelet-1.jpg',
    'Pendants': '/static/images/products/diamond-pendant-1.jpg',
    'Jewellery Sets': '/static/images/products/kundan-choker.jpg',
    'Gems': '/static/images/products/gemstone-ruby.jpg',
    'Default': '/static/images/products/diamond-solitaire.jpg'
}


def get_product_image_url(product):
    """Resolve product image URL with hierarchical fallback."""
    if not product:
        return CATEGORY_IMAGES['Default']
    if product.get('id'):
        img = query("SELECT image_path FROM product_images WHERE product_id = %s ORDER BY sort_order ASC, id ASC LIMIT 1", (product['id'],), fetchone=True)
        if img and img.get('image_path'):
            return f"/static/images/{img['image_path']}"
    if product.get('category_image'):
        return f"/static/images/{product['category_image']}"
    return CATEGORY_IMAGES.get(product.get('category'), CATEGORY_IMAGES['Default'])


# ── Helper Functions & Jinja Filters ─────────────────────────────────────────

def format_inr(number):
    """Format numeric value as Indian Rupees (e.g. ₹12,34,567.89)."""
    if number is None:
        return "₹0.00"
    try:
        val = float(number)
    except (ValueError, TypeError):
        return f"₹{number}"
    
    is_neg = val < 0
    val = abs(val)
    parts = f"{val:.2f}".split(".")
    integer_part = parts[0]
    decimal_part = parts[1]
    
    if len(integer_part) <= 3:
        res = integer_part
    else:
        last3 = integer_part[-3:]
        other = integer_part[:-3]
        groups = []
        while len(other) > 2:
            groups.insert(0, other[-2:])
            other = other[:-2]
        if other:
            groups.insert(0, other)
        res = ",".join(groups) + "," + last3
    
    formatted = ("-" if is_neg else "") + "₹" + res + "." + decimal_part
    return formatted


def number_to_words(number):
    """Convert an amount in INR to formal words for invoice printing."""
    try:
        n = int(round(float(number)))
    except (ValueError, TypeError):
        return ""
    
    if n == 0:
        return "Zero Rupees Only"
    
    ones = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
            "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen",
            "Seventeen", "Eighteen", "Nineteen"]
    tens = ["", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"]
    
    def two_digits(num):
        if num < 20:
            return ones[num]
        return tens[num // 10] + (" " + ones[num % 10] if num % 10 != 0 else "")
    
    def three_digits(num):
        h = num // 100
        rem = num % 100
        res = ""
        if h > 0:
            res += ones[h] + " Hundred"
            if rem > 0:
                res += " and "
        if rem > 0:
            res += two_digits(rem)
        return res

    parts = []
    crore = n // 10000000
    n %= 10000000
    lakh = n // 100000
    n %= 100000
    thousand = n // 1000
    n %= 1000
    remainder = n

    if crore > 0:
        parts.append(two_digits(crore) + " Crore")
    if lakh > 0:
        parts.append(two_digits(lakh) + " Lakh")
    if thousand > 0:
        parts.append(two_digits(thousand) + " Thousand")
    if remainder > 0:
        parts.append(three_digits(remainder))

    return " ".join(parts).strip() + " Rupees Only"


# Register filters and context processors
app.jinja_env.filters['inr'] = format_inr
app.jinja_env.filters['words'] = number_to_words


@app.context_processor
def inject_global_template_vars():
    """Make common variables available to all Jinja templates."""
    # Ensure CSRF token is present in session
    if 'csrf_token' not in session:
        session['csrf_token'] = secrets.token_hex(24)

    # Cart count calculation for logged-in customer
    cart_count = 0
    if session.get('user_type') == 'customer' and session.get('account_id'):
        res = query(
            "SELECT COALESCE(SUM(quantity), 0) as cnt FROM cart_items WHERE account_id = %s",
            (session['account_id'],),
            fetchone=True
        )
        if res:
            cart_count = int(res['cnt'])

    customer_account = None
    if session.get('user_type') == 'customer' and session.get('account_id'):
        customer_account = {
            'id': session.get('account_id'),
            'customer_id': session.get('customer_id'),
            'email': session.get('customer_email'),
            'name': session.get('customer_name')
        }

    return {
        'csrf_token': session['csrf_token'],
        'current_user': {
            'id': session.get('user_id'),
            'username': session.get('username'),
            'full_name': session.get('full_name'),
            'role': session.get('role')
        } if (session.get('user_id') and session.get('user_type') == 'staff') else None,
        'current_customer': customer_account,
        'cart_count': cart_count,
        'category_images': CATEGORY_IMAGES,
        'current_year': datetime.now().year,
        'today_date': date.today(),
        'config': Config
    }


# ── CSRF Protection ──────────────────────────────────────────────────────────

@app.before_request
def csrf_protect():
    """Enforce CSRF verification on all POST/PUT/DELETE requests."""
    if request.method in ('POST', 'PUT', 'DELETE'):
        token = request.form.get('csrf_token') or request.headers.get('X-CSRFToken')
        if not token or token != session.get('csrf_token'):
            flash('Security validation failed (CSRF token mismatch). Please try again.', 'danger')
            return redirect(request.referrer or url_for('home'))


# ── Authentication & Access Control Decorators ───────────────────────────────

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('user_id') or session.get('user_type') != 'staff':
            flash('Please sign in to access the management workspace.', 'warning')
            return redirect(url_for('login', next=request.path))
        return f(*args, **kwargs)
    return decorated_function


def role_required(*allowed_roles):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not session.get('user_id') or session.get('user_type') != 'staff':
                return redirect(url_for('login', next=request.path))
            user_role = session.get('role', 'staff')
            if user_role not in allowed_roles:
                return render_template('403.html', role=user_role, required_roles=allowed_roles), 403
            return f(*args, **kwargs)
        return decorated_function
    return decorator


def customer_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # Allow staff (shopkeepers) to use cart, checkout and billing for boutique clients
        if session.get('user_id') and session.get('user_type') == 'staff':
            if not session.get('account_id'):
                session['account_id'] = 1
            return f(*args, **kwargs)
        if not session.get('account_id') or session.get('user_type') != 'customer':
            flash('Please sign in to continue.', 'info')
            return redirect(url_for('customer_login', next=request.path))
        return f(*args, **kwargs)
    return decorated_function


_market_rates_cache = {'data': None, 'time': 0}

def get_latest_market_rates():
    """
    Retrieve prevailing diamond, gemstone, and precious metal mounting benchmark rates with fast cache (60s TTL).
    """
    now = time.time()
    if _market_rates_cache['data'] and (now - _market_rates_cache['time']) < 60:
        return _market_rates_cache['data']

    stone_benchmarks = [
        {'id': 9001, 'rate_date': date.today(), 'metal': 'Solitaire Diamond (1ct VVS1 EF)', 'rate_per_gram': 85000.00, 'unit': 'ct'},
        {'id': 9002, 'rate_date': date.today(), 'metal': 'Colombian Emerald (Panna)', 'rate_per_gram': 35000.00, 'unit': 'ct'},
        {'id': 9003, 'rate_date': date.today(), 'metal': 'Burmese Ruby (Manik)', 'rate_per_gram': 42000.00, 'unit': 'ct'},
        {'id': 9004, 'rate_date': date.today(), 'metal': 'Ceylon Sapphire (Neelam)', 'rate_per_gram': 38000.00, 'unit': 'ct'},
        {'id': 9005, 'rate_date': date.today(), 'metal': 'Yellow Sapphire (Pukhraj)', 'rate_per_gram': 26000.00, 'unit': 'ct'},
        {'id': 9006, 'rate_date': date.today(), 'metal': 'Natural Basra Pearl', 'rate_per_gram': 12000.00, 'unit': 'ct'},
        {'id': 9007, 'rate_date': date.today(), 'metal': 'Natural Tanzanite', 'rate_per_gram': 22000.00, 'unit': 'ct'},
        {'id': 9008, 'rate_date': date.today(), 'metal': '18K Gold Setting (Mount)', 'rate_per_gram': 6120.00, 'unit': 'g'},
        {'id': 9009, 'rate_date': date.today(), 'metal': 'Pt950 Platinum Setting', 'rate_per_gram': 3630.00, 'unit': 'g'},
        {'id': 9010, 'rate_date': date.today(), 'metal': '925 Sterling Silver Setting', 'rate_per_gram': 98.00, 'unit': 'g'}
    ]

    _market_rates_cache['data'] = stone_benchmarks
    _market_rates_cache['time'] = now
    return stone_benchmarks


# ── Public Routes (No Login Required) ────────────────────────────────────────

@app.route('/favicon.ico')
def favicon():
    diamond_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#C9A24B"><polygon points="6,3 18,3 22,9 12,22 2,9" stroke="#C9A24B" stroke-width="1.5" fill="#C9A24B" fill-opacity="0.85"/></svg>'
    return Response(diamond_svg, mimetype='image/svg+xml')


@app.route('/')
def home():
    """
    Public luxury brand homepage.
    Hero slider, collections showcase, featured pieces, new arrivals, popular pieces, live metal rates.
    """
    # Active boutique categories
    categories = query("SELECT * FROM categories WHERE is_active = 1 ORDER BY id ASC")

    # Fetch featured jewellery pieces from database
    featured_products = query("""
        SELECT p.*, c.name as category_name, c.slug as category_slug, c.image_path as category_image
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE p.is_active = 1 AND p.is_featured = 1
        ORDER BY p.price DESC
        LIMIT 8
    """)
    for p in featured_products:
        p['image_url'] = get_product_image_url(p)

    # New arrivals (newest by id / created_at)
    new_arrivals = query("""
        SELECT p.*, c.name as category_name, c.slug as category_slug, c.image_path as category_image
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE p.is_active = 1
        ORDER BY p.created_at DESC, p.id DESC
        LIMIT 4
    """)
    for p in new_arrivals:
        p['image_url'] = get_product_image_url(p)

    # Popular products (most units sold across order_items and invoice_items)
    popular_products = query("""
        SELECT p.*, c.name as category_name, c.slug as category_slug, c.image_path as category_image,
               (COALESCE((SELECT SUM(oi.quantity) FROM order_items oi WHERE oi.product_id = p.id), 0) +
                COALESCE((SELECT SUM(ii.quantity) FROM invoice_items ii WHERE ii.product_id = p.id), 0)) as total_sold
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE p.is_active = 1
        ORDER BY total_sold DESC, p.id ASC
        LIMIT 4
    """)
    for p in popular_products:
        p['image_url'] = get_product_image_url(p)

    # Fetch today's / latest metal rates (Gold, Silver, Platinum, Diamond)
    latest_rates = get_latest_market_rates()
    rates_payload = [{'metal': r['metal'], 'rate': float(r['rate_per_gram'])} for r in latest_rates]

    return render_template(
        'home.html',
        categories=categories,
        featured_products=featured_products,
        new_arrivals=new_arrivals,
        popular_products=popular_products,
        metal_rates=latest_rates,
        market_rates_json=json.dumps(rates_payload)
    )


@app.route('/login', methods=['GET', 'POST'])
def login():
    """Sign-in route with full-height luxury split layout and role dispatch."""
    if session.get('user_id') and session.get('user_type') == 'staff':
        return redirect(url_for('dashboard'))

    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')

        if not username or not password:
            flash('Please enter both username and password.', 'warning')
            return render_template('login.html')

        user = query(
            "SELECT * FROM users WHERE username = %s AND is_active = 1",
            (username,),
            fetchone=True
        )

        if user and check_password_hash(user['password_hash'], password):
            session.clear()
            session['user_type'] = 'staff'
            session['user_id'] = user['id']
            session['username'] = user['username']
            session['full_name'] = user['full_name']
            session['role'] = user['role']
            session['csrf_token'] = secrets.token_hex(24)

            flash(f"Welcome back, {user['full_name']}!", 'success')
            next_url = request.args.get('next')
            if next_url and next_url.startswith('/') and not next_url.startswith('//'):
                return redirect(next_url)
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid username, password, or inactive account.', 'danger')

    return render_template('login.html')


@app.route('/logout', methods=['POST', 'GET'])
def logout():
    """Clear session and redirect to login."""
    session.clear()
    flash('You have been logged out securely.', 'info')
    return redirect(url_for('login'))


# ── Dashboard ────────────────────────────────────────────────────────────────

@app.route('/dashboard')
@login_required
def dashboard():
    """Executive KPI dashboard with embedded Chart.js analytics data."""
    # Summary KPI numbers
    prod_cnt = query("SELECT COUNT(*) as cnt FROM products", fetchone=True)['cnt']
    cust_cnt = query("SELECT COUNT(*) as cnt FROM customers", fetchone=True)['cnt']
    
    # Today's sales from invoices
    today_stats = query("""
        SELECT COUNT(*) as cnt, COALESCE(SUM(grand_total), 0) as total
        FROM invoices
        WHERE DATE(invoice_date) = CURDATE()
    """, fetchone=True)
    
    # Month's sales
    month_stats = query("""
        SELECT COUNT(*) as cnt, COALESCE(SUM(grand_total), 0) as total
        FROM invoices
        WHERE YEAR(invoice_date) = YEAR(CURDATE()) AND MONTH(invoice_date) = MONTH(CURDATE())
    """, fetchone=True)
    
    # Low stock count
    low_stock = query("SELECT COUNT(*) as cnt FROM v_low_stock", fetchone=True)['cnt']

    # Total revenue
    total_rev = query("SELECT COALESCE(SUM(grand_total), 0) as total FROM invoices", fetchone=True)['total']

    # Latest metal rates
    latest_rates = get_latest_market_rates()
    rates_payload = [{'metal': r['metal'], 'rate': float(r['rate_per_gram'])} for r in latest_rates]

    # Recent 6 invoices with customer name
    recent_invoices = query("""
        SELECT i.id, i.invoice_no, i.invoice_date, i.grand_total, i.payment_mode,
               c.name as customer_name, c.customer_code
        FROM invoices i
        JOIN customers c ON c.id = i.customer_id
        ORDER BY i.invoice_date DESC
        LIMIT 6
    """)

    # Monthly sales trend for Chart.js (from v_monthly_sales view)
    monthly_sales_raw = query("""
        SELECT month_label, total_revenue, total_invoices
        FROM v_monthly_sales
        ORDER BY sale_year ASC, sale_month ASC
        LIMIT 12
    """)
    chart_labels = [r['month_label'] for r in monthly_sales_raw]
    chart_revenues = [float(r['total_revenue']) for r in monthly_sales_raw]

    # Category distribution for Doughnut Chart (from v_sales_by_category view)
    cat_sales_raw = query("SELECT category, total_revenue FROM v_sales_by_category")
    cat_labels = [r['category'] for r in cat_sales_raw]
    cat_data = [float(r['total_revenue']) for r in cat_sales_raw]

    # E-Commerce KPI metrics
    order_stats = query("""
        SELECT COUNT(*) as total_orders,
               COUNT(CASE WHEN order_status = 'Pending' THEN 1 END) as pending_orders,
               COALESCE(SUM(CASE WHEN payment_status = 'Paid' AND order_status != 'Cancelled' THEN grand_total ELSE 0 END), 0) as online_sales
        FROM orders
    """, fetchone=True)
    total_orders = int(order_stats['total_orders']) if order_stats else 0
    pending_orders = int(order_stats['pending_orders']) if order_stats else 0
    online_sales = float(order_stats['online_sales']) if order_stats else 0.0

    chart_payload = {
        'months': chart_labels,
        'revenues': chart_revenues,
        'categories': cat_labels,
        'cat_revenues': cat_data
    }

    return render_template(
        'dashboard.html',
        stats={
            'total_products': prod_cnt,
            'total_customers': cust_cnt,
            'today_sales': float(today_stats['total']),
            'today_invoices': today_stats['cnt'],
            'month_sales': float(month_stats['total']),
            'month_invoices': month_stats['cnt'],
            'low_stock_count': low_stock,
            'total_revenue': float(total_rev),
            'total_orders': total_orders,
            'pending_orders': pending_orders,
            'online_sales': online_sales
        },
        metal_rates=latest_rates,
        market_rates_json=json.dumps(rates_payload),
        recent_invoices=recent_invoices,
        chart_data_json=json.dumps(chart_payload)
    )


# ── Products Management (CRUD) ───────────────────────────────────────────────

@app.route('/products')
@login_required
def products_list():
    """Browse inventory with search, category filtering, purity, and pagination."""
    q_search = request.args.get('q', '').strip()
    category = request.args.get('category', '').strip()
    stock_status = request.args.get('stock_status', '').strip()
    sort_by = request.args.get('sort', 'code_asc')
    page = max(1, int(request.args.get('page', 1)))
    per_page = 12

    conditions = []
    params = []

    if q_search:
        conditions.append("(product_code LIKE %s OR name LIKE %s OR description LIKE %s)")
        params.extend([f"%{q_search}%", f"%{q_search}%", f"%{q_search}%"])
    if category:
        conditions.append("category = %s")
        params.append(category)
    if stock_status == 'low':
        conditions.append("stock_qty <= reorder_level")
    elif stock_status == 'out':
        conditions.append("stock_qty = 0")
    elif stock_status == 'in':
        conditions.append("stock_qty > 0")

    where_clause = " WHERE " + " AND ".join(conditions) if conditions else ""

    sort_sql = {
        'code_asc': 'product_code ASC',
        'price_asc': 'price ASC',
        'price_desc': 'price DESC',
        'stock_asc': 'stock_qty ASC',
        'name_asc': 'name ASC'
    }.get(sort_by, 'product_code ASC')

    # Total count
    cnt_row = query(f"SELECT COUNT(*) as cnt FROM products{where_clause}", params, fetchone=True)
    total_count = cnt_row['cnt']
    total_pages = max(1, (total_count + per_page - 1) // per_page)
    offset = (page - 1) * per_page

    products = query(
        f"SELECT * FROM products{where_clause} ORDER BY {sort_sql} LIMIT %s OFFSET %s",
        params + [per_page, offset]
    )

    categories = ['Diamond', 'Gems']

    return render_template(
        'products.html',
        products=products,
        categories=categories,
        current_category=category,
        q=q_search,
        stock_status=stock_status,
        sort=sort_by,
        page=page,
        total_pages=total_pages,
        total_count=total_count
    )


@app.route('/products/add', methods=['GET', 'POST'])
@login_required
@role_required('admin', 'manager', 'staff')
def product_add():
    """Create a new jewellery item in inventory."""
    shop_categories = query("SELECT id, name FROM categories WHERE is_active = 1 ORDER BY name")

    if request.method == 'POST':
        product_code = request.form.get('product_code', '').strip().upper()
        name = request.form.get('name', '').strip()
        category = request.form.get('category', '').strip()
        purity = request.form.get('purity', '').strip()
        weight_grams = float(request.form.get('weight_grams') or 0.0)
        making_charge = float(request.form.get('making_charge') or 0.0)
        price = float(request.form.get('price') or 0.0)
        stock_qty = int(request.form.get('stock_qty') or 0)
        reorder_level = int(request.form.get('reorder_level') or 5)
        design_code = request.form.get('design_code', '').strip()
        description = request.form.get('description', '').strip()

        # E-commerce fields
        category_id_val = request.form.get('category_id')
        category_id = int(category_id_val) if category_id_val and category_id_val.isdigit() else None
        jewellery_type = request.form.get('jewellery_type', '').strip() or None
        stone_type = request.form.get('stone_type', '').strip() or None
        specifications = request.form.get('specifications', '').strip() or None
        is_featured = 1 if request.form.get('is_featured') else 0
        is_active = 1 if request.form.get('is_active') else 0

        if not product_code or not name or not category or price <= 0:
            flash('Product code, name, category, and a positive price are required.', 'danger')
            return render_template('product_form.html', product=request.form, shop_categories=shop_categories, is_edit=False)

        # Check duplicate code
        existing = query("SELECT id FROM products WHERE product_code = %s", (product_code,), fetchone=True)
        if existing:
            flash(f'Product code "{product_code}" already exists.', 'danger')
            return render_template('product_form.html', product=request.form, shop_categories=shop_categories, is_edit=False)

        new_prod_id, _ = execute("""
            INSERT INTO products (product_code, name, category, purity, weight_grams,
                                  making_charge, price, stock_qty, reorder_level, design_code, description,
                                  category_id, jewellery_type, stone_type, specifications, is_featured, is_active)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (product_code, name, category, purity, weight_grams, making_charge, price,
              stock_qty, reorder_level, design_code, description,
              category_id, jewellery_type, stone_type, specifications, is_featured, is_active))

        # Handle image uploads
        files = request.files.getlist('images')
        sort_order = 0
        for f in files:
            if f and f.filename:
                ext = f.filename.rsplit('.', 1)[-1].lower() if '.' in f.filename else ''
                if ext in Config.ALLOWED_EXTENSIONS:
                    try:
                        img = Image.open(f)
                        img.verify()
                        f.seek(0)
                        img = Image.open(f)
                        if img.mode in ('RGBA', 'P'):
                            img = img.convert('RGB')
                        img.thumbnail((1200, 1200), Image.Resampling.LANCZOS)
                        rand_filename = f"{secrets.token_hex(8)}_{secure_filename(f.filename)}"
                        save_path = os.path.join(Config.UPLOAD_FOLDER, rand_filename)
                        img.save(save_path, 'JPEG', quality=88, optimize=True)
                        rel_path = f"products/{rand_filename}"
                        execute("INSERT INTO product_images (product_id, image_path, sort_order) VALUES (%s, %s, %s)",
                                (new_prod_id, rel_path, sort_order))
                        sort_order += 1
                    except Exception:
                        pass

        flash(f'Product "{name}" ({product_code}) added to inventory successfully.', 'success')
        return redirect(url_for('products_list'))

    return render_template('product_form.html', product={}, shop_categories=shop_categories, is_edit=False)


@app.route('/products/<int:id>/edit', methods=['GET', 'POST'])
@login_required
@role_required('admin', 'manager', 'staff')
def product_edit(id):
    """Edit existing product details, e-commerce fields, and imagery."""
    prod = query("SELECT * FROM products WHERE id = %s", (id,), fetchone=True)
    if not prod:
        flash('Product not found.', 'danger')
        return redirect(url_for('products_list'))

    shop_categories = query("SELECT id, name FROM categories WHERE is_active = 1 ORDER BY name")
    product_images = query("SELECT * FROM product_images WHERE product_id = %s ORDER BY sort_order ASC, id ASC", (id,))

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        category = request.form.get('category', '').strip()
        purity = request.form.get('purity', '').strip()
        weight_grams = float(request.form.get('weight_grams') or 0.0)
        making_charge = float(request.form.get('making_charge') or 0.0)
        price = float(request.form.get('price') or 0.0)
        stock_qty = int(request.form.get('stock_qty') or 0)
        reorder_level = int(request.form.get('reorder_level') or 5)
        design_code = request.form.get('design_code', '').strip()
        description = request.form.get('description', '').strip()

        # E-commerce fields
        category_id_val = request.form.get('category_id')
        category_id = int(category_id_val) if category_id_val and category_id_val.isdigit() else None
        jewellery_type = request.form.get('jewellery_type', '').strip() or None
        stone_type = request.form.get('stone_type', '').strip() or None
        specifications = request.form.get('specifications', '').strip() or None
        is_featured = 1 if request.form.get('is_featured') else 0
        is_active = 1 if request.form.get('is_active') else 0

        if not name or not category or price <= 0:
            flash('Name, category, and a positive price are required.', 'danger')
            return render_template('product_form.html', product=prod, shop_categories=shop_categories, product_images=product_images, is_edit=True)

        execute("""
            UPDATE products
            SET name=%s, category=%s, purity=%s, weight_grams=%s, making_charge=%s,
                price=%s, stock_qty=%s, reorder_level=%s, design_code=%s, description=%s,
                category_id=%s, jewellery_type=%s, stone_type=%s, specifications=%s,
                is_featured=%s, is_active=%s
            WHERE id=%s
        """, (name, category, purity, weight_grams, making_charge, price, stock_qty,
              reorder_level, design_code, description,
              category_id, jewellery_type, stone_type, specifications,
              is_featured, is_active, id))

        # Handle image uploads
        files = request.files.getlist('images')
        curr_max_order = query("SELECT COALESCE(MAX(sort_order), -1) as max_o FROM product_images WHERE product_id = %s", (id,), fetchone=True)['max_o']
        sort_order = curr_max_order + 1

        for f in files:
            if f and f.filename:
                ext = f.filename.rsplit('.', 1)[-1].lower() if '.' in f.filename else ''
                if ext in Config.ALLOWED_EXTENSIONS:
                    try:
                        img = Image.open(f)
                        img.verify()
                        f.seek(0)
                        img = Image.open(f)
                        if img.mode in ('RGBA', 'P'):
                            img = img.convert('RGB')
                        img.thumbnail((1200, 1200), Image.Resampling.LANCZOS)
                        rand_filename = f"{secrets.token_hex(8)}_{secure_filename(f.filename)}"
                        save_path = os.path.join(Config.UPLOAD_FOLDER, rand_filename)
                        img.save(save_path, 'JPEG', quality=88, optimize=True)
                        rel_path = f"products/{rand_filename}"
                        execute("INSERT INTO product_images (product_id, image_path, sort_order) VALUES (%s, %s, %s)",
                                (id, rel_path, sort_order))
                        sort_order += 1
                    except Exception:
                        pass

        flash(f'Product "{name}" updated successfully.', 'success')
        return redirect(url_for('products_list'))

    return render_template('product_form.html', product=prod, shop_categories=shop_categories, product_images=product_images, is_edit=True)


@app.route('/products/<int:id>/delete', methods=['POST'])
@login_required
@role_required('admin')
def product_delete(id):
    """Delete a product from inventory (Admin only) with safe soft-delete if referenced."""
    in_invoices = query("SELECT id FROM invoice_items WHERE product_id = %s LIMIT 1", (id,), fetchone=True)
    in_orders = query("SELECT id FROM order_items WHERE product_id = %s LIMIT 1", (id,), fetchone=True)
    
    if in_invoices or in_orders:
        execute("UPDATE products SET is_active = 0 WHERE id = %s", (id,))
        flash('Product is referenced in sales or order records and has been deactivated (is_active = 0) instead of permanently deleted.', 'warning')
        return redirect(url_for('products_list'))

    execute("DELETE FROM products WHERE id = %s", (id,))
    flash('Product removed from catalogue.', 'success')
    return redirect(url_for('products_list'))


# ── Customer Relationship Management (CRUD) ──────────────────────────────────

@app.route('/customers')
@login_required
def customers_list():
    """Browse customer directory with search and pagination."""
    q_search = request.args.get('q', '').strip()
    city = request.args.get('city', '').strip()
    page = max(1, int(request.args.get('page', 1)))
    per_page = 15

    conditions = []
    params = []

    if q_search:
        conditions.append("(customer_code LIKE %s OR name LIKE %s OR phone LIKE %s OR email LIKE %s)")
        params.extend([f"%{q_search}%", f"%{q_search}%", f"%{q_search}%", f"%{q_search}%"])
    if city:
        conditions.append("city = %s")
        params.append(city)

    where_clause = " WHERE " + " AND ".join(conditions) if conditions else ""

    cnt_row = query(f"SELECT COUNT(*) as cnt FROM customers{where_clause}", params, fetchone=True)
    total_count = cnt_row['cnt']
    total_pages = max(1, (total_count + per_page - 1) // per_page)
    offset = (page - 1) * per_page

    customers = query(
        f"SELECT * FROM customers{where_clause} ORDER BY id DESC LIMIT %s OFFSET %s",
        params + [per_page, offset]
    )

    cities = [r['city'] for r in query("SELECT DISTINCT city FROM customers WHERE city IS NOT NULL ORDER BY city")]

    return render_template(
        'customers.html',
        customers=customers,
        cities=cities,
        current_city=city,
        q=q_search,
        page=page,
        total_pages=total_pages,
        total_count=total_count
    )


@app.route('/customers/add', methods=['GET', 'POST'])
@login_required
def customer_add():
    """Register a new customer profile."""
    # Compute next customer code (e.g. C51)
    last_cust = query("SELECT customer_code FROM customers ORDER BY id DESC LIMIT 1", fetchone=True)
    next_num = 1
    if last_cust and last_cust['customer_code']:
        try:
            next_num = int(last_cust['customer_code'].replace('C', '')) + 1
        except ValueError:
            next_num = 1
    next_code = f"C{next_num:02d}" if next_num < 100 else f"C{next_num}"

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        phone = request.form.get('phone', '').strip()
        email = request.form.get('email', '').strip()
        city = request.form.get('city', '').strip()
        address = request.form.get('address', '').strip()

        if not name or not phone:
            flash('Customer name and phone number are required.', 'danger')
            return render_template('customer_form.html', customer=request.form, next_code=next_code, is_edit=False)

        # Check phone uniqueness
        existing = query("SELECT id FROM customers WHERE phone = %s", (phone,), fetchone=True)
        if existing:
            flash(f'A customer with phone number {phone} is already registered.', 'danger')
            return render_template('customer_form.html', customer=request.form, next_code=next_code, is_edit=False)

        execute("""
            INSERT INTO customers (customer_code, name, phone, email, address, city, loyalty_points)
            VALUES (%s, %s, %s, %s, %s, %s, 0)
        """, (next_code, name, phone, email or None, address or None, city or None))

        flash(f'Customer "{name}" ({next_code}) registered successfully.', 'success')
        return redirect(url_for('customers_list'))

    return render_template('customer_form.html', customer={'customer_code': next_code}, next_code=next_code, is_edit=False)


@app.route('/customers/<int:id>')
@login_required
def customer_detail(id):
    """View customer profile and full purchase transaction history."""
    customer = query("SELECT * FROM customers WHERE id = %s", (id,), fetchone=True)
    if not customer:
        flash('Customer not found.', 'danger')
        return redirect(url_for('customers_list'))

    # Purchase invoices for this customer
    invoices = query("""
        SELECT i.*, u.full_name as billed_by
        FROM invoices i
        JOIN users u ON u.id = i.user_id
        WHERE i.customer_id = %s
        ORDER BY i.invoice_date DESC
    """, (id,))

    # Aggregate metrics
    summary = query("""
        SELECT COUNT(*) as total_orders,
               COALESCE(SUM(grand_total), 0) as total_spent,
               COALESCE(AVG(grand_total), 0) as avg_order
        FROM invoices
        WHERE customer_id = %s
    """, (id,), fetchone=True)

    # Online account and orders
    customer_account = query("SELECT * FROM customer_accounts WHERE customer_id = %s", (id,), fetchone=True)
    online_orders = query("SELECT * FROM orders WHERE customer_id = %s ORDER BY created_at DESC", (id,))

    return render_template(
        'customer_detail.html',
        customer=customer,
        invoices=invoices,
        summary=summary,
        customer_account=customer_account,
        online_orders=online_orders
    )


@app.route('/customers/<int:id>/edit', methods=['GET', 'POST'])
@login_required
def customer_edit(id):
    """Update customer details."""
    customer = query("SELECT * FROM customers WHERE id = %s", (id,), fetchone=True)
    if not customer:
        flash('Customer not found.', 'danger')
        return redirect(url_for('customers_list'))

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        phone = request.form.get('phone', '').strip()
        email = request.form.get('email', '').strip()
        city = request.form.get('city', '').strip()
        address = request.form.get('address', '').strip()

        if not name or not phone:
            flash('Customer name and phone number are required.', 'danger')
            return render_template('customer_form.html', customer=customer, is_edit=True)

        # Check phone conflict
        existing = query("SELECT id FROM customers WHERE phone = %s AND id != %s", (phone, id), fetchone=True)
        if existing:
            flash(f'Phone number {phone} is already used by another customer.', 'danger')
            return render_template('customer_form.html', customer=customer, is_edit=True)

        execute("""
            UPDATE customers
            SET name = %s, phone = %s, email = %s, city = %s, address = %s
            WHERE id = %s
        """, (name, phone, email or None, city or None, address or None, id))

        flash(f'Customer profile "{name}" updated.', 'success')
        return redirect(url_for('customer_detail', id=id))

    return render_template('customer_form.html', customer=customer, is_edit=True)


@app.route('/customers/<int:id>/delete', methods=['POST'])
@login_required
@role_required('admin')
def customer_delete(id):
    """Delete a customer record (Admin only)."""
    has_invoices = query("SELECT id FROM invoices WHERE customer_id = %s LIMIT 1", (id,), fetchone=True)
    if has_invoices:
        flash('Cannot delete this customer because invoice records exist for their account.', 'warning')
        return redirect(url_for('customer_detail', id=id))

    execute("DELETE FROM customers WHERE id = %s", (id,))
    flash('Customer record deleted.', 'success')
    return redirect(url_for('customers_list'))


# ── Billing & Point of Sale (POS) ────────────────────────────────────────────

@app.route('/billing', methods=['GET', 'POST'])
@login_required
def billing():
    """Redirect legacy POS billing to e-commerce manager orders."""
    return redirect(url_for('manager_orders'))


# ── Invoices & Printable Receipts ────────────────────────────────────────────

@app.route('/invoices')
@login_required
def invoices_list():
    """Redirect legacy invoices list to manager online orders."""
    return redirect(url_for('manager_orders'))


@app.route('/invoices/<int:id>')
def invoice_view(id):
    """View official Tax Invoice in browser for in-store invoice or online order."""
    inv = query("SELECT id FROM invoices WHERE id = %s", (id,), fetchone=True)
    if inv:
        return invoice_download(id, as_attachment=False)
    order = query("SELECT id FROM orders WHERE id = %s", (id,), fetchone=True)
    if order:
        return manager_order_invoice_view(id)
    flash('Invoice not found.', 'danger')
    return redirect(url_for('manager_orders' if (session.get('user_id') and session.get('user_type') == 'staff') else 'home'))


@app.route('/invoices/<int:id>/download')
def invoice_download(id, as_attachment=True):
    """Generate and trigger direct file download of standalone self-contained Tax Invoice."""
    invoice = query("""
        SELECT i.*, c.customer_code, c.name as customer_name, c.phone as customer_phone,
               c.email as customer_email, c.address as customer_address, c.city as customer_city,
               COALESCE(c.loyalty_points, 0) as loyalty_points,
               COALESCE(u.full_name, 'Vijayraj Admin') as billed_by
        FROM invoices i
        JOIN customers c ON c.id = i.customer_id
        LEFT JOIN users u ON u.id = i.user_id
        WHERE i.id = %s
    """, (id,), fetchone=True)

    if not invoice:
        flash('Invoice not found.', 'danger')
        return redirect(url_for('home'))

    items = query("""
        SELECT ii.*, p.product_code, p.name as product_name, p.category, p.purity,
               COALESCE(p.weight_grams, 0) as weight_grams,
               COALESCE(p.making_charge, 0) as making_charge
        FROM invoice_items ii
        JOIN products p ON p.id = ii.product_id
        WHERE ii.invoice_id = %s
        ORDER BY ii.id ASC
    """, (id,))

    amount_words = number_to_words(invoice['grand_total'])

    subtotal_val = float(invoice['subtotal'])
    disc_percent = float(invoice['discount_percent'] or 0)
    disc_val = (subtotal_val * disc_percent / 100) if disc_percent > 0 else 0
    gst_val = float(invoice['gst_amount'])
    grand_val = float(invoice['grand_total'])

    items_html = ""
    for idx, itm in enumerate(items, 1):
        mkg = float(itm.get('making_charge') or 0)
        items_html += f"""
      <tr>
        <td style="text-align:center; color:#6B7280; padding:12px 8px; vertical-align:middle;">{idx}</td>
        <td style="padding:12px 8px; vertical-align:middle;">
          <strong style="color:#0F1B2D; font-size:13px;">{itm['product_name']}</strong>
          <div style="font-size:11px; color:#6B7280; margin-top:2px;">Code: {itm['product_code']} &bull; Category: {itm['category']}</div>
        </td>
        <td style="text-align:center; padding:12px 8px; vertical-align:middle;"><span style="font-weight:600; color:#0F1B2D;">{itm['purity'] or 'VVS1'}</span></td>
        <td style="text-align:right; padding:12px 8px; vertical-align:middle;">{float(itm['weight_grams']):.3f}g</td>
        <td style="text-align:right; padding:12px 8px; vertical-align:middle;">₹{mkg:,.2f}</td>
        <td style="text-align:center; padding:12px 8px; vertical-align:middle;">{itm['quantity']}</td>
        <td style="text-align:right; padding:12px 8px; vertical-align:middle;">₹{float(itm['unit_price']):,.2f}</td>
        <td style="text-align:right; padding:12px 8px; vertical-align:middle;"><strong style="color:#0F1B2D;">₹{float(itm['line_total']):,.2f}</strong></td>
      </tr>"""

    standalone_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tax Invoice {invoice['invoice_no']} | Vijayraj Gems &amp; Jewellery | Fine Jewellery House</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;1,400&family=Inter:wght@400;500;600;700&display=swap');
  * {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    color: #1E2430;
    background: #FFFFFF;
    padding: 2.5rem 3rem;
    font-size: 13px;
    line-height: 1.5;
  }}
  .no-print-bar {{
    max-width: 860px;
    margin: 0 auto 1.5rem auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #0F1B2D;
    color: #FAF7F2;
    padding: 0.75rem 1.25rem;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(15,27,45,0.15);
  }}
  .btn-print {{
    background: #C9A24B;
    color: #0F1B2D;
    border: none;
    padding: 0.5rem 1.25rem;
    border-radius: 6px;
    font-weight: 700;
    cursor: pointer;
    font-size: 12px;
    letter-spacing: 0.5px;
  }}
  .btn-back {{
    background: transparent;
    color: #FAF7F2;
    border: 1px solid rgba(255,255,255,0.3);
    padding: 0.45rem 1rem;
    border-radius: 6px;
    font-size: 12px;
    text-decoration: none;
    cursor: pointer;
  }}
  .btn-back:hover {{
    background: rgba(255,255,255,0.1);
  }}
  .invoice-container {{
    max-width: 860px;
    margin: 0 auto;
    background: #FFFFFF;
    padding: 1rem 0;
  }}
  .invoice-header {{
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    border-bottom: 1px solid #E7E1D6;
    padding-bottom: 1.5rem;
    margin-bottom: 2rem;
  }}
  .invoice-brand h1 {{
    font-family: 'Playfair Display', Georgia, serif;
    font-size: 1.65rem;
    letter-spacing: 0.5px;
    color: #0F1B2D;
    font-weight: 700;
    margin: 0;
  }}
  .invoice-brand p {{
    font-size: 11px;
    color: #4B5563;
    margin-top: 0.4rem;
    line-height: 1.5;
  }}
  .invoice-meta {{
    text-align: right;
  }}
  .invoice-meta .title {{
    font-size: 11px;
    font-weight: 700;
    color: #0F1B2D;
    letter-spacing: 1px;
  }}
  .invoice-meta .sub {{
    font-size: 9px;
    text-transform: uppercase;
    color: #8A92A6;
    letter-spacing: 0.5px;
    margin-top: 1px;
  }}
  .invoice-number {{
    font-size: 1.35rem;
    font-weight: 700;
    color: #0F1B2D;
    margin: 4px 0;
  }}
  .invoice-meta .meta-lines {{
    font-size: 11px;
    color: #1E2430;
    line-height: 1.45;
  }}
  .customer-strip {{
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 2rem;
    margin-bottom: 2.5rem;
  }}
  .strip-overline {{
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 2px;
    color: #8A92A6;
    text-transform: uppercase;
    margin-bottom: 6px;
  }}
  .client-name {{
    font-size: 15px;
    font-weight: 700;
    color: #0F1B2D;
    margin-bottom: 3px;
  }}
  .client-info-line {{
    font-size: 11px;
    color: #1E2430;
    line-height: 1.45;
  }}
  .table {{
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 2rem;
  }}
  .table th {{
    color: #8A92A6;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #E7E1D6;
    padding: 10px 8px;
    text-align: left;
    background: transparent;
  }}
  .table td {{
    border-bottom: 1px solid #E7E1D6;
    font-size: 12px;
  }}
  .totals-grid {{
    display: flex;
    justify-content: flex-end;
    margin-bottom: 1.75rem;
  }}
  .totals-table {{
    width: 380px;
    border-collapse: collapse;
  }}
  .totals-table td {{
    padding: 6px 0;
    font-size: 13px;
    color: #1E2430;
  }}
  .grand-row td {{
    border-top: 1px solid #E7E1D6;
    padding-top: 10px;
    padding-bottom: 6px;
    font-weight: 700;
    font-size: 17px;
    color: #0F1B2D;
  }}
  .words-box {{
    border: 1px solid #E7E1D6;
    border-radius: 4px;
    padding: 12px 16px;
    margin-bottom: 2.5rem;
    background: #FAFAFA;
  }}
  .words-title {{
    font-size: 10px;
    font-weight: 700;
    color: #8A92A6;
    letter-spacing: 0.5px;
  }}
  .words-text {{
    font-size: 13px;
    font-weight: 700;
    color: #0F1B2D;
    margin-top: 3px;
  }}
  .terms-section {{
    margin-top: 2rem;
  }}
  .terms-title {{
    font-size: 11px;
    font-weight: 700;
    color: #0F1B2D;
    margin-bottom: 6px;
    letter-spacing: 0.5px;
  }}
  .terms-text {{
    font-size: 10px;
    color: #4B5563;
    line-height: 1.65;
    max-width: 440px;
  }}
  .sig-section {{
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-top: 3.5rem;
    padding-bottom: 1rem;
  }}
  .sig-box {{
    text-align: center;
    min-width: 220px;
  }}
  .sig-line {{
    border-top: 1px solid #0F1B2D;
    width: 100%;
    margin-bottom: 8px;
  }}
  .sig-label {{
    font-size: 11px;
    color: #0F1B2D;
    font-weight: 500;
  }}
  @media print {{
    body {{ background: #FFFFFF; padding: 0.5cm; }}
    .no-print-bar {{ display: none !important; }}
    .invoice-container {{ padding: 0; }}
  }}
</style>
</head>
<body>
<div class="no-print-bar">
  <div style="display:flex; align-items:center; gap:0.75rem;">
    <strong>VIJAYRAJ GEMS &amp; JEWELLERY</strong> &bull; Tax Invoice {invoice['invoice_no']}
  </div>
  <div style="display:flex; gap:0.5rem; align-items:center;">
    <a href="{url_for('home')}" class="btn-back">&larr; Return to Boutique</a>
    <a href="/invoices/{invoice['id']}/pdf" class="btn-print" style="text-decoration:none; display:inline-flex; align-items:center; gap:4px; background:#FAF7F2; color:#0F1B2D; border:1px solid #C9A24B;">Download Official PDF</a>
    <button class="btn-print" onclick="window.print()">Print / Save as PDF</button>
  </div>
</div>

<div class="invoice-container">
  <div class="invoice-header">
    <div class="invoice-brand">
      <div style="display:flex; align-items:center; gap:8px;">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#C9A24B" stroke-width="2">
          <path d="M6 3h12l4 6-10 12L2 9z"></path>
          <path d="M11 3v18"></path>
          <path d="M2 9h20"></path>
        </svg>
        <h1>VIJAYRAJ GEMS &amp; JEWELLERY</h1>
      </div>
      <p>
        Haute Joaillerie &bull; Certified Solitaires &bull; Precious Gemstones<br>
        C1, N Main Rd, near Loftman Clothing Lane, Damco Society, Koregaon Park, Pune 411001 &bull; Tel: +91 91723 87741<br>
        <strong>GSTIN:</strong> 27AAACV1234F1Z5 &bull; <strong>BIS HUID Licence:</strong> HM/C-7654321
      </p>
    </div>
    <div class="invoice-meta">
      <div class="title">TAX INVOICE</div>
      <div class="sub">STATUTORY DOCUMENT</div>
      <div class="invoice-number">{invoice['invoice_no']}</div>
      <div class="meta-lines">
        Date: <strong>{invoice['invoice_date'].strftime('%d %B %Y')}</strong><br>
        Time: {invoice['invoice_date'].strftime('%I:%M %p')}<br>
        Settlement: <strong style="color:#C9A24B;">{invoice['payment_mode']}</strong><br>
        Billed By: {invoice['billed_by']}
      </div>
    </div>
  </div>

  <div class="customer-strip">
    <div>
      <div class="strip-overline">C L I E N T &nbsp; P A R T I C U L A R S</div>
      <div class="client-name">{invoice['customer_name']}</div>
      <div class="client-info-line">Client Code: {invoice.get('customer_code', 'C54')}</div>
      <div class="client-info-line">Phone: {invoice.get('customer_phone', '—')}</div>
    </div>
    <div>
      <div class="strip-overline">B I L L I N G &nbsp; A D D R E S S</div>
      <div class="client-info-line">
        {invoice.get('customer_address') or 'Counter Sale (Boutique Walk-in)'}<br>
        {invoice.get('customer_city') or 'Pune'}
      </div>
      <div class="client-info-line" style="margin-top:4px;">Accumulated Loyalty Points: {invoice.get('loyalty_points', 0)} pts</div>
    </div>
  </div>

  <table class="table">
    <thead>
      <tr>
        <th style="width:25px; text-align:center;">#</th>
        <th>JEWELLERY SPECIFICATION</th>
        <th style="text-align:center;">PURITY</th>
        <th style="text-align:right;">NET WT.</th>
        <th style="text-align:right;">MAKING CHG</th>
        <th style="text-align:center;">QTY</th>
        <th style="text-align:right;">UNIT RATE</th>
        <th style="text-align:right;">AMOUNT (₹)</th>
      </tr>
    </thead>
    <tbody>
      {items_html}
    </tbody>
  </table>

  <div class="totals-grid">
    <table class="totals-table">
      <tr>
        <td>Subtotal (Gross Value):</td>
        <td style="text-align:right; font-weight:700; color:#0F1B2D;">₹{subtotal_val:,.2f}</td>
      </tr>
      <tr>
        <td>CGST (1.5%):</td>
        <td style="text-align:right; color:#0F1B2D;">₹{(gst_val/2):,.2f}</td>
      </tr>
      <tr>
        <td>SGST (1.5%):</td>
        <td style="text-align:right; color:#0F1B2D;">₹{(gst_val/2):,.2f}</td>
      </tr>
      <tr class="grand-row">
        <td>Grand Total:</td>
        <td style="text-align:right; color:#0F1B2D;">₹{grand_val:,.2f}</td>
      </tr>
    </table>
  </div>

  <div class="words-box">
    <div class="words-title">AMOUNT IN WORDS:</div>
    <div class="words-text">{amount_words}</div>
  </div>

  <div class="terms-section">
    <div class="terms-title">STATUTORY TERMS &amp; GUARANTEE:</div>
    <div class="terms-text">
      1. All gemstone and diamond jewellery mounts guaranteed 100% BIS Hallmarked with unique laser HUID.<br>
      2. Natural diamonds and gemstones certified under international grading standards (IGI / GIA).<br>
      3. Exchange and buyback acceptable at prevailing market gemstone and diamond benchmark rates.<br>
      4. Subject to Mumbai judicial jurisdiction.
    </div>
  </div>

  <div class="sig-section">
    <div class="sig-box" style="margin-left: 20px;">
      <div class="sig-line"></div>
      <div class="sig-label">Customer Signature</div>
    </div>
    <div class="sig-box" style="margin-right: 20px;">
      <div class="sig-line"></div>
      <div class="sig-label">For Vijayraj Gems &amp; Jewellery</div>
    </div>
  </div>
</div>
</body>
</html>
"""
    safe_filename = f"Vijayraj_Invoice_{invoice['invoice_no']}.html"
    disp = f'attachment; filename="{safe_filename}"' if as_attachment else 'inline'
    return Response(
        standalone_html,
        mimetype='text/html',
        headers={
            'Content-Disposition': disp,
            'Content-Type': 'text/html; charset=utf-8'
        }
    )


@app.route('/invoices/<int:id>/pdf')
def invoice_pdf_download(id):
    """Generate and trigger direct ReportLab PDF download of statutory GST Tax Invoice."""
    invoice = query("SELECT * FROM invoices WHERE id = %s", (id,), fetchone=True)
    if not invoice:
        flash("Tax invoice not found.", "danger")
        return redirect(url_for('home'))

    customer = query("SELECT * FROM customers WHERE id = %s", (invoice['customer_id'],), fetchone=True)

    order = query("SELECT * FROM orders WHERE invoice_no = %s LIMIT 1", (invoice['invoice_no'],), fetchone=True)
    if not order:
        order = {
            'order_no': f"DIR-{invoice['invoice_no']}",
            'invoice_no': invoice['invoice_no'],
            'created_at': invoice['invoice_date'],
            'ship_name': customer['name'] if customer else 'Valued Client',
            'ship_phone': customer['phone'] if customer else '—',
            'ship_address': customer['address'] if customer and customer['address'] else 'Counter Sale (Boutique Walk-in)',
            'ship_city': customer['city'] if customer and customer['city'] else 'Pune',
            'ship_state': 'Maharashtra',
            'ship_pincode': '411001',
            'subtotal': invoice['subtotal'],
            'gst_percent': invoice['gst_percent'],
            'gst_amount': invoice['gst_amount'],
            'delivery_charge': 0.00,
            'grand_total': invoice['grand_total'],
            'order_status': 'Confirmed',
            'payment_status': 'Paid'
        }

    items = query("""
        SELECT ii.quantity, ii.unit_price, ii.line_total,
               p.id as product_id, p.name as product_name, p.product_code, p.purity,
               COALESCE(p.weight_grams, 0) as weight_grams,
               COALESCE(p.making_charge, 0) as making_charge
        FROM invoice_items ii
        JOIN products p ON p.id = ii.product_id
        WHERE ii.invoice_id = %s
        ORDER BY ii.id ASC
    """, (id,))

    payment = {
        'method': invoice.get('payment_mode', 'Cash'),
        'amount': invoice['grand_total'],
        'transaction_ref': f"{invoice.get('payment_mode', 'CASH').upper()}-{invoice['invoice_no']}"
    }

    pdf_buffer = generate_order_pdf_invoice(order, items, payment, customer)
    filename = f"Vijayraj_Tax_Invoice_{invoice['invoice_no']}.pdf"

    return send_file(
        pdf_buffer,
        mimetype='application/pdf',
        as_attachment=True,
        download_name=filename
    )


# ── Analytics & Reports ──────────────────────────────────────────────────────

@app.route('/reports')
@login_required
@role_required('admin', 'manager')
def reports():
    """Business Intelligence dashboard powered by existing MySQL views."""
    # Monthly sales trend
    monthly_sales = query("""
        SELECT * FROM v_monthly_sales
        ORDER BY sale_year DESC, sale_month DESC
        LIMIT 12
    """)

    # Sales by jewellery category
    category_sales = query("SELECT * FROM v_sales_by_category ORDER BY total_revenue DESC")

    # Sales by payment mode
    payment_sales = query("SELECT * FROM v_sales_by_payment_mode ORDER BY total_revenue DESC")

    # Top selling jewellery pieces
    top_products = query("SELECT * FROM v_top_products LIMIT 10")

    # Low stock items nearing reorder threshold
    low_stock = query("SELECT * FROM v_low_stock ORDER BY stock_qty ASC")

    # Chart payload for frontend/js/reports.js
    monthly_rev_chronological = list(reversed(monthly_sales))
    chart_payload = {
        'months': [r['month_label'] for r in monthly_rev_chronological],
        'monthly_revenue': [float(r['total_revenue']) for r in monthly_rev_chronological],
        'categories': [r['category'] for r in category_sales],
        'category_revenue': [float(r['total_revenue']) for r in category_sales],
        'payments': [r['payment_mode'] for r in payment_sales],
        'payment_revenue': [float(r['total_revenue']) for r in payment_sales]
    }

    return redirect(url_for('dashboard'))


@app.route('/reports/export-csv')
@login_required
@role_required('admin', 'manager')
def export_csv():
    """Direct file download of sales, product, or customer reports in CSV format."""
    report_type = request.args.get('type', 'sales')
    output = io.StringIO()
    writer = csv.writer(output)

    if report_type == 'sales':
        filename = f"vijayraj_sales_report_{datetime.now().strftime('%Y%m%d')}.csv"
        writer.writerow(['Invoice No', 'Date', 'Customer Code', 'Customer Name', 'Phone', 'Payment Mode', 'Subtotal', 'Discount %', 'GST (3%)', 'Grand Total'])
        rows = query("""
            SELECT i.invoice_no, i.invoice_date, c.customer_code, c.name, c.phone,
                   i.payment_mode, i.subtotal, i.discount_percent, i.gst_amount, i.grand_total
            FROM invoices i
            JOIN customers c ON c.id = i.customer_id
            ORDER BY i.invoice_date DESC
        """)
        for r in rows:
            writer.writerow([r['invoice_no'], r['invoice_date'], r['customer_code'], r['name'], r['phone'],
                             r['payment_mode'], r['subtotal'], r['discount_percent'], r['gst_amount'], r['grand_total']])

    elif report_type == 'products':
        filename = f"vijayraj_inventory_report_{datetime.now().strftime('%Y%m%d')}.csv"
        writer.writerow(['Product Code', 'Name', 'Category', 'Purity', 'Weight (g)', 'Making Charge', 'Price', 'Stock Qty', 'Reorder Level'])
        rows = query("SELECT * FROM products ORDER BY category, product_code")
        for r in rows:
            writer.writerow([r['product_code'], r['name'], r['category'], r['purity'], r['weight_grams'],
                             r['making_charge'], r['price'], r['stock_qty'], r['reorder_level']])

    elif report_type == 'customers':
        filename = f"vijayraj_customers_report_{datetime.now().strftime('%Y%m%d')}.csv"
        writer.writerow(['Customer Code', 'Name', 'Phone', 'Email', 'City', 'Loyalty Points', 'Joined Date'])
        rows = query("SELECT customer_code, name, phone, email, city, loyalty_points, created_at FROM customers ORDER BY id DESC")
        for r in rows:
            writer.writerow([r['customer_code'], r['name'], r['phone'], r['email'], r['city'], r['loyalty_points'], r['created_at']])

    else:
        return "Invalid report type", 400

    output.seek(0)
    response = make_response(output.getvalue())
    response.headers['Content-Disposition'] = f'attachment; filename="{filename}"'
    response.headers['Content-Type'] = 'text/csv; charset=utf-8'
    return response


# ── Metal Rates Management ───────────────────────────────────────────────────

@app.route('/metal-rates', methods=['GET', 'POST'])
@login_required
@role_required('admin', 'manager')
def metal_rates():
    """Daily market rate updates and historical price log."""
    if request.method == 'POST':
        rate_date = request.form.get('rate_date') or str(date.today())
        metal_mapping = [
            ('Gold 24K', request.form.get('rate_gold_24k')),
            ('Gold 22K', request.form.get('rate_gold_22k')),
            ('Silver', request.form.get('rate_silver')),
            ('Platinum', request.form.get('rate_platinum')),
            ('Diamond', request.form.get('rate_diamond'))
        ]

        with transaction() as cur:
            for m, val in metal_mapping:
                if val:
                    rate = float(val)
                    # Check if already exists for date
                    cur.execute("SELECT id FROM metal_rates WHERE rate_date = %s AND metal = %s", (rate_date, m))
                    existing = cur.fetchone()
                    if existing:
                        cur.execute("UPDATE metal_rates SET rate_per_gram = %s WHERE id = %s", (rate, existing['id']))
                    else:
                        cur.execute("INSERT INTO metal_rates (rate_date, metal, rate_per_gram) VALUES (%s, %s, %s)",
                                    (rate_date, m, rate))

        flash(f'Market rates for Gold, Silver, Platinum, and Diamond updated for {rate_date}.', 'success')
        return redirect(url_for('metal_rates'))

    # Latest rates
    latest_rates = get_latest_market_rates()
    rates_payload = [{'metal': r['metal'], 'rate': float(r['rate_per_gram'])} for r in latest_rates]

    # Historical rate logs (most recent 40 entries)
    history = query("SELECT * FROM metal_rates ORDER BY rate_date DESC, metal ASC LIMIT 40")

    return redirect(url_for('dashboard'))


# ── Employee Management (Admin Only) ─────────────────────────────────────────

@app.route('/employees')
@login_required
@role_required('admin')
def employees_list():
    """List staff accounts and system administrators."""
    return redirect(url_for('dashboard'))


@app.route('/employees/add', methods=['GET', 'POST'])
@login_required
@role_required('admin')
def employee_add():
    return redirect(url_for('dashboard'))


@app.route('/employees/<int:id>/edit', methods=['GET', 'POST'])
@login_required
@role_required('admin')
def employee_edit(id):
    """Edit staff member profile and salary."""
    return redirect(url_for('dashboard'))


@app.route('/employees/<int:id>/toggle-active', methods=['POST'])
@login_required
@role_required('admin')
def employee_toggle_active(id):
    """Activate or deactivate user login access."""
    if id == session.get('user_id'):
        flash('You cannot deactivate your own active account.', 'warning')
        return redirect(url_for('employees_list'))

    user = query("SELECT is_active, full_name FROM users WHERE id = %s", (id,), fetchone=True)
    if user:
        new_status = 0 if user['is_active'] else 1
        execute("UPDATE users SET is_active = %s WHERE id = %s", (new_status, id))
        status_label = "activated" if new_status else "suspended"
        flash(f"Account for {user['full_name']} has been {status_label}.", 'info')

    return redirect(url_for('employees_list'))


@app.route('/employees/<int:id>/reset-password', methods=['POST'])
@login_required
@role_required('admin')
def employee_reset_password(id):
    """Reset an employee's password."""
    new_password = request.form.get('new_password', '').strip()
    if not new_password or len(new_password) < 6:
        flash('Password must be at least 6 characters long.', 'danger')
        return redirect(url_for('employees_list'))

    pw_hash = generate_password_hash(new_password, method='pbkdf2:sha256')
    execute("UPDATE users SET password_hash = %s WHERE id = %s", (pw_hash, id))
    flash('Password reset successfully.', 'success')
    return redirect(url_for('employees_list'))


# ── Database Backup (Admin Only) ─────────────────────────────────────────────

@app.route('/backup', methods=['GET', 'POST'])
@login_required
@role_required('admin')
def database_backup():
    """Generate a clean MySQL dump and serve it as a file download."""
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename = f"vijayraj_backup_{timestamp}.sql"
    
    cmd = [
        Config.MYSQL_DUMP_PATH,
        '-h', Config.DB_HOST,
        '-P', str(Config.DB_PORT),
        '-u', Config.DB_USER,
    ]
    if Config.DB_PASSWORD:
        cmd.append(f'-p{Config.DB_PASSWORD}')
    cmd.extend([
        '--routines',
        '--triggers',
        '--single-transaction',
        Config.DB_NAME
    ])

    try:
        proc = subprocess.run(cmd, capture_output=True, check=True)
        response = make_response(proc.stdout)
        response.headers['Content-Disposition'] = f'attachment; filename="{filename}"'
        response.headers['Content-Type'] = 'application/sql'
        return response
    except Exception as e:
        flash(f'Backup generation failed: {str(e)}', 'danger')
        return redirect(url_for('dashboard'))



# ── E-COMMERCE: Statutory Order PDF Generator ────────────────────────────────

def generate_order_pdf_invoice(order, items, payment, customer):
    """
    Generate high-end statutory PDF tax invoice using ReportLab for e-commerce orders.
    Matches the haute joaillerie aesthetic and statutory requirements.
    """
    buffer = io.BytesIO()
    doc = SimpleDocTemplate(
        buffer,
        pagesize=A4,
        rightMargin=36,
        leftMargin=36,
        topMargin=36,
        bottomMargin=36
    )

    styles = getSampleStyleSheet()

    sub_style = ParagraphStyle(
        'SubTitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8,
        leading=11,
        textColor=colors.HexColor('#6B7280')
    )
    meta_style = ParagraphStyle(
        'InvMeta',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8,
        leading=11,
        alignment=2,
        textColor=colors.HexColor('#1E2430')
    )
    cell_style = ParagraphStyle(
        'ItemCell',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8,
        leading=10,
        textColor=colors.HexColor('#1E2430')
    )

    elements = []

    # Header Table
    inv_date_str = order['created_at'].strftime('%d %b %Y') if order.get('created_at') else date.today().strftime('%d %b %Y')
    inv_no_display = order.get('invoice_no') or f"TEMP-{order.get('order_no')}"
    pay_method = payment.get('method', 'Online') if payment else 'Online'
    pay_txn = payment.get('transaction_ref', 'N/A') if payment else 'N/A'

    header_data = [
        [
            Paragraph(
                "<b>VIJAYRAJ GEMS &amp; JEWELLERY</b><br/>"
                "<font color='#C9A24B'><b>Haute Joaillerie &bull; Precious Gemstones &bull; Certified Solitaires</b></font><br/>"
                "C1, N Main Rd, near Loftman Clothing Lane, Damco Society, Koregaon Park, Pune 411 001<br/>"
                "Tel: +91 91723 87741 &bull; GSTIN: 27AAACV1234F1Z5 &bull; BIS HUID: HM/C-7654321",
                sub_style
            ),
            Paragraph(
                f"<b>TAX INVOICE</b><br/>"
                f"<font color='#C9A24B'><b>{inv_no_display}</b></font><br/>"
                f"Date: {inv_date_str}<br/>"
                f"Order Ref: {order.get('order_no')}<br/>"
                f"Payment: {pay_method} (PAID)<br/>"
                f"Txn Ref: {pay_txn}",
                meta_style
            )
        ]
    ]
    t_header = Table(header_data, colWidths=[330, 190])
    t_header.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
    ]))
    elements.append(t_header)

    elements.append(HRFlowable(width="100%", thickness=1.5, color=colors.HexColor('#C9A24B'), spaceBefore=4, spaceAfter=10))

    # Customer & Shipping Strip
    cust_name = customer.get('name') if customer else order.get('ship_name', 'Valued Client')
    cust_code = customer.get('customer_code', 'Online Client') if customer else 'Online Client'
    cust_phone = customer.get('phone') if customer else order.get('ship_phone', '—')

    ship_name = order.get('ship_name', cust_name)
    ship_addr = order.get('ship_address', '')
    ship_city = order.get('ship_city', '')
    ship_state = order.get('ship_state', '')
    ship_pin = order.get('ship_pincode', '')
    ship_phone = order.get('ship_phone', cust_phone)

    client_data = [
        [
            Paragraph(
                f"<b>CLIENT PARTICULARS:</b><br/>"
                f"<b>{cust_name}</b><br/>"
                f"Client ID: {cust_code}<br/>"
                f"Phone: {cust_phone}",
                sub_style
            ),
            Paragraph(
                f"<b>INSURED SHIPPING DESTINATION:</b><br/>"
                f"<b>{ship_name}</b><br/>"
                f"{ship_addr}<br/>"
                f"{ship_city}, {ship_state} - {ship_pin}<br/>"
                f"Contact: {ship_phone}",
                sub_style
            )
        ]
    ]
    t_client = Table(client_data, colWidths=[260, 260])
    t_client.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor('#FAF7F2')),
        ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor('#E7E1D6')),
        ('TOPPADDING', (0,0), (-1,-1), 8),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
        ('LEFTPADDING', (0,0), (-1,-1), 8),
        ('RIGHTPADDING', (0,0), (-1,-1), 8),
    ]))
    elements.append(t_client)
    elements.append(Spacer(1, 14))

    # Line Items Table
    item_header = [
        Paragraph("<b>#</b>", styles['Normal']),
        Paragraph("<b>Item Description</b>", styles['Normal']),
        Paragraph("<b>Purity</b>", styles['Normal']),
        Paragraph("<b>Qty</b>", styles['Normal']),
        Paragraph("<b>Unit Rate (₹)</b>", styles['Normal']),
        Paragraph("<b>Line Total (₹)</b>", styles['Normal'])
    ]
    items_rows = [item_header]

    for idx, itm in enumerate(items, 1):
        code_str = f"<br/><font size=7 color='#6B7280'>Code: {itm.get('product_code', '—')}</font>" if itm.get('product_code') else ""
        purity_val = itm.get('purity') or 'Hallmarked'
        unit_val = float(itm.get('unit_price') or 0.0)
        line_val = float(itm.get('line_total') or (unit_val * itm.get('quantity', 1)))

        items_rows.append([
            str(idx),
            Paragraph(f"<b>{itm.get('product_name', 'Jewellery Piece')}</b>{code_str}", cell_style),
            purity_val,
            str(itm.get('quantity', 1)),
            f"{unit_val:,.2f}",
            f"{line_val:,.2f}"
        ])

    t_items = Table(items_rows, colWidths=[25, 235, 55, 35, 85, 85])
    t_items.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor('#0F1B2D')),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('ALIGN', (0,0), (0,-1), 'CENTER'),
        ('ALIGN', (2,0), (2,-1), 'CENTER'),
        ('ALIGN', (3,0), (3,-1), 'CENTER'),
        ('ALIGN', (4,0), (-1,-1), 'RIGHT'),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('FONTSIZE', (0,0), (-1,0), 8),
        ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ('TOPPADDING', (0,0), (-1,-1), 6),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor('#E7E1D6')),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    elements.append(t_items)
    elements.append(Spacer(1, 10))

    # Summary Totals Table
    subtotal_val = float(order.get('subtotal') or 0.0)
    gst_val = float(order.get('gst_amount') or 0.0)
    del_val = float(order.get('delivery_charge') or 0.0)
    grand_val = float(order.get('grand_total') or 0.0)
    delivery_str = "FREE" if del_val == 0 else f"₹{del_val:,.2f}"

    totals_data = [
        ["", Paragraph("Taxable Subtotal:", meta_style), f"₹{subtotal_val:,.2f}"],
        ["", Paragraph("CGST (1.5%):", meta_style), f"₹{(gst_val/2):,.2f}"],
        ["", Paragraph("SGST (1.5%):", meta_style), f"₹{(gst_val/2):,.2f}"],
        ["", Paragraph("Insured Delivery:", meta_style), delivery_str],
        ["", Paragraph("<b>Total Payable:</b>", meta_style), f"<b>₹{grand_val:,.2f}</b>"]
    ]
    t_totals = Table(totals_data, colWidths=[250, 160, 110])
    t_totals.setStyle(TableStyle([
        ('ALIGN', (2,0), (2,-1), 'RIGHT'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('TOPPADDING', (0,0), (-1,-1), 3),
        ('BOTTOMPADDING', (0,0), (-1,-1), 3),
        ('LINEBELOW', (1,-1), (2,-1), 1.5, colors.HexColor('#0F1B2D')),
        ('LINEABOVE', (1,-1), (2,-1), 1.5, colors.HexColor('#0F1B2D')),
    ]))
    elements.append(t_totals)
    elements.append(Spacer(1, 12))

    # Amount in words
    amt_words = number_to_words(grand_val)
    w_data = [[
        Paragraph(f"<b>Amount in Words:</b> {amt_words}", sub_style)
    ]]
    t_words = Table(w_data, colWidths=[520])
    t_words.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor('#FAF7F2')),
        ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor('#C9A24B')),
        ('PADDING', (0,0), (-1,-1), 6),
    ]))
    elements.append(t_words)
    elements.append(Spacer(1, 12))

    # Footer Strip
    footer_data = [
        [
            Paragraph(
                "<b>Statutory Declarations &amp; Warranties:</b><br/>"
                "1. 100% BIS hallmarked gold &amp; certified natural diamonds/crystals.<br/>"
                "2. Insured transit with secure tamper-evident packaging.<br/>"
                "3. Customer service: conciergeservice@vijayrajjewels.in",
                sub_style
            ),
            Paragraph(
                "<br/><br/>____________________________<br/><b>Authorised Signatory</b><br/>Vijayraj Gems &amp; Jewellery",
                meta_style
            )
        ]
    ]
    t_footer = Table(footer_data, colWidths=[340, 180])
    t_footer.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('LINEABOVE', (0,0), (-1,-1), 0.5, colors.HexColor('#E7E1D6')),
        ('TOPPADDING', (0,0), (-1,-1), 8),
    ]))
    elements.append(t_footer)

    doc.build(elements)
    buffer.seek(0)
    return buffer


def generate_order_invoice_no():
    """Generate sequential, unique online tax invoice number (e.g. OINV-2026-00001)."""
    year = datetime.now().year
    prefix = f"OINV-{year}-"
    rows = query(
        "SELECT invoice_no FROM orders WHERE invoice_no LIKE %s",
        (f"{prefix}%",)
    )
    max_seq = 0
    existing_set = set()
    if rows:
        for r in rows:
            inv = r.get('invoice_no')
            if inv:
                existing_set.add(inv)
                try:
                    num = int(inv.split('-')[-1])
                    if num > max_seq:
                        max_seq = num
                except Exception:
                    pass

    seq = max_seq + 1
    candidate = f"{prefix}{seq:05d}"
    while candidate in existing_set:
        seq += 1
        candidate = f"{prefix}{seq:05d}"
    return candidate


def generate_upi_qr_svg(vpa, payee_name, amount, order_no):
    """Generate dynamic high-resolution vector SVG QR code for UPI payment."""
    try:
        import qrcode
        import qrcode.image.svg
        import io
        upi_url = f"upi://pay?pa={vpa}&pn={payee_name}&am={amount:.2f}&cu=INR&tn=Order+{order_no}"
        qr = qrcode.QRCode(
            version=None,
            error_correction=qrcode.constants.ERROR_CORRECT_M,
            box_size=10,
            border=1,
            image_factory=qrcode.image.svg.SvgPathImage
        )
        qr.add_data(upi_url)
        qr.make(fit=True)
        img = qr.make_image(attrib={'class': 'upi-qr-svg', 'width': '220', 'height': '220'})
        stream = io.BytesIO()
        img.save(stream)
        return stream.getvalue().decode('utf-8')
    except Exception:
        return None


def process_payment_simulation(order, method, form_data):
    """
    Simulated Payment Gateway outcome determination.
    Rules:
    - Card '4111 1111 1111 1111' -> Success
    - Card '4000 0000 0000 0002' -> Declined
    - Any other valid card -> Success
    - UPI QR Scan or valid UPI VPA -> Success
    - UPI VPA containing 'fail' (case-insensitive) -> Failed
    - NetBanking -> Success
    - Cash on Delivery (COD) -> Success
    Never stores card numbers, CVVs, or full UPI IDs.
    Returns: (is_success: bool, failure_reason: str or None)
    """
    if method == 'Card':
        card_num = form_data.get('card_number', '').replace(' ', '').replace('-', '').strip()
        card_name = form_data.get('card_name', '').strip()
        card_exp = form_data.get('card_expiry', '').strip()
        card_cvv = form_data.get('card_cvv', '').strip()

        if not card_num or not card_name or not card_exp or not card_cvv:
            return False, "Please enter all required credit/debit card information."
        if card_num == '4000000000000002':
            return False, "Card declined by card-issuing bank (Demo Simulation Rule)."
        return True, None

    elif method == 'UPI':
        upi_mode = form_data.get('upi_mode', 'qr')
        if upi_mode == 'qr':
            return True, None
        upi_id = form_data.get('upi_id', '').strip().lower()
        if not upi_id or '@' not in upi_id:
            return False, "Please provide a valid Virtual Payment Address (UPI ID format: user@upi) or scan the QR Code."
        if 'fail' in upi_id:
            return False, "UPI payment authorization rejected by issuing bank (Demo Simulation Rule)."
        return True, None

    elif method == 'NetBanking':
        bank_name = form_data.get('bank_name', '').strip()
        if not bank_name:
            return False, "Please select an authorized financial banking institution."
        return True, None

    elif method in ('Cash', 'COD'):
        return True, None

    return False, "Unsupported payment method requested."


# ── E-COMMERCE: Customer Authentication ──────────────────────────────────────

def get_safe_customer_redirect(next_url, default_endpoint='shop_catalog'):
    """Resolve next_url safely, supporting relative paths and same-host URLs."""
    if next_url:
        p = urlparse(next_url)
        # Check if relative path or internal host matching current request
        if not p.netloc or p.netloc == request.host:
            path = p.path or '/'
            if p.query:
                path += f"?{p.query}"
            if path.startswith('/') and not path.startswith('//'):
                return path
    return url_for(default_endpoint)


@app.route('/account/register', methods=['GET', 'POST'])
def customer_register():
    """Customer registration route with automated customer record linkage."""
    if session.get('user_type') == 'customer' and session.get('account_id'):
        return redirect(url_for('shop_catalog'))

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        email = request.form.get('email', '').strip().lower()
        phone = request.form.get('phone', '').strip()
        password = request.form.get('password', '')
        confirm_password = request.form.get('confirm_password', '')

        if not name or not email or not phone or not password:
            flash("All registration fields are required.", "danger")
            return render_template('shop/customer_register.html')

        if len(phone) != 10 or not phone.isdigit():
            flash("Please enter a valid 10-digit Indian mobile contact number.", "danger")
            return render_template('shop/customer_register.html')

        if len(password) < 8:
            flash("Password must be at least 8 characters in length for account security.", "danger")
            return render_template('shop/customer_register.html')

        if password != confirm_password:
            flash("Confirmation password does not match the entered password.", "danger")
            return render_template('shop/customer_register.html')

        # Check if email is already taken
        existing_acc = query("SELECT id FROM customer_accounts WHERE email = %s", (email,), fetchone=True)
        if existing_acc:
            flash("An online account with this email address already exists. Please sign in.", "warning")
            return redirect(url_for('customer_login'))

        # Check if phone exists in customers table
        existing_cust = query("SELECT id, name FROM customers WHERE phone = %s", (phone,), fetchone=True)
        if existing_cust:
            linked_acc = query("SELECT id FROM customer_accounts WHERE customer_id = %s", (existing_cust['id'],), fetchone=True)
            if linked_acc:
                flash("An online account is already associated with this mobile phone number. Please sign in.", "warning")
                return redirect(url_for('customer_login'))

        pw_hash = generate_password_hash(password, method='pbkdf2:sha256')

        with transaction() as cur:
            if existing_cust:
                cust_id = existing_cust['id']
                cur.execute("UPDATE customers SET email = COALESCE(email, %s) WHERE id = %s", (email, cust_id))
            else:
                last_c = query("SELECT customer_code FROM customers ORDER BY id DESC LIMIT 1", fetchone=True)
                if last_c and last_c['customer_code'] and last_c['customer_code'].startswith('C'):
                    try:
                        next_num = int(last_c['customer_code'][1:]) + 1
                        code = f"C{next_num:03d}"
                    except Exception:
                        code = f"C{secrets.randbelow(900)+100}"
                else:
                    code = "C001"
                cur.execute("""
                    INSERT INTO customers (customer_code, name, phone, email, created_at)
                    VALUES (%s, %s, %s, %s, NOW())
                """, (code, name, phone, email))
                cust_id = cur.lastrowid

            cur.execute("""
                INSERT INTO customer_accounts (customer_id, email, password_hash, is_active, created_at)
                VALUES (%s, %s, %s, 1, NOW())
            """, (cust_id, email, pw_hash))
            acc_id = cur.lastrowid

        session.clear()
        session['user_type'] = 'customer'
        session['account_id'] = acc_id
        session['customer_id'] = cust_id
        session['customer_email'] = email
        session['customer_name'] = name

        flash(f"Welcome to Vijayraj Gems & Jewellery, {name}! Your customer account is ready.", "success")
        return redirect(get_safe_customer_redirect(request.args.get('next')))

    return render_template('shop/customer_register.html')


@app.route('/account/login', methods=['GET', 'POST'])
def customer_login():
    """Customer account authentication separate from staff login."""
    if session.get('user_type') == 'customer' and session.get('account_id'):
        return redirect(url_for('shop_catalog'))

    if request.method == 'POST':
        email = request.form.get('email', '').strip().lower()
        password = request.form.get('password', '')

        if not email or not password:
            flash("Please provide both your registered email address and password.", "danger")
            return render_template('shop/customer_login.html')

        acc = query("""
            SELECT ca.*, c.name as customer_name
            FROM customer_accounts ca
            JOIN customers c ON c.id = ca.customer_id
            WHERE ca.email = %s
        """, (email,), fetchone=True)

        if not acc or not check_password_hash(acc['password_hash'], password):
            flash("Invalid email or password. Please verify your credentials.", "danger")
            return render_template('shop/customer_login.html')

        if not acc['is_active']:
            flash("Your customer account has been suspended. Please contact concierge support.", "danger")
            return render_template('shop/customer_login.html')

        execute("UPDATE customer_accounts SET last_login = NOW() WHERE id = %s", (acc['id'],))

        session.clear()
        session['user_type'] = 'customer'
        session['account_id'] = acc['id']
        session['customer_id'] = acc['customer_id']
        session['customer_email'] = acc['email']
        session['customer_name'] = acc['customer_name']

        flash(f"Welcome back, {acc['customer_name']}!", "success")
        return redirect(get_safe_customer_redirect(request.args.get('next')))

    return render_template('shop/customer_login.html')


@app.route('/account/logout')
def customer_logout():
    """Sign out customer and return to home page."""
    session.clear()
    flash("You have successfully signed out of your customer account.", "info")
    return redirect(url_for('home'))


# ── E-COMMERCE: Public Shop Catalog & Detail ─────────────────────────────────

@app.route('/shop')
def shop_catalog():
    """
    Public shop catalog with server-side filters: category, search query,
    price range, stock availability, and sorting with server pagination.
    """
    categories = query("""
        SELECT c.*, (SELECT COUNT(*) FROM products p WHERE p.category_id = c.id AND p.is_active = 1) as product_count
        FROM categories c WHERE c.is_active = 1 ORDER BY c.name ASC
    """)

    q_search = request.args.get('q', '').strip()
    cat_param = request.args.get('category', '').strip()
    cat_id_param = request.args.get('category_id', '').strip()
    min_price_str = request.args.get('min_price', '').strip()
    max_price_str = request.args.get('max_price', '').strip()
    in_stock = request.args.get('in_stock', '').strip()
    sort_by = request.args.get('sort', 'newest').strip()
    page = max(1, int(request.args.get('page', 1)))
    per_page = 12

    conditions = ["p.is_active = 1"]
    params = []

    selected_category = None
    if cat_id_param and cat_id_param.isdigit():
        conditions.append("p.category_id = %s")
        params.append(int(cat_id_param))
        selected_category = query("SELECT * FROM categories WHERE id = %s", (int(cat_id_param),), fetchone=True)
    elif cat_param:
        conditions.append("c.slug = %s")
        params.append(cat_param)
        selected_category = query("SELECT * FROM categories WHERE slug = %s", (cat_param,), fetchone=True)

    if q_search:
        conditions.append("(p.name LIKE %s OR p.description LIKE %s OR p.jewellery_type LIKE %s OR p.stone_type LIKE %s OR p.product_code LIKE %s)")
        params.extend([f"%{q_search}%", f"%{q_search}%", f"%{q_search}%", f"%{q_search}%", f"%{q_search}%"])

    if min_price_str:
        try:
            min_val = float(min_price_str)
            conditions.append("p.price >= %s")
            params.append(min_val)
        except ValueError:
            pass

    if max_price_str:
        try:
            max_val = float(max_price_str)
            conditions.append("p.price <= %s")
            params.append(max_val)
        except ValueError:
            pass

    if in_stock == '1':
        conditions.append("p.stock_qty > 0")

    where_clause = " WHERE " + " AND ".join(conditions)

    if sort_by == 'price_asc':
        order_clause = " ORDER BY p.price ASC, p.id DESC"
    elif sort_by == 'price_desc':
        order_clause = " ORDER BY p.price DESC, p.id DESC"
    else:
        order_clause = " ORDER BY p.created_at DESC, p.id DESC"

    count_sql = f"""
        SELECT COUNT(*) as total
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        {where_clause}
    """
    total_count = query(count_sql, tuple(params), fetchone=True)['total']
    total_pages = max(1, (total_count + per_page - 1) // per_page)
    offset = (page - 1) * per_page

    # Total active products count (unfiltered) for "All Collections" badge
    total_all_products = query("SELECT COUNT(*) as cnt FROM products WHERE is_active = 1", fetchone=True)['cnt']

    data_sql = f"""
        SELECT p.*, c.name as category_name, c.slug as category_slug, c.image_path as category_image
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        {where_clause}
        {order_clause}
        LIMIT %s OFFSET %s
    """
    p_params = list(params) + [per_page, offset]
    products = query(data_sql, tuple(p_params))

    for p in products:
        p['image_url'] = get_product_image_url(p)

    pagination = {
        'total': total_count,
        'page': page,
        'per_page': per_page,
        'total_pages': total_pages,
        'has_prev': page > 1,
        'has_next': page < total_pages
    }

    return render_template(
        'shop/shop.html',
        products=products,
        categories=categories,
        current_category=selected_category,
        selected_category_slug=selected_category['slug'] if selected_category else None,
        search_query=q_search,
        min_price=min_price_str,
        max_price=max_price_str,
        in_stock=in_stock,
        current_sort=sort_by,
        pagination=pagination,
        total_all_products=total_all_products,
        metal_rates=get_latest_market_rates()
    )


@app.route('/shop/<int:product_id>')
def product_detail_view(product_id):
    """Product showcase with image gallery, specifications, and related items."""
    product = query("""
        SELECT p.*, c.name as category_name, c.slug as category_slug, c.image_path as category_image
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE p.id = %s AND p.is_active = 1
    """, (product_id,), fetchone=True)

    if not product:
        flash("The requested jewellery piece is not available or inactive.", "warning")
        return redirect(url_for('shop_catalog'))

    images = query("SELECT * FROM product_images WHERE product_id = %s ORDER BY sort_order ASC, id ASC", (product_id,))
    product['image_url'] = get_product_image_url(product)

    # Build image gallery list for template (primary_image_url + all_images)
    primary_image_url = product['image_url']
    all_images = []
    if images:
        for img in images:
            all_images.append({'url': f"/static/images/{img['image_path']}"})
        primary_image_url = all_images[0]['url']
    else:
        all_images.append({'url': product['image_url']})

    related_products = query("""
        SELECT p.*, c.name as category_name, c.slug as category_slug, c.image_path as category_image
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE p.category_id = %s AND p.id != %s AND p.is_active = 1
        ORDER BY p.price DESC
        LIMIT 4
    """, (product['category_id'], product_id))
    for rp in related_products:
        rp['image_url'] = get_product_image_url(rp)

    return render_template(
        'shop/product_detail.html',
        product=product,
        images=images,
        all_images=all_images,
        primary_image_url=primary_image_url,
        related_products=related_products
    )


# ── E-COMMERCE: Shopping Cart ────────────────────────────────────────────────

@app.route('/cart')
@customer_required
def view_cart():
    """Render customer cart with live stock validation and delivery calculation."""
    account_id = session['account_id']

    cart_rows = query("""
        SELECT ci.id as cart_item_id, ci.quantity, ci.added_at,
               p.id as product_id, p.name as product_name, p.product_code,
               p.price as unit_price, p.stock_qty, p.purity, p.weight_grams,
               p.is_active, c.name as category_name, c.slug as category_slug,
               c.image_path as category_image
        FROM cart_items ci
        JOIN products p ON p.id = ci.product_id
        LEFT JOIN categories c ON c.id = p.category_id
        WHERE ci.account_id = %s
        ORDER BY ci.added_at DESC
    """, (account_id,))

    items = []
    subtotal = 0.0
    has_adjusted_qty = False

    for row in cart_rows:
        if not row['is_active']:
            execute("DELETE FROM cart_items WHERE id = %s", (row['cart_item_id'],))
            has_adjusted_qty = True
            continue

        qty = row['quantity']
        stock = row['stock_qty']

        if stock <= 0:
            row['is_out_of_stock'] = True
            row['available_qty'] = 0
        elif qty > stock:
            qty = stock
            execute("UPDATE cart_items SET quantity = %s WHERE id = %s", (qty, row['cart_item_id']))
            has_adjusted_qty = True
            row['available_qty'] = stock
        else:
            row['available_qty'] = stock

        row['image_url'] = get_product_image_url(row)
        line_total = float(row['unit_price']) * qty
        row['line_total'] = line_total
        subtotal += line_total
        items.append(row)

    if has_adjusted_qty:
        flash("One or more item quantities in your cart were automatically adjusted based on live inventory.", "info")

    gst_amount = subtotal * (Config.GST_PERCENT / 100.0)
    delivery_charge = 0.0 if (subtotal >= Config.DELIVERY_FREE_THRESHOLD or subtotal == 0) else Config.DELIVERY_CHARGE_STANDARD
    grand_total = subtotal + gst_amount + delivery_charge

    return render_template(
        'shop/cart.html',
        items=items,
        cart_items=items,
        subtotal=subtotal,
        gst_percent=Config.GST_PERCENT,
        gst_amount=gst_amount,
        delivery_charge=delivery_charge,
        grand_total=grand_total,
        free_shipping_threshold=Config.DELIVERY_FREE_THRESHOLD
    )


@app.route('/cart/add', methods=['POST'])
def cart_add():
    """Add a product to cart or process direct 'Buy Now' flow without opening cart page."""
    account_id = None
    if session.get('account_id') and session.get('user_type') == 'customer':
        account_id = session['account_id']
    elif session.get('user_id') and session.get('user_type') == 'staff':
        account_id = session.get('staff_cart_account_id', 1)
        session['account_id'] = account_id
    else:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest' or request.is_json or 'application/json' in request.headers.get('Accept', ''):
            return jsonify({'success': False, 'message': 'Please sign in to add pieces to your cart.', 'redirect': url_for('customer_login')}), 401
        flash('Please sign in to add pieces to your shopping cart or place orders.', 'info')
        return redirect(url_for('customer_login', next=request.referrer or url_for('shop_catalog')))

    try:
        product_id = int(request.form.get('product_id'))
    except (TypeError, ValueError):
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest' or request.is_json:
            return jsonify({'success': False, 'message': 'Invalid product.'}), 400
        return redirect(request.referrer or url_for('shop_catalog'))

    quantity = max(1, int(request.form.get('quantity', 1)))
    buy_now = request.form.get('buy_now') == '1'

    prod = query("SELECT id, name, price, stock_qty, is_active FROM products WHERE id = %s", (product_id,), fetchone=True)
    if not prod or not prod['is_active']:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest' or request.is_json:
            return jsonify({'success': False, 'message': 'This jewellery piece is unavailable.'}), 400
        flash("This jewellery piece is unavailable.", "danger")
        return redirect(request.referrer or url_for('shop_catalog'))

    if prod['stock_qty'] <= 0:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest' or request.is_json:
            return jsonify({'success': False, 'message': f"'{prod['name']}' is currently out of stock."}), 400
        flash(f"'{prod['name']}' is currently out of stock.", "warning")
        return redirect(request.referrer or url_for('product_detail_view', product_id=product_id))

    capped_qty = min(quantity, prod['stock_qty'])

    existing = query("SELECT id, quantity FROM cart_items WHERE account_id = %s AND product_id = %s", (account_id, product_id), fetchone=True)
    if existing:
        new_q = min(existing['quantity'] + capped_qty, prod['stock_qty'])
        execute("UPDATE cart_items SET quantity = %s WHERE id = %s", (new_q, existing['id']))
    else:
        execute("INSERT INTO cart_items (account_id, product_id, quantity, added_at) VALUES (%s, %s, %s, NOW())",
                (account_id, product_id, capped_qty))

    if buy_now:
        return redirect(url_for('checkout_view'))

    count_res = query("SELECT COALESCE(SUM(quantity), 0) as cnt FROM cart_items WHERE account_id = %s", (account_id,), fetchone=True)
    new_cart_count = int(count_res['cnt']) if count_res else 0

    if request.headers.get('X-Requested-With') == 'XMLHttpRequest' or request.is_json or 'application/json' in request.headers.get('Accept', ''):
        return jsonify({
            'success': True,
            'message': f"Added {capped_qty} × '{prod['name']}' to your shopping cart.",
            'cart_count': new_cart_count,
            'product_name': prod['name'],
            'quantity': capped_qty
        })

    flash(f"Added {capped_qty} &times; '{prod['name']}' to your shopping bag.", "success")
    # Stay on the current page instead of opening the cart page!
    return redirect(request.referrer or url_for('shop_catalog'))


@app.route('/cart/update', methods=['POST'])
@customer_required
def cart_update():
    """Update item quantity in cart with stock bounding."""
    cart_item_id = request.form.get('cart_item_id')
    product_id = request.form.get('product_id')
    action = request.form.get('action')
    account_id = session['account_id']

    if cart_item_id:
        item = query("""
            SELECT ci.*, p.stock_qty, p.name as product_name
            FROM cart_items ci
            JOIN products p ON p.id = ci.product_id
            WHERE ci.id = %s AND ci.account_id = %s
        """, (cart_item_id, account_id), fetchone=True)
    elif product_id:
        item = query("""
            SELECT ci.*, p.stock_qty, p.name as product_name
            FROM cart_items ci
            JOIN products p ON p.id = ci.product_id
            WHERE ci.product_id = %s AND ci.account_id = %s
        """, (product_id, account_id), fetchone=True)
    else:
        item = None

    if not item:
        flash("Cart item not found.", "danger")
        return redirect(url_for('view_cart'))

    if action == 'inc':
        new_q = item['quantity'] + 1
    elif action == 'dec':
        new_q = item['quantity'] - 1
    else:
        new_q = int(request.form.get('quantity', 1))

    if new_q <= 0:
        execute("DELETE FROM cart_items WHERE id = %s", (item['id'],))
        flash(f"Removed '{item['product_name']}' from cart.", "info")
    elif new_q > item['stock_qty']:
        execute("UPDATE cart_items SET quantity = %s WHERE id = %s", (item['stock_qty'], item['id']))
        flash(f"Maximum available stock for '{item['product_name']}' is {item['stock_qty']}.", "warning")
    else:
        execute("UPDATE cart_items SET quantity = %s WHERE id = %s", (new_q, item['id']))

    return redirect(url_for('view_cart'))


@app.route('/cart/remove', methods=['POST'])
@customer_required
def cart_remove():
    """Remove item from customer cart."""
    cart_item_id = request.form.get('cart_item_id')
    product_id = request.form.get('product_id')
    account_id = session['account_id']

    if cart_item_id:
        execute("DELETE FROM cart_items WHERE id = %s AND account_id = %s", (cart_item_id, account_id))
    elif product_id:
        execute("DELETE FROM cart_items WHERE product_id = %s AND account_id = %s", (product_id, account_id))

    flash("Item removed from your cart.", "info")
    return redirect(url_for('view_cart'))


# ── E-COMMERCE: Checkout & Order Creation ────────────────────────────────────

@app.route('/checkout')
@customer_required
def checkout_view():
    """Checkout page with customer prefilled info (or clean for staff), items summary, and totals."""
    is_staff = bool(session.get('user_id') and session.get('user_type') == 'staff')
    account_id = session.get('account_id', 1)
    customer_id = session.get('customer_id')

    # If shopkeeper/staff, do NOT prefill customer fields so walk-in entries start clean!
    customer = None
    if not is_staff and customer_id:
        customer = query("SELECT * FROM customers WHERE id = %s", (customer_id,), fetchone=True)
        if customer:
            # Check customer's most recent order if any address particulars are missing
            latest_order = query("""
                SELECT ship_name, ship_phone, ship_address, ship_city, ship_state, ship_pincode
                FROM orders WHERE customer_id = %s ORDER BY id DESC LIMIT 1
            """, (customer_id,), fetchone=True)
            if latest_order:
                if not customer.get('address') or customer.get('address') == 'Counter Sale (Walk-in)':
                    customer['address'] = latest_order.get('ship_address')
                if not customer.get('city'):
                    customer['city'] = latest_order.get('ship_city')
                if not customer.get('state'):
                    customer['state'] = latest_order.get('ship_state')
                if not customer.get('pincode'):
                    customer['pincode'] = latest_order.get('ship_pincode')

    cart_rows = query("""
        SELECT ci.quantity, p.id as product_id, p.name as product_name,
               p.price as unit_price, p.stock_qty, p.is_active, p.purity,
               c.name as category_name
        FROM cart_items ci
        JOIN products p ON p.id = ci.product_id
        LEFT JOIN categories c ON c.id = p.category_id
        WHERE ci.account_id = %s
    """, (account_id,))

    if not cart_rows:
        flash("Your cart is empty. Please select jewellery pieces before proceeding to checkout.", "warning")
        return redirect(url_for('shop_catalog'))

    items = []
    subtotal = 0.0
    for r in cart_rows:
        if not r['is_active'] or r['stock_qty'] < r['quantity']:
            flash(f"Item '{r['product_name']}' is out of stock or exceeds available quantity. Please review your cart.", "warning")
            return redirect(url_for('view_cart'))
        r['line_total'] = float(r['unit_price']) * r['quantity']
        subtotal += r['line_total']
        items.append(r)

    gst_amount = round(subtotal * (Config.GST_PERCENT / 100.0), 2)
    delivery_charge = 0.0 if (subtotal >= Config.DELIVERY_FREE_THRESHOLD) else Config.DELIVERY_CHARGE_STANDARD
    grand_total = round(subtotal + gst_amount + delivery_charge, 2)

    return render_template(
        'shop/checkout.html',
        customer=customer,
        is_staff=is_staff,
        items=items,
        cart_items=items,
        subtotal=subtotal,
        gst_percent=Config.GST_PERCENT,
        gst_amount=gst_amount,
        delivery_charge=delivery_charge,
        grand_total=grand_total
    )


@app.route('/checkout', methods=['POST'])
@customer_required
def checkout_submit():
    """Create order or perform instant Cash settlement with statutory GST invoice generation."""
    is_staff = bool(session.get('user_id') and session.get('user_type') == 'staff')
    account_id = session.get('account_id', 1)

    payment_method = request.form.get('payment_method', 'Cash' if is_staff else 'Card').strip()
    ship_name = request.form.get('ship_name', '').strip()
    ship_phone = request.form.get('ship_phone', '').strip()
    ship_address = request.form.get('ship_address', '').strip() or 'Counter Sale (Boutique Walk-in)'
    ship_city = request.form.get('ship_city', '').strip() or 'Pune'
    ship_state = request.form.get('ship_state', '').strip() or 'Maharashtra'
    ship_pincode = request.form.get('ship_pincode', '').strip() or '411001'

    if not ship_name or not ship_phone:
        flash("Customer full name and 10-digit mobile contact number are required.", "danger")
        return redirect(url_for('checkout_view'))

    if len(ship_phone) != 10 or not ship_phone.isdigit():
        flash("Please enter a valid 10-digit mobile contact number.", "danger")
        return redirect(url_for('checkout_view'))

    cart_rows = query("""
        SELECT ci.quantity, p.id as product_id, p.name as product_name,
               p.price as unit_price, p.stock_qty, p.is_active, p.purity,
               COALESCE(p.weight_grams, 0) as weight_grams,
               COALESCE(p.making_charge, 0) as making_charge
        FROM cart_items ci
        JOIN products p ON p.id = ci.product_id
        WHERE ci.account_id = %s
    """, (account_id,))

    if not cart_rows:
        flash("Your shopping cart is empty.", "warning")
        return redirect(url_for('shop_catalog'))

    subtotal = 0.0
    for r in cart_rows:
        if not r['is_active'] or r['stock_qty'] < r['quantity']:
            flash(f"Item '{r['product_name']}' is no longer available in the requested quantity. Please update your cart.", "warning")
            return redirect(url_for('view_cart'))
        subtotal += float(r['unit_price']) * r['quantity']

    gst_amount = round(subtotal * (Config.GST_PERCENT / 100.0), 2)
    delivery_charge = 0.0 if (payment_method == 'Cash' or subtotal >= Config.DELIVERY_FREE_THRESHOLD) else Config.DELIVERY_CHARGE_STANDARD
    grand_total = round(subtotal + gst_amount + delivery_charge, 2)

    # Associate order and save profile strictly for the authenticated customer
    if not is_staff and session.get('customer_id'):
        target_customer_id = session['customer_id']
        execute("""
            UPDATE customers
            SET name = %s,
                phone = %s,
                address = %s,
                city = %s,
                state = %s,
                pincode = %s
            WHERE id = %s
        """, (ship_name, ship_phone, ship_address, ship_city, ship_state, ship_pincode, target_customer_id))
        session['customer_name'] = ship_name
    else:
        # Shopkeeper / Staff walk-in customer handling
        target_customer = query("SELECT * FROM customers WHERE phone = %s", (ship_phone,), fetchone=True)
        if target_customer:
            target_customer_id = target_customer['id']
            execute("""
                UPDATE customers
                SET name = %s,
                    address = CASE WHEN %s != '' THEN %s ELSE address END,
                    city = CASE WHEN %s != '' THEN %s ELSE city END,
                    state = CASE WHEN %s != '' THEN %s ELSE state END,
                    pincode = CASE WHEN %s != '' THEN %s ELSE pincode END
                WHERE id = %s
            """, (ship_name, ship_address, ship_address, ship_city, ship_city, ship_state, ship_state, ship_pincode, ship_pincode, target_customer_id))
        else:
            max_c = query("SELECT MAX(id) as mid FROM customers", fetchone=True)
            next_mid = (max_c['mid'] or 50) + 1
            new_code = f"C{next_mid}"
            execute("""
                INSERT INTO customers (customer_code, name, phone, address, city, state, pincode, loyalty_points)
                VALUES (%s, %s, %s, %s, %s, %s, %s, 0)
            """, (new_code, ship_name, ship_phone, ship_address, ship_city, ship_state, ship_pincode))
            target_customer = query("SELECT * FROM customers WHERE phone = %s", (ship_phone,), fetchone=True)
            target_customer_id = target_customer['id']

    inv_no = generate_order_invoice_no()
    order_no = f"ORD-{datetime.now().strftime('%Y%m%d%H%M%S')}-{secrets.randbelow(90000)+10000}"

    if payment_method == 'Cash':
        try:
            with transaction() as cur:
                # Lock & verify stock
                p_ids = [r['product_id'] for r in cart_rows]
                format_strings = ','.join(['%s'] * len(p_ids))
                cur.execute(f"SELECT id, name, stock_qty FROM products WHERE id IN ({format_strings}) FOR UPDATE", tuple(p_ids))
                locked_prods = {p['id']: p for p in cur.fetchall()}

                for r in cart_rows:
                    p_info = locked_prods.get(r['product_id'])
                    if not p_info or p_info['stock_qty'] < r['quantity']:
                        raise ValueError(f"Insufficient stock for '{r['product_name']}'. Only {p_info['stock_qty'] if p_info else 0} pieces available.")

                user_id = session.get('user_id') if (session.get('user_id') and session.get('user_type') == 'staff') else 1

                # Insert statutory Tax Invoice (trigger automatically awards loyalty points)
                cur.execute("""
                    INSERT INTO invoices (invoice_no, customer_id, user_id, invoice_date, subtotal,
                                          discount_percent, gst_percent, gst_amount, grand_total, payment_mode)
                    VALUES (%s, %s, %s, NOW(), %s, 0.00, 3.00, %s, %s, 'Cash')
                """, (inv_no, target_customer_id, user_id, subtotal, gst_amount, grand_total))
                invoice_id = cur.lastrowid

                # Insert invoice line items (trigger automatically decrements products.stock_qty)
                for r in cart_rows:
                    line_tot = float(r['unit_price']) * r['quantity']
                    cur.execute("""
                        INSERT INTO invoice_items (invoice_id, product_id, quantity, unit_price, line_total)
                        VALUES (%s, %s, %s, %s, %s)
                    """, (invoice_id, r['product_id'], r['quantity'], r['unit_price'], line_tot))

                # Synchronize with orders for tracking
                cur.execute("""
                    INSERT INTO orders (order_no, invoice_no, account_id, customer_id, ship_name, ship_phone,
                                        ship_address, ship_city, ship_state, ship_pincode,
                                        subtotal, gst_percent, gst_amount, delivery_charge, grand_total,
                                        order_status, payment_status, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 'Confirmed', 'Paid', NOW(), NOW())
                """, (order_no, inv_no, account_id, target_customer_id, ship_name, ship_phone,
                      ship_address, ship_city, ship_state, ship_pincode,
                      subtotal, Config.GST_PERCENT, gst_amount, delivery_charge, grand_total))
                order_id = cur.lastrowid

                # Synchronize line items into order_items
                for r in cart_rows:
                    line_tot = float(r['unit_price']) * r['quantity']
                    cur.execute("""
                        INSERT INTO order_items (order_id, product_id, product_name, unit_price, quantity, line_total)
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """, (order_id, r['product_id'], r['product_name'], r['unit_price'], r['quantity'], line_tot))

                cur.execute("""
                    INSERT INTO payments (order_id, method, amount, status, transaction_ref, paid_at, created_at)
                    VALUES (%s, 'Cash', %s, 'Success', %s, NOW(), NOW())
                """, (order_id, grand_total, f"CASH-{inv_no}"))

                # Clear cart
                cur.execute("DELETE FROM cart_items WHERE account_id = %s", (account_id,))

        except ValueError as err:
            flash(str(err), "danger")
            return redirect(url_for('checkout_view'))

        session['last_invoice_id'] = invoice_id
        if is_staff:
            flash(f"In-store payment authorized! Tax Invoice {inv_no} generated successfully.", "success")
            return redirect(url_for('invoice_view', id=invoice_id))
        else:
            flash(f"Order confirmed with Cash on Delivery (COD)! Tax Invoice {inv_no} generated.", "success")
            return redirect(url_for('order_confirmation_view', order_id=order_id))

    else:
        with transaction() as cur:
            cur.execute("""
                INSERT INTO orders (order_no, account_id, customer_id, ship_name, ship_phone,
                                    ship_address, ship_city, ship_state, ship_pincode,
                                    subtotal, gst_percent, gst_amount, delivery_charge, grand_total,
                                    order_status, payment_status, created_at, updated_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 'Pending', 'Pending', NOW(), NOW())
            """, (order_no, account_id, target_customer_id, ship_name, ship_phone,
                  ship_address, ship_city, ship_state, ship_pincode,
                  subtotal, Config.GST_PERCENT, gst_amount, delivery_charge, grand_total))
            order_id = cur.lastrowid

            for r in cart_rows:
                line_tot = float(r['unit_price']) * r['quantity']
                cur.execute("""
                    INSERT INTO order_items (order_id, product_id, product_name, unit_price, quantity, line_total)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, (order_id, r['product_id'], r['product_name'], r['unit_price'], r['quantity'], line_tot))

            cur.execute("""
                INSERT INTO order_status_history (order_id, status, changed_by_user_id, changed_at)
                VALUES (%s, 'Pending', NULL, NOW())
            """, (order_id,))

        return redirect(url_for('process_payment_view', order_id=order_id))


# ── E-COMMERCE: Payment Gateway Simulation & Order Confirmation ──────────────

@app.route('/payment/<int:order_id>', methods=['GET', 'POST'])
@customer_required
def process_payment_view(order_id):
    """
    Payment gateway simulation. Handles Cash, Card, UPI, and NetBanking test outcomes.
    On SUCCESS: locks inventory rows in MySQL (FOR UPDATE), verifies stock, decrements stock in Python,
    creates payment record, generates invoice_no, updates order to Confirmed/Paid, and clears cart.
    If payment method is Cash, redirects directly to statutory GST Tax Invoice.
    """
    account_id = session.get('account_id', 1)
    is_staff = bool(session.get('user_id') and session.get('user_type') == 'staff')

    order = query("SELECT * FROM orders WHERE id = %s", (order_id,), fetchone=True)
    if not order or (not is_staff and order['account_id'] != account_id):
        abort(404)

    if order['payment_status'] == 'Paid':
        flash("This order has already been successfully settled and confirmed.", "info")
        return redirect(url_for('order_confirmation_view', order_id=order_id))

    if request.method == 'POST':
        method = request.form.get('payment_method', 'Card')
        is_success, error_msg = process_payment_simulation(order, method, request.form)

        if is_success:
            invoice_id = None
            with transaction() as cur:
                # Lock order row to prevent double-submit
                cur.execute("SELECT * FROM orders WHERE id = %s FOR UPDATE", (order_id,))
                curr_order = cur.fetchone()
                if curr_order['payment_status'] == 'Paid':
                    flash("This order has already been settled.", "info")
                    return redirect(url_for('order_confirmation_view', order_id=order_id))

                cur.execute("SELECT * FROM order_items WHERE order_id = %s", (order_id,))
                items = cur.fetchall()

                # Lock product rows and verify stock
                p_ids = [it['product_id'] for it in items]
                format_strings = ','.join(['%s'] * len(p_ids))
                cur.execute(f"SELECT id, name, stock_qty FROM products WHERE id IN ({format_strings}) FOR UPDATE", tuple(p_ids))
                locked_prods = {p['id']: p for p in cur.fetchall()}

                stock_failed = False
                failed_name = ""
                for it in items:
                    p_info = locked_prods.get(it['product_id'])
                    if not p_info or p_info['stock_qty'] < it['quantity']:
                        stock_failed = True
                        failed_name = it['product_name']
                        break

                if stock_failed:
                    f_reason = f"Inventory depleted for piece '{failed_name}'. Payment not processed."
                    cur.execute("""
                        INSERT INTO payments (order_id, method, amount, status, failure_reason, created_at)
                        VALUES (%s, %s, %s, 'Failed', %s, NOW())
                    """, (order_id, method, curr_order['grand_total'], f_reason))
                    cur.execute("UPDATE orders SET payment_status = 'Failed' WHERE id = %s", (order_id,))
                    flash(f_reason, "danger")
                    return redirect(url_for('process_payment_view', order_id=order_id))

                txn_ref = f"TXN-{secrets.token_hex(6).upper()}" if method != 'Cash' else f"CASH-{secrets.randbelow(9000)+1000}"
                cur.execute("""
                    INSERT INTO payments (order_id, method, amount, status, transaction_ref, paid_at, created_at)
                    VALUES (%s, %s, %s, 'Success', %s, NOW(), NOW())
                """, (order_id, method, curr_order['grand_total'], txn_ref))

                inv_no = curr_order.get('invoice_no') or generate_order_invoice_no()
                cur.execute("""
                    UPDATE orders
                    SET order_status = 'Confirmed',
                        payment_status = 'Paid',
                        invoice_no = %s,
                        updated_at = NOW()
                    WHERE id = %s
                """, (inv_no, order_id))

                user_id = session.get('user_id') if (session.get('user_id') and session.get('user_type') == 'staff') else 1

                # Create official statutory invoice record in `invoices` (trigger adds loyalty points)
                cur.execute("""
                    INSERT INTO invoices (invoice_no, customer_id, user_id, invoice_date, subtotal,
                                          discount_percent, gst_percent, gst_amount, grand_total, payment_mode)
                    VALUES (%s, %s, %s, NOW(), %s, 0.00, 3.00, %s, %s, %s)
                """, (inv_no, curr_order['customer_id'], user_id, curr_order['subtotal'], curr_order['gst_amount'], curr_order['grand_total'], method))
                invoice_id = cur.lastrowid

                # Insert invoice items (trigger decrements products.stock_qty)
                for it in items:
                    cur.execute("""
                        INSERT INTO invoice_items (invoice_id, product_id, quantity, unit_price, line_total)
                        VALUES (%s, %s, %s, %s, %s)
                    """, (invoice_id, it['product_id'], it['quantity'], it['unit_price'], it['line_total']))

                cur.execute("""
                    INSERT INTO order_status_history (order_id, status, changed_by_user_id, changed_at)
                    VALUES (%s, 'Confirmed', NULL, NOW())
                """, (order_id,))

                # Clear shopping cart for this customer account
                cur.execute("DELETE FROM cart_items WHERE account_id = %s", (account_id,))

            session['last_invoice_id'] = invoice_id

            if method == 'Cash':
                if is_staff:
                    flash(f"In-store payment confirmed! Official Tax Invoice {inv_no} generated.", "success")
                    return redirect(url_for('invoice_view', id=invoice_id))
                else:
                    flash(f"Order placed with Cash on Delivery (COD)! Tax Invoice {inv_no} generated.", "success")
                    return redirect(url_for('order_confirmation_view', order_id=order_id))

            flash("Payment successfully authorized! Your order has been placed and confirmed.", "success")
            return redirect(url_for('order_confirmation_view', order_id=order_id))
        else:
            execute("""
                INSERT INTO payments (order_id, method, amount, status, failure_reason, created_at)
                VALUES (%s, %s, %s, 'Failed', %s, NOW())
            """, (order_id, method, order['grand_total'], error_msg))
            execute("UPDATE orders SET payment_status = 'Failed' WHERE id = %s", (order_id,))
            flash(f"Payment failed: {error_msg}", "danger")
            return redirect(url_for('process_payment_view', order_id=order_id))

    items = query("SELECT * FROM order_items WHERE order_id = %s", (order_id,))
    recent_payment = query("SELECT * FROM payments WHERE order_id = %s ORDER BY id DESC LIMIT 1", (order_id,), fetchone=True)
    upi_qr_svg = generate_upi_qr_svg('vijayrajgems@icici', 'Vijayraj Gems and Jewellery', float(order['grand_total']), order['order_no'])
    return render_template(
        'shop/payment.html',
        order=order,
        items=items,
        recent_payment=recent_payment,
        upi_qr_svg=upi_qr_svg
    )


@app.route('/order-confirmation/<int:order_id>')
@customer_required
def order_confirmation_view(order_id):
    """Post-payment celebration and receipt confirmation."""
    account_id = session['account_id']
    order = query("SELECT * FROM orders WHERE id = %s AND account_id = %s", (order_id, account_id), fetchone=True)
    if not order:
        abort(404)

    items = query("SELECT * FROM order_items WHERE order_id = %s", (order_id,))
    payment = query("SELECT * FROM payments WHERE order_id = %s AND status = 'Success' ORDER BY id DESC LIMIT 1", (order_id,), fetchone=True)
    return render_template('shop/order_confirmation.html', order=order, items=items, payment=payment)


# ── E-COMMERCE: Customer Orders, Invoices & Profile ──────────────────────────

@app.route('/account/profile', methods=['GET', 'POST'])
@customer_required
def customer_profile():
    """Customer account profile management: view & save personal and delivery details."""
    account_id = session.get('account_id')
    customer_id = session.get('customer_id')

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        phone = request.form.get('phone', '').strip()
        address = request.form.get('address', '').strip()
        city = request.form.get('city', '').strip()
        state = request.form.get('state', '').strip()
        pincode = request.form.get('pincode', '').strip()

        if not name or not phone:
            flash("Full name and 10-digit mobile number are required.", "danger")
        elif len(phone) != 10 or not phone.isdigit():
            flash("Please provide a valid 10-digit mobile number.", "danger")
        else:
            execute("""
                UPDATE customers
                SET name = %s,
                    phone = %s,
                    address = %s,
                    city = %s,
                    state = %s,
                    pincode = %s
                WHERE id = %s
            """, (name, phone, address, city, state, pincode, customer_id))
            session['customer_name'] = name
            flash("Your profile details have been saved successfully.", "success")
            return redirect(url_for('customer_profile'))

    customer = query("SELECT * FROM customers WHERE id = %s", (customer_id,), fetchone=True)
    account = query("SELECT email, created_at, last_login FROM customer_accounts WHERE id = %s", (account_id,), fetchone=True)
    order_count = query("SELECT COUNT(*) as cnt FROM orders WHERE account_id = %s", (account_id,), fetchone=True)

    return render_template(
        'shop/profile.html',
        customer=customer,
        account=account,
        order_count=order_count['cnt'] if order_count else 0
    )


@app.route('/account/orders')
@customer_required
def customer_orders():
    """Browse customer order history with item counts and delivery tracking badges."""
    account_id = session['account_id']
    orders = query("""
        SELECT o.*,
               (SELECT COUNT(*) FROM order_items oi WHERE oi.order_id = o.id) as item_count
        FROM orders o
        WHERE o.account_id = %s
        ORDER BY o.created_at DESC
    """, (account_id,))
    return render_template('shop/orders.html', orders=orders)


@app.route('/account/orders/<int:order_id>')
@customer_required
def customer_order_detail(order_id):
    """Order detail view with shipment timeline, line items, and payment status (IDOR safe)."""
    account_id = session['account_id']
    order = query("SELECT * FROM orders WHERE id = %s AND account_id = %s", (order_id, account_id), fetchone=True)
    if not order:
        abort(404)

    items = query("""
        SELECT oi.*, p.product_code, p.purity, p.weight_grams,
               c.name as category_name, c.slug as category_slug, c.image_path as category_image
        FROM order_items oi
        LEFT JOIN products p ON p.id = oi.product_id
        LEFT JOIN categories c ON c.id = p.category_id
        WHERE oi.order_id = %s
    """, (order_id,))
    for it in items:
        it['image_url'] = get_product_image_url(it)

    payment = query("SELECT * FROM payments WHERE order_id = %s ORDER BY id DESC LIMIT 1", (order_id,), fetchone=True)
    history = query("""
        SELECT osh.*, u.full_name as updated_by
        FROM order_status_history osh
        LEFT JOIN users u ON u.id = osh.changed_by_user_id
        WHERE osh.order_id = %s
        ORDER BY osh.changed_at ASC
    """, (order_id,))

    return render_template(
        'shop/order_detail.html',
        order=order,
        items=items,
        payment=payment,
        history=history
    )


@app.route('/account/orders/<int:order_id>/invoice')
@customer_required
def customer_order_invoice(order_id):
    """HTML Tax Invoice view for online orders."""
    is_staff = bool(session.get('user_id') and session.get('user_type') == 'staff')
    account_id = session.get('account_id')
    customer_id = session.get('customer_id')

    if is_staff:
        order = query("SELECT * FROM orders WHERE id = %s", (order_id,), fetchone=True)
    elif account_id:
        order = query("SELECT * FROM orders WHERE id = %s AND (account_id = %s OR customer_id = %s)", (order_id, account_id, customer_id), fetchone=True)
    else:
        order = query("SELECT * FROM orders WHERE id = %s", (order_id,), fetchone=True)

    if not order or not order.get('invoice_no'):
        flash("Tax invoice has not been generated for this order yet.", "warning")
        return redirect(url_for('customer_orders'))

    items = query("""
        SELECT oi.*, p.product_code, p.category, p.purity,
               COALESCE(p.weight_grams, 0) as weight_grams,
               COALESCE(p.making_charge, 0) as making_charge
        FROM order_items oi
        LEFT JOIN products p ON p.id = oi.product_id
        WHERE oi.order_id = %s
    """, (order_id,))

    if not items and order.get('invoice_no'):
        inv = query("SELECT id FROM invoices WHERE invoice_no = %s", (order['invoice_no'],), fetchone=True)
        if inv:
            items = query("""
                SELECT ii.product_id, p.name as product_name, p.product_code, p.category, p.purity,
                       ii.quantity, ii.unit_price, ii.line_total,
                       COALESCE(p.weight_grams, 0) as weight_grams,
                       COALESCE(p.making_charge, 0) as making_charge
                FROM invoice_items ii
                LEFT JOIN products p ON p.id = ii.product_id
                WHERE ii.invoice_id = %s
            """, (inv['id'],))

    payment = query("SELECT * FROM payments WHERE order_id = %s ORDER BY id DESC LIMIT 1", (order_id,), fetchone=True)
    customer = query("SELECT * FROM customers WHERE id = %s", (order['customer_id'],), fetchone=True)
    grand_total_words = number_to_words(order['grand_total'])

    return render_template(
        'shop/order_invoice.html',
        order=order,
        items=items,
        payment=payment,
        customer=customer,
        grand_total_words=grand_total_words
    )


@app.route('/account/orders/<int:order_id>/invoice/pdf')
@customer_required
def customer_order_invoice_pdf(order_id):
    """Download ReportLab PDF Tax Invoice for customer's order (IDOR safe)."""
    is_staff = bool(session.get('user_id') and session.get('user_type') == 'staff')
    account_id = session.get('account_id')
    customer_id = session.get('customer_id')

    if is_staff:
        order = query("SELECT * FROM orders WHERE id = %s", (order_id,), fetchone=True)
    elif account_id:
        order = query("SELECT * FROM orders WHERE id = %s AND (account_id = %s OR customer_id = %s)", (order_id, account_id, customer_id), fetchone=True)
    else:
        order = query("SELECT * FROM orders WHERE id = %s", (order_id,), fetchone=True)

    if not order or not order.get('invoice_no'):
        abort(404)

    items = query("""
        SELECT oi.*, p.product_code, p.purity, p.weight_grams
        FROM order_items oi
        LEFT JOIN products p ON p.id = oi.product_id
        WHERE oi.order_id = %s
    """, (order_id,))

    if not items and order.get('invoice_no'):
        inv = query("SELECT id FROM invoices WHERE invoice_no = %s", (order['invoice_no'],), fetchone=True)
        if inv:
            items = query("""
                SELECT ii.product_id, p.name as product_name, p.product_code, p.category, p.purity,
                       ii.quantity, ii.unit_price, ii.line_total,
                       COALESCE(p.weight_grams, 0) as weight_grams
                FROM invoice_items ii
                LEFT JOIN products p ON p.id = ii.product_id
                WHERE ii.invoice_id = %s
            """, (inv['id'],))

    payment = query("SELECT * FROM payments WHERE order_id = %s ORDER BY id DESC LIMIT 1", (order_id,), fetchone=True)
    customer = query("SELECT * FROM customers WHERE id = %s", (order['customer_id'],), fetchone=True)

    pdf_buffer = generate_order_pdf_invoice(order, items, payment, customer)
    filename = f"Vijayraj_Invoice_{order['invoice_no'] or order['order_no']}.pdf"

    inline = request.args.get('inline', '0') == '1' or request.args.get('view', '0') == '1'

    return send_file(
        pdf_buffer,
        mimetype='application/pdf',
        as_attachment=not inline,
        download_name=filename
    )


# ── E-COMMERCE: Staff Category Management ────────────────────────────────────

@app.route('/categories')
@login_required
@role_required('admin', 'manager', 'staff')
def categories_list():
    """Browse boutique categories with product counts."""
    cats = query("""
        SELECT c.*,
               (SELECT COUNT(*) FROM products p WHERE p.category_id = c.id) as product_count
        FROM categories c
        ORDER BY c.name ASC
    """)
    return render_template('categories.html', categories=cats)


@app.route('/categories/add', methods=['GET', 'POST'])
@login_required
@role_required('admin', 'manager', 'staff')
def category_add():
    """Add a new e-commerce category."""
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        slug = request.form.get('slug', '').strip().lower()
        description = request.form.get('description', '').strip()
        is_active = 1 if request.form.get('is_active') else 0

        if not name:
            flash("Category name is required.", "danger")
            return render_template('category_form.html', category=request.form, is_edit=False)

        if not slug:
            slug = name.lower().replace(' ', '-').replace('&', 'and')

        existing = query("SELECT id FROM categories WHERE slug = %s OR name = %s", (slug, name), fetchone=True)
        if existing:
            flash("Category with this name or slug already exists.", "danger")
            return render_template('category_form.html', category=request.form, is_edit=False)

        image_path = 'cat-gold.jpg'
        f = request.files.get('image')
        if f and f.filename:
            ext = f.filename.rsplit('.', 1)[-1].lower() if '.' in f.filename else ''
            if ext in Config.ALLOWED_EXTENSIONS:
                try:
                    img = Image.open(f)
                    img.verify()
                    f.seek(0)
                    img = Image.open(f)
                    if img.mode in ('RGBA', 'P'):
                        img = img.convert('RGB')
                    img.thumbnail((800, 800), Image.Resampling.LANCZOS)
                    rand_fn = f"cat_{secrets.token_hex(6)}.{ext}"
                    save_path = os.path.join(Config.UPLOAD_FOLDER, rand_fn)
                    img.save(save_path)
                    image_path = f"products/{rand_fn}"
                except Exception:
                    pass

        execute("""
            INSERT INTO categories (name, slug, description, image_path, is_active, created_at)
            VALUES (%s, %s, %s, %s, %s, NOW())
        """, (name, slug, description, image_path, is_active))

        flash(f"Category '{name}' created successfully.", "success")
        return redirect(url_for('categories_list'))

    return render_template('category_form.html', category={}, is_edit=False)


@app.route('/categories/<int:id>/edit', methods=['GET', 'POST'])
@login_required
@role_required('admin', 'manager', 'staff')
def category_edit(id):
    """Edit existing boutique category."""
    cat = query("SELECT * FROM categories WHERE id = %s", (id,), fetchone=True)
    if not cat:
        flash("Category not found.", "danger")
        return redirect(url_for('categories_list'))

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        slug = request.form.get('slug', '').strip().lower()
        description = request.form.get('description', '').strip()
        is_active = 1 if request.form.get('is_active') else 0

        if not name:
            flash("Category name is required.", "danger")
            return render_template('category_form.html', category=cat, is_edit=True)

        if not slug:
            slug = name.lower().replace(' ', '-').replace('&', 'and')

        image_path = cat['image_path']
        f = request.files.get('image')
        if f and f.filename:
            ext = f.filename.rsplit('.', 1)[-1].lower() if '.' in f.filename else ''
            if ext in Config.ALLOWED_EXTENSIONS:
                try:
                    img = Image.open(f)
                    img.verify()
                    f.seek(0)
                    img = Image.open(f)
                    if img.mode in ('RGBA', 'P'):
                        img = img.convert('RGB')
                    img.thumbnail((800, 800), Image.Resampling.LANCZOS)
                    rand_fn = f"cat_{secrets.token_hex(6)}.{ext}"
                    save_path = os.path.join(Config.UPLOAD_FOLDER, rand_fn)
                    img.save(save_path)
                    image_path = f"products/{rand_fn}"
                except Exception:
                    pass

        execute("""
            UPDATE categories
            SET name = %s, slug = %s, description = %s, image_path = %s, is_active = %s
            WHERE id = %s
        """, (name, slug, description, image_path, is_active, id))

        flash(f"Category '{name}' updated successfully.", "success")
        return redirect(url_for('categories_list'))

    return render_template('category_form.html', category=cat, is_edit=True)


@app.route('/categories/<int:id>/delete', methods=['POST'])
@login_required
@role_required('admin', 'manager')
def category_delete(id):
    """Safely delete category or deactivate if products are linked."""
    cat = query("SELECT * FROM categories WHERE id = %s", (id,), fetchone=True)
    if not cat:
        flash("Category not found.", "danger")
        return redirect(url_for('categories_list'))

    prod_count = query("SELECT COUNT(*) as cnt FROM products WHERE category_id = %s", (id,), fetchone=True)['cnt']
    if prod_count > 0:
        execute("UPDATE categories SET is_active = 0 WHERE id = %s", (id,))
        flash(f"Category '{cat['name']}' has {prod_count} associated jewellery items and cannot be removed. It has been deactivated.", "warning")
    else:
        execute("DELETE FROM categories WHERE id = %s", (id,))
        flash(f"Category '{cat['name']}' deleted.", "success")

    return redirect(url_for('categories_list'))


# ── E-COMMERCE: Staff Order Management ───────────────────────────────────────

@app.route('/orders')
@login_required
@role_required('admin', 'manager', 'staff')
def manager_orders():
    """Manager order overview with search, status filters, and pagination."""
    q_search = request.args.get('q', '').strip()
    status = request.args.get('order_status', '').strip()
    payment_status = request.args.get('payment_status', '').strip()
    date_from = request.args.get('date_from', '').strip()
    date_to = request.args.get('date_to', '').strip()
    page = max(1, int(request.args.get('page', 1)))
    per_page = 15

    conditions = []
    params = []

    if q_search:
        conditions.append("(o.order_no LIKE %s OR o.ship_name LIKE %s OR o.ship_phone LIKE %s OR o.invoice_no LIKE %s OR c.name LIKE %s)")
        params.extend([f"%{q_search}%", f"%{q_search}%", f"%{q_search}%", f"%{q_search}%", f"%{q_search}%"])

    if status:
        conditions.append("o.order_status = %s")
        params.append(status)

    if payment_status:
        conditions.append("o.payment_status = %s")
        params.append(payment_status)

    if date_from:
        conditions.append("DATE(o.created_at) >= %s")
        params.append(date_from)

    if date_to:
        conditions.append("DATE(o.created_at) <= %s")
        params.append(date_to)

    where_clause = (" WHERE " + " AND ".join(conditions)) if conditions else ""

    count_sql = f"""
        SELECT COUNT(*) as total
        FROM orders o
        JOIN customers c ON c.id = o.customer_id
        {where_clause}
    """
    total_count = query(count_sql, tuple(params), fetchone=True)['total']
    total_pages = max(1, (total_count + per_page - 1) // per_page)
    offset = (page - 1) * per_page

    data_sql = f"""
        SELECT o.*, c.name as customer_name, c.customer_code,
               (SELECT COUNT(*) FROM order_items oi WHERE oi.order_id = o.id) as item_count
        FROM orders o
        JOIN customers c ON c.id = o.customer_id
        {where_clause}
        ORDER BY o.created_at DESC
        LIMIT %s OFFSET %s
    """
    p_params = list(params) + [per_page, offset]
    orders = query(data_sql, tuple(p_params))

    stats = query("""
        SELECT COUNT(*) as total_orders,
               COUNT(CASE WHEN order_status = 'Pending' THEN 1 END) as pending_orders,
               COUNT(CASE WHEN order_status = 'Confirmed' THEN 1 END) as confirmed_orders,
               COUNT(CASE WHEN order_status = 'Shipped' THEN 1 END) as shipped_orders,
               COUNT(CASE WHEN order_status = 'Delivered' THEN 1 END) as delivered_orders,
               COALESCE(SUM(CASE WHEN payment_status = 'Paid' AND order_status != 'Cancelled' THEN grand_total ELSE 0 END), 0) as total_revenue
        FROM orders
    """, fetchone=True)

    kpis = {
        'total': stats['total_orders'] if stats else 0,
        'pending': stats['pending_orders'] if stats else 0,
        'confirmed': stats['confirmed_orders'] if stats else 0,
        'shipped': stats['shipped_orders'] if stats else 0,
        'delivered': stats['delivered_orders'] if stats else 0,
        'revenue': float(stats['total_revenue']) if stats else 0.0
    }

    filters = {
        'q': q_search,
        'status': status,
        'payment_status': payment_status,
        'date_from': date_from,
        'date_to': date_to
    }

    return render_template(
        'orders_list.html',
        orders=orders,
        stats=stats,
        kpis=kpis,
        filters=filters,
        q=q_search,
        status=status,
        payment_status=payment_status,
        date_from=date_from,
        date_to=date_to,
        page=page,
        total_pages=total_pages,
        total_count=total_count
    )


@app.route('/orders/<int:id>')
@login_required
@role_required('admin', 'manager', 'staff')
def manager_order_detail(id):
    """Staff order inspection with audit trail and status management."""
    order = query("""
        SELECT o.*, c.name as customer_name, c.customer_code, c.email as customer_email, c.phone as customer_phone
        FROM orders o
        JOIN customers c ON c.id = o.customer_id
        WHERE o.id = %s
    """, (id,), fetchone=True)
    if not order:
        flash("Order record not found.", "danger")
        return redirect(url_for('manager_orders'))

    items = query("""
        SELECT oi.*, p.product_code, p.purity, p.weight_grams, p.stock_qty,
               c.name as category_name
        FROM order_items oi
        LEFT JOIN products p ON p.id = oi.product_id
        LEFT JOIN categories c ON c.id = p.category_id
        WHERE oi.order_id = %s
    """, (id,))

    payments = query("SELECT * FROM payments WHERE order_id = %s ORDER BY id DESC", (id,))
    history = query("""
        SELECT osh.*, u.full_name as changed_by_name
        FROM order_status_history osh
        LEFT JOIN users u ON u.id = osh.changed_by_user_id
        WHERE osh.order_id = %s
        ORDER BY osh.changed_at ASC
    """, (id,))

    return render_template(
        'order_detail_staff.html',
        order=order,
        items=items,
        payments=payments,
        history=history
    )


@app.route('/orders/<int:id>/status', methods=['POST'])
@login_required
@role_required('admin', 'manager', 'staff')
def manager_order_status_update(id):
    """
    Update order status according to allowable state machine rules.
    On cancelling a paid order, automatically restores product inventory and sets payment_status to 'Refunded'.
    Logs every transition in order_status_history with manager user_id.
    """
    new_status = request.form.get('new_status') or request.form.get('order_status')
    order = query("SELECT * FROM orders WHERE id = %s", (id,), fetchone=True)
    if not order:
        flash("Order not found.", "danger")
        return redirect(url_for('manager_orders'))

    current_status = order['order_status']
    payment_status = order['payment_status']

    allowed = False
    if current_status == 'Pending' and new_status in ('Confirmed', 'Cancelled'):
        allowed = True
    elif current_status == 'Confirmed' and new_status in ('Shipped', 'Cancelled'):
        allowed = True
    elif current_status == 'Shipped' and new_status == 'Delivered':
        allowed = True

    if not allowed:
        flash(f"Status transition from '{current_status}' to '{new_status}' is not permitted.", "danger")
        return redirect(url_for('manager_order_detail', id=id))

    if new_status == 'Shipped' and payment_status != 'Paid':
        flash("Orders cannot be dispatched (Shipped) until payment has been completed.", "warning")
        return redirect(url_for('manager_order_detail', id=id))

    with transaction() as cur:
        if new_status == 'Cancelled' and payment_status == 'Paid':
            cur.execute("SELECT product_id, quantity FROM order_items WHERE order_id = %s", (id,))
            items = cur.fetchall()
            for itm in items:
                cur.execute("UPDATE products SET stock_qty = stock_qty + %s WHERE id = %s", (itm['quantity'], itm['product_id']))
            cur.execute("UPDATE orders SET order_status = %s, payment_status = 'Refunded', updated_at = NOW() WHERE id = %s", (new_status, id))
        else:
            cur.execute("UPDATE orders SET order_status = %s, updated_at = NOW() WHERE id = %s", (new_status, id))

        cur.execute("""
            INSERT INTO order_status_history (order_id, status, changed_by_user_id, changed_at)
            VALUES (%s, %s, %s, NOW())
        """, (id, new_status, session.get('user_id')))

    flash(f"Order {order['order_no']} has been updated to '{new_status}'.", "success")
    return redirect(url_for('manager_order_detail', id=id))


@app.route('/orders/<int:id>/invoice')
@login_required
@role_required('admin', 'manager', 'staff')
def manager_order_invoice_view(id):
    """Staff/Shopkeeper HTML view of the official Tax Invoice for an order."""
    order = query("SELECT * FROM orders WHERE id = %s", (id,), fetchone=True)
    if not order:
        flash("Order record not found.", "danger")
        return redirect(url_for('manager_orders'))

    items = query("""
        SELECT oi.*, p.product_code, p.category, p.purity,
               COALESCE(p.weight_grams, 0) as weight_grams,
               COALESCE(p.making_charge, 0) as making_charge
        FROM order_items oi
        LEFT JOIN products p ON p.id = oi.product_id
        WHERE oi.order_id = %s
    """, (id,))
    payment = query("SELECT * FROM payments WHERE order_id = %s AND status = 'Success' ORDER BY id DESC LIMIT 1", (id,), fetchone=True)
    customer = query("SELECT * FROM customers WHERE id = %s", (order['customer_id'],), fetchone=True)
    grand_total_words = number_to_words(order['grand_total'])

    return render_template(
        'shop/order_invoice.html',
        order=order,
        items=items,
        payment=payment,
        customer=customer,
        grand_total_words=grand_total_words
    )


@app.route('/orders/<int:id>/invoice/pdf')
@login_required
@role_required('admin', 'manager', 'staff')
def manager_order_invoice_pdf(id):
    """Manager can download the official ReportLab PDF tax invoice for any paid order."""
    order = query("SELECT * FROM orders WHERE id = %s", (id,), fetchone=True)
    if not order or order['payment_status'] != 'Paid':
        flash("Tax invoice is available only for paid orders.", "warning")
        return redirect(url_for('manager_order_detail', id=id))

    items = query("""
        SELECT oi.*, p.product_code, p.purity, p.weight_grams
        FROM order_items oi
        LEFT JOIN products p ON p.id = oi.product_id
        WHERE oi.order_id = %s
    """, (id,))
    payment = query("SELECT * FROM payments WHERE order_id = %s AND status = 'Success' ORDER BY id DESC LIMIT 1", (id,), fetchone=True)
    customer = query("SELECT * FROM customers WHERE id = %s", (order['customer_id'],), fetchone=True)

    pdf_buffer = generate_order_pdf_invoice(order, items, payment, customer)
    filename = f"Vijayraj_Invoice_{order['invoice_no'] or order['order_no']}.pdf"

    return send_file(
        pdf_buffer,
        mimetype='application/pdf',
        as_attachment=True,
        download_name=filename
    )


# ── Error Handlers ───────────────────────────────────────────────────────────


@app.errorhandler(403)
def forbidden_error(e):
    return render_template('403.html'), 403


@app.errorhandler(404)
def not_found_error(e):
    return render_template('404.html'), 404


@app.errorhandler(500)
def server_error(e):
    return render_template('404.html', message='An internal server error occurred. Please contact the administrator.'), 500


# ── Application Runner ───────────────────────────────────────────────────────

if __name__ == '__main__':
    print("=" * 60)
    print("💎 Vijayraj Gems & Jewellery Shop Management System 💍")
    print("=" * 60)
    print(f"URL:    http://{Config.HOST}:{Config.PORT}")
    print(f"Debug:  {Config.DEBUG}")
    print(f"Mode:   Pure Server-Side Jinja2 (Zero API Layer)")
    print("=" * 60)
    app.run(host=Config.HOST, port=Config.PORT, debug=Config.DEBUG)
