-- ============================================================
-- Vijayraj Gems and Jewellery Shop - Seed Data
-- 50+ rows in each table with realistic Indian data
-- NOTE: User passwords are hashed by scripts/init_db.py
-- NOTE: Triggers should be disabled before running this seed
-- ============================================================

USE vijayraj_jewellery;

-- ── Disable triggers during seeding ──────────────────────────
-- (We set final stock/loyalty values explicitly after seeding)

-- ── USERS (50 rows) ──────────────────────────────────────────
-- Passwords are inserted as placeholders; init_db.py replaces them with hashes
INSERT INTO users (id, full_name, username, password_hash, role, phone, email, salary, joined_date, is_active) VALUES
(1,  'Vijayraj Admin',      'admin',       'HASH:Admin@123',       'admin',   '9876543001', 'admin@vijayraj.com',       85000.00, '2020-01-15', 1),
(2,  'Rohit Sharma',        'rohit.mgr',   'HASH:Rohit@456',       'manager', '9876543002', 'rohit@vijayraj.com',       55000.00, '2020-03-10', 1),
(3,  'Priya Deshmukh',      'priya.mgr',   'HASH:Priya@456',       'manager', '9876543003', 'priya@vijayraj.com',       52000.00, '2020-06-22', 1),
(4,  'Amit Patil',          'amit.staff',   'HASH:Amit@789',        'staff',   '9876543004', 'amit@vijayraj.com',        30000.00, '2021-01-05', 1),
(5,  'Sneha Kulkarni',      'sneha.staff',  'HASH:Sneha@789',       'staff',   '9876543005', 'sneha@vijayraj.com',       28000.00, '2021-02-14', 1),
(6,  'Rajesh Joshi',        'rajesh.staff', 'HASH:Rajesh@789',      'staff',   '9876543006', 'rajesh@vijayraj.com',      32000.00, '2021-04-01', 1),
(7,  'Meena Iyer',          'meena.staff',  'HASH:Meena@789',       'staff',   '9876543007', 'meena@vijayraj.com',       29000.00, '2021-06-15', 1),
(8,  'Suresh Gaikwad',      'suresh.staff', 'HASH:Suresh@789',      'staff',   '9876543008', 'suresh@vijayraj.com',      31000.00, '2021-08-20', 1),
(9,  'Kavita More',         'kavita.staff', 'HASH:Kavita@789',      'staff',   '9876543009', 'kavita@vijayraj.com',      27000.00, '2021-10-10', 1),
(10, 'Nitin Pawar',         'nitin.mgr',   'HASH:Nitin@456',       'manager', '9876543010', 'nitin@vijayraj.com',       54000.00, '2022-01-03', 1),
(11, 'Anjali Bhosale',      'anjali.staff', 'HASH:Anjali@789',      'staff',   '9876543011', 'anjali@vijayraj.com',      26000.00, '2022-02-20', 1),
(12, 'Vikram Shinde',       'vikram.staff', 'HASH:Vikram@789',      'staff',   '9876543012', 'vikram@vijayraj.com',      30000.00, '2022-04-12', 1),
(13, 'Pooja Wagh',          'pooja.staff',  'HASH:Pooja@789',       'staff',   '9876543013', 'pooja@vijayraj.com',       28500.00, '2022-05-25', 1),
(14, 'Deepak Chavan',       'deepak.staff', 'HASH:Deepak@789',      'staff',   '9876543014', 'deepak@vijayraj.com',      29500.00, '2022-07-08', 1),
(15, 'Swati Jadhav',        'swati.staff',  'HASH:Swati@789',       'staff',   '9876543015', 'swati@vijayraj.com',       27500.00, '2022-08-30', 1),
(16, 'Manoj Kale',          'manoj.staff',  'HASH:Manoj@789',       'staff',   '9876543016', 'manoj@vijayraj.com',       31000.00, '2022-10-15', 1),
(17, 'Rekha Mane',          'rekha.staff',  'HASH:Rekha@789',       'staff',   '9876543017', 'rekha@vijayraj.com',       26500.00, '2023-01-08', 1),
(18, 'Ganesh Sonawane',     'ganesh.staff', 'HASH:Ganesh@789',      'staff',   '9876543018', 'ganesh@vijayraj.com',      29000.00, '2023-02-22', 1),
(19, 'Nisha Phadke',        'nisha.staff',  'HASH:Nisha@789',       'staff',   '9876543019', 'nisha@vijayraj.com',       28000.00, '2023-04-05', 1),
(20, 'Sachin Deshpande',    'sachin.staff', 'HASH:Sachin@789',      'staff',   '9876543020', 'sachin@vijayraj.com',      30500.00, '2023-05-18', 1),
(21, 'Manisha Thakur',      'manisha.staff','HASH:Manisha@789',     'staff',   '9876543021', 'manisha@vijayraj.com',     27000.00, '2023-06-30', 1),
(22, 'Prakash Nimbalkar',   'prakash.staff','HASH:Prakash@789',     'staff',   '9876543022', 'prakash@vijayraj.com',     32000.00, '2023-08-12', 1),
(23, 'Aarti Lokhande',      'aarti.staff',  'HASH:Aarti@789',       'staff',   '9876543023', 'aarti@vijayraj.com',       28500.00, '2023-09-25', 1),
(24, 'Sanjay Tupe',         'sanjay.staff', 'HASH:Sanjay@789',      'staff',   '9876543024', 'sanjay@vijayraj.com',      30000.00, '2023-11-07', 1),
(25, 'Varsha Kamble',       'varsha.staff', 'HASH:Varsha@789',      'staff',   '9876543025', 'varsha@vijayraj.com',      26000.00, '2024-01-02', 1),
(26, 'Tushar Ahire',        'tushar.staff', 'HASH:Tushar@789',      'staff',   '9876543026', 'tushar@vijayraj.com',      29500.00, '2024-02-15', 1),
(27, 'Seema Gawade',        'seema.staff',  'HASH:Seema@789',       'staff',   '9876543027', 'seema@vijayraj.com',       27500.00, '2024-03-28', 1),
(28, 'Kiran Dalvi',         'kiran.staff',  'HASH:Kiran@789',       'staff',   '9876543028', 'kiran@vijayraj.com',       31000.00, '2024-05-10', 1),
(29, 'Sunita Bhor',         'sunita.staff', 'HASH:Sunita@789',      'staff',   '9876543029', 'sunita@vijayraj.com',      28000.00, '2024-06-22', 1),
(30, 'Yogesh Mhatre',       'yogesh.staff', 'HASH:Yogesh@789',      'staff',   '9876543030', 'yogesh@vijayraj.com',      30000.00, '2024-08-05', 1),
(31, 'Pallavi Randive',     'pallavi.staff','HASH:Pallavi@789',     'staff',   '9876543031', 'pallavi@vijayraj.com',     27000.00, '2024-09-17', 1),
(32, 'Ashwin Desai',        'ashwin.staff', 'HASH:Ashwin@789',      'staff',   '9876543032', 'ashwin@vijayraj.com',      32000.00, '2024-10-30', 1),
(33, 'Lata Gokhale',        'lata.staff',   'HASH:Lata@789',        'staff',   '9876543033', 'lata@vijayraj.com',        26500.00, '2025-01-12', 1),
(34, 'Dinesh Sawant',       'dinesh.staff', 'HASH:Dinesh@789',      'staff',   '9876543034', 'dinesh@vijayraj.com',      29000.00, '2025-02-24', 1),
(35, 'Ritu Patel',          'ritu.staff',   'HASH:Ritu@789',        'staff',   '9876543035', 'ritu@vijayraj.com',        28500.00, '2025-03-15', 1),
(36, 'Hemant Thorat',       'hemant.staff', 'HASH:Hemant@789',      'staff',   '9876543036', 'hemant@vijayraj.com',      31000.00, '2025-04-28', 1),
(37, 'Smita Naik',          'smita.staff',  'HASH:Smita@789',       'staff',   '9876543037', 'smita@vijayraj.com',       27500.00, '2025-06-10', 1),
(38, 'Pramod Khaire',       'pramod.staff', 'HASH:Pramod@789',      'staff',   '9876543038', 'pramod@vijayraj.com',      30000.00, '2025-07-22', 1),
(39, 'Vandana Shirke',      'vandana.staff','HASH:Vandana@789',     'staff',   '9876543039', 'vandana@vijayraj.com',     28000.00, '2025-09-01', 1),
(40, 'Arun Phule',          'arun.staff',   'HASH:Arun@789',        'staff',   '9876543040', 'arun@vijayraj.com',        29500.00, '2025-10-14', 1),
(41, 'Geeta Salvi',         'geeta.staff',  'HASH:Geeta@789',       'staff',   '9876543041', 'geeta@vijayraj.com',       27000.00, '2025-11-26', 1),
(42, 'Milind Bagwe',        'milind.staff', 'HASH:Milind@789',      'staff',   '9876543042', 'milind@vijayraj.com',      32000.00, '2026-01-08', 1),
(43, 'Jyoti Khot',          'jyoti.staff',  'HASH:Jyoti@789',       'staff',   '9876543043', 'jyoti@vijayraj.com',       26500.00, '2026-02-20', 1),
(44, 'Nilesh Raut',         'nilesh.staff', 'HASH:Nilesh@789',      'staff',   '9876543044', 'nilesh@vijayraj.com',      29000.00, '2026-04-03', 1),
(45, 'Aparna Datar',        'aparna.staff', 'HASH:Aparna@789',      'staff',   '9876543045', 'aparna@vijayraj.com',      28500.00, '2026-05-16', 1),
(46, 'Rahul Ghosh',         'rahul.staff',  'HASH:Rahul@789',       'staff',   '9876543046', 'rahul@vijayraj.com',       30000.00, '2026-06-28', 1),
(47, 'Shubhangi Bhise',     'shubhangi.staff','HASH:Shubhangi@789', 'staff',   '9876543047', 'shubhangi@vijayraj.com',   27500.00, '2026-07-10', 1),
(48, 'Omkar Satpute',       'omkar.staff',  'HASH:Omkar@789',       'staff',   '9876543048', 'omkar@vijayraj.com',       31000.00, '2026-08-22', 1),
(49, 'Chitra Londhe',       'chitra.staff', 'HASH:Chitra@789',      'staff',   '9876543049', 'chitra@vijayraj.com',      28000.00, '2026-09-01', 1),
(50, 'Sameer Karpe',        'sameer.staff', 'HASH:Sameer@789',      'staff',   '9876543050', 'sameer@vijayraj.com',      30500.00, '2026-09-15', 1);


-- ── PRODUCTS (50 rows) ──────────────────────────────────────
-- First 5 original products, then 45 more. ~8 with low stock.
INSERT INTO products (id, product_code, name, category, purity, weight_grams, making_charge, price, stock_qty, reorder_level, design_code, description) VALUES
-- Original 5
(1,  'P101', 'Gold Ring',              'Gold',     '22K',   8.500,  3500.00,   35000.00,  25, 5, 'GR-001', 'Classic 22K gold ring with traditional design'),
(2,  'P102', 'Diamond Necklace',       'Diamond',  'VVS1',  45.000, 150000.00, 1200000.00, 8, 3, 'DN-001', 'Premium VVS1 diamond necklace with 18K gold chain'),
(3,  'P103', 'Silver Bracelet',        'Silver',   '925',   35.000, 5000.00,   42000.00,  30, 5, 'SB-001', '925 sterling silver bracelet with intricate carving'),
(4,  'P104', 'Gold Earrings',          'Gold',     '22K',   12.000, 5500.00,   55000.00,  20, 5, 'GE-001', 'Traditional 22K gold jhumka earrings'),
(5,  'P105', 'Gemstone Collection',    'Gems',     'Natural',0.000, 0.00,      1525000.00, 5, 2, 'GC-001', 'Yellow sapphire, blue sapphire, rashi stones collection'),
-- More Gold items
(6,  'P106', 'Gold Mangalsutra',       'Gold',     '22K',   18.000, 8000.00,   95000.00,  15, 5, 'GM-001', 'Traditional 22K gold mangalsutra with black beads'),
(7,  'P107', 'Gold Chain (Men)',       'Gold',     '22K',   25.000, 6000.00,   135000.00, 12, 5, 'GC-002', 'Thick 22K gold chain for men'),
(8,  'P108', 'Gold Pendant',           'Gold',     '18K',   5.500,  2500.00,   28000.00,  3,  5, 'GP-001', '18K gold pendant with Ganesh design'),  -- LOW STOCK
(9,  'P109', 'Gold Bangle (Set of 4)', 'Gold',     '22K',   48.000, 12000.00,  265000.00, 10, 5, 'GB-001', 'Set of 4 matching 22K gold bangles'),
(10, 'P110', 'Gold Nose Pin',          'Gold',     '22K',   1.200,  800.00,    8500.00,   2,  5, 'GN-001', 'Delicate 22K gold nose pin with tiny diamond'),  -- LOW STOCK
-- More Diamond items
(11, 'P111', 'Diamond Ring',           'Diamond',  'VS2',   6.000,  25000.00,  185000.00, 14, 5, 'DR-001', 'Solitaire VS2 diamond ring in 18K white gold'),
(12, 'P112', 'Diamond Earrings',       'Diamond',  'VVS2',  8.500,  35000.00,  245000.00, 7,  3, 'DE-001', 'VVS2 diamond stud earrings in platinum setting'),
(13, 'P113', 'Diamond Bracelet',       'Diamond',  'VS1',   22.000, 45000.00,  380000.00, 4,  3, 'DB-001', 'Tennis bracelet with VS1 diamonds in 18K gold'),  -- LOW STOCK
(14, 'P114', 'Diamond Pendant',        'Diamond',  'VVS1',  4.000,  18000.00,  155000.00, 9,  5, 'DP-001', 'Heart-shaped VVS1 diamond pendant'),
(15, 'P115', 'Diamond Mangalsutra',    'Diamond',  'VS2',   15.000, 28000.00,  225000.00, 6,  3, 'DM-001', 'Modern diamond mangalsutra with gold chain'),
-- Silver items
(16, 'P116', 'Silver Chain',           'Silver',   '925',   40.000, 3500.00,   32000.00,  35, 5, 'SC-001', '925 silver chain with lobster clasp'),
(17, 'P117', 'Silver Ring',            'Silver',   '925',   8.000,  1200.00,   5500.00,   40, 5, 'SR-001', 'Sterling silver ring with oxidized finish'),
(18, 'P118', 'Silver Anklet (Pair)',   'Silver',   '925',   50.000, 4000.00,   38000.00,  22, 5, 'SA-001', 'Pair of silver anklets with ghungroo'),
(19, 'P119', 'Silver Bangle (Set 6)',  'Silver',   '925',   120.000,8000.00,   75000.00,  1,  5, 'SBG-001','Set of 6 sterling silver bangles'),  -- LOW STOCK
(20, 'P120', 'Silver Earrings',        'Silver',   '925',   6.000,  900.00,    4200.00,   45, 5, 'SE-001', 'Silver jhumka earrings with mirror work'),
-- Platinum items
(21, 'P121', 'Platinum Ring (Men)',     'Platinum', '950',   10.000, 8000.00,   65000.00,  8,  3, 'PR-001', '950 platinum band ring for men'),
(22, 'P122', 'Platinum Chain',         'Platinum', '950',   20.000, 12000.00,  125000.00, 5,  3, 'PC-001', 'Elegant 950 platinum chain'),
(23, 'P123', 'Platinum Earrings',      'Platinum', '950',   7.000,  6000.00,   48000.00,  2,  3, 'PTE-001','950 platinum stud earrings'),  -- LOW STOCK
(24, 'P124', 'Platinum Bracelet',      'Platinum', '950',   18.000, 10000.00,  98000.00,  6,  3, 'PB-001', '950 platinum bracelet with diamond accents'),
(25, 'P125', 'Platinum Pendant',       'Platinum', '950',   5.000,  5000.00,   38000.00,  10, 5, 'PP-001', '950 platinum pendant with sapphire stone'),
-- Gems items
(26, 'P126', 'Yellow Sapphire (Pukhraj)','Gems',   'Natural',5.200, 0.00,      85000.00,  12, 3, 'YS-001', 'Natural certified yellow sapphire 5.2 carat'),
(27, 'P127', 'Blue Sapphire (Neelam)',  'Gems',    'Natural',4.800, 0.00,      125000.00, 8,  3, 'BS-001', 'Natural certified blue sapphire 4.8 carat'),
(28, 'P128', 'Ruby (Manik)',            'Gems',    'Natural',3.500, 0.00,      95000.00,  10, 3, 'RB-001', 'Burma ruby 3.5 carat certified'),
(29, 'P129', 'Emerald (Panna)',         'Gems',    'Natural',6.000, 0.00,      145000.00, 1,  3, 'EM-001', 'Colombian emerald 6 carat premium quality'),  -- LOW STOCK
(30, 'P130', 'Pearl (Moti) Necklace',   'Gems',   'Natural',45.000,5000.00,   55000.00,  15, 5, 'PL-001', 'South sea pearl necklace with gold clasp'),
-- More Gold
(31, 'P131', 'Gold Choker',            'Gold',     '22K',   35.000, 10000.00,  195000.00, 7,  3, 'GCH-001','22K gold choker necklace with kundan work'),
(32, 'P132', 'Gold Waist Chain',       'Gold',     '22K',   55.000, 15000.00,  310000.00, 4,  3, 'GW-001', '22K gold kamarband/waist chain'),
(33, 'P133', 'Gold Toe Ring (Pair)',    'Gold',     '22K',   3.000,  1000.00,   18000.00,  30, 5, 'GT-001', 'Pair of 22K gold toe rings'),
(34, 'P134', 'Gold Stud Earrings',     'Gold',     '18K',   3.500,  1500.00,   19500.00,  35, 5, 'GSE-001','18K gold daily-wear stud earrings'),
(35, 'P135', 'Gold Bracelet (Ladies)', 'Gold',     '22K',   14.000, 4500.00,   78000.00,  11, 5, 'GBL-001','Ladies 22K gold bracelet with floral design'),
-- More Diamond
(36, 'P136', 'Diamond Choker',         'Diamond',  'VS1',   65.000, 85000.00,  750000.00, 3,  2, 'DCH-001','VS1 diamond choker with emerald accents'),
(37, 'P137', 'Diamond Nose Pin',       'Diamond',  'VVS2',  0.500,  3000.00,   22000.00,  18, 5, 'DNP-001','Tiny VVS2 diamond nose pin in white gold'),
(38, 'P138', 'Diamond Bangle',         'Diamond',  'VS2',   28.000, 55000.00,  420000.00, 5,  3, 'DBG-001','VS2 diamond bangle in 18K gold'),
-- More Silver
(39, 'P139', 'Silver Pendant',         'Silver',   '925',   5.000,  800.00,    3800.00,   50, 5, 'SPD-001','925 silver Om pendant'),
(40, 'P140', 'Silver Wine Glass Set',  'Silver',   '925',   200.000,12000.00,  125000.00, 3,  3, 'SWG-001','Set of 2 sterling silver wine glasses'),  -- LOW STOCK
-- More Gems
(41, 'P141', 'Cat Eye (Lehsunia)',     'Gems',     'Natural',4.000, 0.00,      35000.00,  14, 3, 'CE-001', 'Chrysoberyl cat eye 4 carat certified'),
(42, 'P142', 'Coral (Moonga)',          'Gems',    'Natural',7.500, 0.00,      28000.00,  20, 5, 'CR-001', 'Italian red coral 7.5 carat triangular'),
(43, 'P143', 'Hessonite (Gomed)',       'Gems',    'Natural',5.000, 0.00,      18000.00,  25, 5, 'HS-001', 'Sri Lankan hessonite garnet 5 carat'),
(44, 'P144', 'Opal Ring',              'Gems',     'Natural',3.200, 2000.00,   42000.00,  9,  3, 'OR-001', 'Australian opal in 18K gold ring setting'),
(45, 'P145', 'Turquoise Pendant',      'Gems',     'Natural',8.000, 1500.00,   15000.00,  18, 5, 'TP-001', 'Firoza pendant in silver setting'),
-- More mixed
(46, 'P146', 'Gold Temple Necklace',   'Gold',     '22K',   85.000, 25000.00,  485000.00, 3,  2, 'GTN-001','Traditional South Indian temple jewellery necklace'),
(47, 'P147', 'Platinum Wedding Band',  'Platinum', '950',   8.000,  6000.00,   52000.00,  12, 5, 'PWB-001','His & hers 950 platinum wedding band'),
(48, 'P148', 'Silver Pooja Thali Set', 'Silver',   '925',   350.000,15000.00,  185000.00, 6,  3, 'SPT-001','Complete silver pooja thali set with accessories'),
(49, 'P149', 'Diamond Solitaire Ring', 'Diamond',  'IF',    4.500,  50000.00,  550000.00, 2,  2, 'DSR-001','Internally flawless 1 carat solitaire in platinum'),
(50, 'P150', 'Gold Baby Bracelet',     'Gold',     '22K',   5.000,  1500.00,   30000.00,  20, 5, 'GBB-001','22K gold bracelet for infants with bell charms');


-- ── CUSTOMERS (50 rows) ─────────────────────────────────────
INSERT INTO customers (id, customer_code, name, phone, email, address, city, loyalty_points, created_at) VALUES
(1,  'C01', 'Disha Sherigar',      '9876543210', 'disha.sherigar@gmail.com',    'Flat 12, Koregaon Park', 'Pune',       0, '2024-01-15 10:30:00'),
(2,  'C02', 'Archita Shelar',      '9876000112', 'archita.shelar@gmail.com',    '45, FC Road',            'Pune',       0, '2024-01-20 11:00:00'),
(3,  'C03', 'Atharva Tikone',      '9123456789', 'atharva.tikone@gmail.com',    'B-201, Hinjewadi Phase 2','Pune',      0, '2024-02-05 09:45:00'),
(4,  'C04', 'Ramesh Patil',        '9823456701', 'ramesh.patil@yahoo.com',      '78, MG Road',            'Pune',       0, '2024-02-10 14:20:00'),
(5,  'C05', 'Sunita Deshmukh',     '9823456702', 'sunita.d@gmail.com',          '12, Karve Nagar',        'Pune',       0, '2024-02-15 16:00:00'),
(6,  'C06', 'Prakash Joshi',       '9823456703', 'prakash.j@gmail.com',         'A-5, Andheri West',      'Mumbai',     0, '2024-02-20 10:00:00'),
(7,  'C07', 'Meera Kulkarni',      '9823456704', 'meera.k@gmail.com',           '34, Bandra East',        'Mumbai',     0, '2024-03-01 11:30:00'),
(8,  'C08', 'Sunil Gaikwad',       '9823456705', 'sunil.g@hotmail.com',         '56, Dadar West',         'Mumbai',     0, '2024-03-05 13:45:00'),
(9,  'C09', 'Kavita Bhosale',      '9823456706', 'kavita.b@gmail.com',          '89, Peth Road',          'Nashik',     0, '2024-03-10 09:15:00'),
(10, 'C10', 'Nitin Sawant',        '9823456707', 'nitin.s@gmail.com',           '23, Civil Lines',        'Nagpur',     0, '2024-03-15 15:30:00'),
(11, 'C11', 'Anjali Thakur',       '9823456708', 'anjali.t@gmail.com',          '67, Shivaji Nagar',      'Pune',       0, '2024-03-20 10:45:00'),
(12, 'C12', 'Vikram Pawar',        '9823456709', 'vikram.p@gmail.com',          '45, Camp Area',          'Pune',       0, '2024-03-25 12:00:00'),
(13, 'C13', 'Pooja Wagh',          '9823456710', 'pooja.w@gmail.com',           '12, Aundh',              'Pune',       0, '2024-04-01 14:30:00'),
(14, 'C14', 'Deepak Chavan',       '9823456711', 'deepak.c@gmail.com',          '78, Viman Nagar',        'Pune',       0, '2024-04-05 09:00:00'),
(15, 'C15', 'Rashmi Iyer',         '9823456712', 'rashmi.i@gmail.com',          '34, Powai',              'Mumbai',     0, '2024-04-10 11:15:00'),
(16, 'C16', 'Manoj Kale',          '9823456713', 'manoj.k@gmail.com',           '56, Borivali West',      'Mumbai',     0, '2024-04-15 13:00:00'),
(17, 'C17', 'Rekha Mane',          '9823456714', 'rekha.m@gmail.com',           '89, Gangapur Road',      'Nashik',     0, '2024-04-20 15:45:00'),
(18, 'C18', 'Ganesh Sonawane',     '9823456715', 'ganesh.s@gmail.com',          '23, Dharampeth',         'Nagpur',     0, '2024-04-25 10:30:00'),
(19, 'C19', 'Nisha Phadke',        '9823456716', 'nisha.p@gmail.com',           '67, SB Road',            'Pune',       0, '2024-05-01 12:15:00'),
(20, 'C20', 'Sachin Deshpande',    '9823456717', 'sachin.d@gmail.com',          '45, Kothrud',            'Pune',       0, '2024-05-05 14:00:00'),
(21, 'C21', 'Manisha Gokhale',     '9823456718', 'manisha.g@gmail.com',         '12, Deccan',             'Pune',       0, '2024-05-10 09:30:00'),
(22, 'C22', 'Ashwin Desai',        '9823456719', 'ashwin.d@gmail.com',          '78, Juhu',               'Mumbai',     0, '2024-05-15 11:45:00'),
(23, 'C23', 'Lata Nimbalkar',      '9823456720', 'lata.n@gmail.com',            '34, Thane West',         'Mumbai',     0, '2024-05-20 13:30:00'),
(24, 'C24', 'Dinesh Raut',         '9823456721', 'dinesh.r@gmail.com',          '56, College Road',       'Nashik',     0, '2024-05-25 15:00:00'),
(25, 'C25', 'Ritu Patel',          '9823456722', 'ritu.p@gmail.com',            '89, Sadar',              'Nagpur',     0, '2024-06-01 10:00:00'),
(26, 'C26', 'Hemant Thorat',       '9823456723', 'hemant.t@gmail.com',          '23, Wakad',              'Pune',       0, '2024-06-05 12:30:00'),
(27, 'C27', 'Smita Naik',          '9823456724', 'smita.n@gmail.com',           '67, Pimple Saudagar',    'Pune',       0, '2024-06-10 14:15:00'),
(28, 'C28', 'Pramod Khaire',       '9823456725', 'pramod.k@gmail.com',          '45, Worli',              'Mumbai',     0, '2024-06-15 09:45:00'),
(29, 'C29', 'Vandana Shirke',      '9823456726', 'vandana.s@gmail.com',         '12, Malad East',         'Mumbai',     0, '2024-06-20 11:00:00'),
(30, 'C30', 'Arun Phule',          '9823456727', 'arun.p@gmail.com',            '78, Satpur',             'Nashik',     0, '2024-06-25 13:15:00'),
(31, 'C31', 'Geeta Salvi',         '9823456728', 'geeta.s@gmail.com',           '34, Ramdaspeth',         'Nagpur',     0, '2024-07-01 15:30:00'),
(32, 'C32', 'Milind Bagwe',        '9823456729', 'milind.b@gmail.com',          '56, Hadapsar',           'Pune',       0, '2024-07-05 10:15:00'),
(33, 'C33', 'Jyoti Khot',          '9823456730', 'jyoti.k@gmail.com',           '89, Magarpatta',         'Pune',       0, '2024-07-10 12:00:00'),
(34, 'C34', 'Nilesh Satpute',      '9823456731', 'nilesh.s@gmail.com',          '23, Versova',            'Mumbai',     0, '2024-07-15 14:45:00'),
(35, 'C35', 'Aparna Datar',        '9823456732', 'aparna.d@gmail.com',          '67, Goregaon East',      'Mumbai',     0, '2024-07-20 09:00:00'),
(36, 'C36', 'Rahul Ghosh',         '9823456733', 'rahul.g@gmail.com',           '45, Ambad',              'Nashik',     0, '2024-07-25 11:30:00'),
(37, 'C37', 'Shubhangi Bhise',     '9823456734', 'shubhangi.b@gmail.com',       '12, Manewada',           'Nagpur',     0, '2024-08-01 13:00:00'),
(38, 'C38', 'Omkar Londhe',        '9823456735', 'omkar.l@gmail.com',           '78, Baner',              'Pune',       0, '2024-08-05 15:15:00'),
(39, 'C39', 'Chitra Karpe',        '9823456736', 'chitra.k@gmail.com',          '34, Pashan',             'Pune',       0, '2024-08-10 10:30:00'),
(40, 'C40', 'Sameer Jagtap',       '9823456737', 'sameer.j@gmail.com',          '56, Santacruz West',     'Mumbai',     0, '2024-08-15 12:45:00'),
(41, 'C41', 'Pranjali Mahajan',    '9823456738', 'pranjali.m@gmail.com',        '89, Chembur',            'Mumbai',     0, '2024-08-20 14:00:00'),
(42, 'C42', 'Tanmay Kulkarni',     '9823456739', 'tanmay.k@gmail.com',          '23, Trimbak Road',       'Nashik',     0, '2024-08-25 09:15:00'),
(43, 'C43', 'Sarika Dhage',        '9823456740', 'sarika.d@gmail.com',          '67, Gandhibagh',         'Nagpur',     0, '2024-09-01 11:00:00'),
(44, 'C44', 'Abhijit Mhatre',      '9823456741', 'abhijit.m@gmail.com',         '45, Chinchwad',          'Pune',       0, '2024-09-05 13:30:00'),
(45, 'C45', 'Revati Godbole',      '9823456742', 'revati.g@gmail.com',          '12, Pimpri',             'Pune',       0, '2024-09-10 15:00:00'),
(46, 'C46', 'Tushar Mhaske',       '9823456743', 'tushar.m@gmail.com',          '78, Mulund West',        'Mumbai',     0, '2024-09-15 10:45:00'),
(47, 'C47', 'Sonal Khanvilkar',    '9823456744', 'sonal.k@gmail.com',           '34, Dombivli East',      'Mumbai',     0, '2024-09-20 12:30:00'),
(48, 'C48', 'Vishal Tawde',        '9823456745', 'vishal.t@gmail.com',          '56, Panchavati',         'Nashik',     0, '2024-09-25 14:15:00'),
(49, 'C49', 'Madhuri Lele',        '9823456746', 'madhuri.l@gmail.com',         '89, Sitabuldi',          'Nagpur',     0, '2024-10-01 09:30:00'),
(50, 'C50', 'Kiran Bapat',         '9823456747', 'kiran.b@gmail.com',           '23, Shaniwar Wada Road', 'Pune',       0, '2024-10-05 11:45:00');


-- ── METAL RATES (55 daily entries with realistic fluctuations) ──
INSERT INTO metal_rates (rate_date, metal, rate_per_gram) VALUES
-- March 2026
('2026-03-28', 'Gold 24K', 7250.00), ('2026-03-28', 'Gold 22K', 6645.00), ('2026-03-28', 'Silver', 92.50), ('2026-03-28', 'Platinum', 3150.00),
('2026-03-29', 'Gold 24K', 7280.00), ('2026-03-29', 'Gold 22K', 6673.00), ('2026-03-29', 'Silver', 93.00), ('2026-03-29', 'Platinum', 3170.00),
('2026-03-30', 'Gold 24K', 7310.00), ('2026-03-30', 'Gold 22K', 6700.00), ('2026-03-30', 'Silver', 92.80), ('2026-03-30', 'Platinum', 3160.00),
('2026-03-31', 'Gold 24K', 7295.00), ('2026-03-31', 'Gold 22K', 6686.00), ('2026-03-31', 'Silver', 93.20), ('2026-03-31', 'Platinum', 3180.00),
-- April 2026
('2026-04-01', 'Gold 24K', 7320.00), ('2026-04-01', 'Gold 22K', 6710.00), ('2026-04-01', 'Silver', 93.50), ('2026-04-01', 'Platinum', 3200.00),
('2026-04-05', 'Gold 24K', 7350.00), ('2026-04-05', 'Gold 22K', 6738.00), ('2026-04-05', 'Silver', 94.00), ('2026-04-05', 'Platinum', 3220.00),
('2026-04-10', 'Gold 24K', 7380.00), ('2026-04-10', 'Gold 22K', 6765.00), ('2026-04-10', 'Silver', 93.80), ('2026-04-10', 'Platinum', 3210.00),
('2026-04-15', 'Gold 24K', 7400.00), ('2026-04-15', 'Gold 22K', 6783.00), ('2026-04-15', 'Silver', 94.50), ('2026-04-15', 'Platinum', 3240.00),
('2026-04-20', 'Gold 24K', 7370.00), ('2026-04-20', 'Gold 22K', 6756.00), ('2026-04-20', 'Silver', 94.20), ('2026-04-20', 'Platinum', 3230.00),
('2026-04-25', 'Gold 24K', 7420.00), ('2026-04-25', 'Gold 22K', 6801.00), ('2026-04-25', 'Silver', 95.00), ('2026-04-25', 'Platinum', 3250.00),
('2026-04-30', 'Gold 24K', 7450.00), ('2026-04-30', 'Gold 22K', 6828.00), ('2026-04-30', 'Silver', 95.50), ('2026-04-30', 'Platinum', 3270.00),
-- May 2026
('2026-05-05', 'Gold 24K', 7480.00), ('2026-05-05', 'Gold 22K', 6856.00), ('2026-05-05', 'Silver', 96.00), ('2026-05-05', 'Platinum', 3290.00),
('2026-05-10', 'Gold 24K', 7510.00), ('2026-05-10', 'Gold 22K', 6883.00), ('2026-05-10', 'Silver', 95.80), ('2026-05-10', 'Platinum', 3280.00),
('2026-05-15', 'Gold 24K', 7530.00), ('2026-05-15', 'Gold 22K', 6901.00), ('2026-05-15', 'Silver', 96.50), ('2026-05-15', 'Platinum', 3310.00),
('2026-05-20', 'Gold 24K', 7500.00), ('2026-05-20', 'Gold 22K', 6875.00), ('2026-05-20', 'Silver', 96.20), ('2026-05-20', 'Platinum', 3300.00),
('2026-05-25', 'Gold 24K', 7550.00), ('2026-05-25', 'Gold 22K', 6920.00), ('2026-05-25', 'Silver', 97.00), ('2026-05-25', 'Platinum', 3320.00),
('2026-05-31', 'Gold 24K', 7580.00), ('2026-05-31', 'Gold 22K', 6947.00), ('2026-05-31', 'Silver', 97.50), ('2026-05-31', 'Platinum', 3340.00),
-- June 2026
('2026-06-05', 'Gold 24K', 7600.00), ('2026-06-05', 'Gold 22K', 6966.00), ('2026-06-05', 'Silver', 98.00), ('2026-06-05', 'Platinum', 3360.00),
('2026-06-10', 'Gold 24K', 7630.00), ('2026-06-10', 'Gold 22K', 6993.00), ('2026-06-10', 'Silver', 97.80), ('2026-06-10', 'Platinum', 3350.00),
('2026-06-15', 'Gold 24K', 7650.00), ('2026-06-15', 'Gold 22K', 7011.00), ('2026-06-15', 'Silver', 98.50), ('2026-06-15', 'Platinum', 3380.00),
('2026-06-20', 'Gold 24K', 7620.00), ('2026-06-20', 'Gold 22K', 6984.00), ('2026-06-20', 'Silver', 98.20), ('2026-06-20', 'Platinum', 3370.00),
('2026-06-25', 'Gold 24K', 7680.00), ('2026-06-25', 'Gold 22K', 7039.00), ('2026-06-25', 'Silver', 99.00), ('2026-06-25', 'Platinum', 3400.00),
('2026-06-30', 'Gold 24K', 7700.00), ('2026-06-30', 'Gold 22K', 7057.00), ('2026-06-30', 'Silver', 99.50), ('2026-06-30', 'Platinum', 3420.00),
-- July 2026
('2026-07-05', 'Gold 24K', 7720.00), ('2026-07-05', 'Gold 22K', 7075.00), ('2026-07-05', 'Silver', 100.00), ('2026-07-05', 'Platinum', 3440.00),
('2026-07-10', 'Gold 24K', 7750.00), ('2026-07-10', 'Gold 22K', 7103.00), ('2026-07-10', 'Silver', 99.80), ('2026-07-10', 'Platinum', 3430.00),
('2026-07-15', 'Gold 24K', 7780.00), ('2026-07-15', 'Gold 22K', 7130.00), ('2026-07-15', 'Silver', 100.50), ('2026-07-15', 'Platinum', 3460.00),
('2026-07-20', 'Gold 24K', 7800.00), ('2026-07-20', 'Gold 22K', 7148.00), ('2026-07-20', 'Silver', 101.00), ('2026-07-20', 'Platinum', 3480.00),
('2026-07-25', 'Gold 24K', 7830.00), ('2026-07-25', 'Gold 22K', 7176.00), ('2026-07-25', 'Silver', 100.80), ('2026-07-25', 'Platinum', 3470.00),
('2026-07-31', 'Gold 24K', 7850.00), ('2026-07-31', 'Gold 22K', 7194.00), ('2026-07-31', 'Silver', 101.50), ('2026-07-31', 'Platinum', 3500.00),
-- August 2026
('2026-08-05', 'Gold 24K', 7880.00), ('2026-08-05', 'Gold 22K', 7221.00), ('2026-08-05', 'Silver', 102.00), ('2026-08-05', 'Platinum', 3520.00),
('2026-08-10', 'Gold 24K', 7900.00), ('2026-08-10', 'Gold 22K', 7240.00), ('2026-08-10', 'Silver', 101.80), ('2026-08-10', 'Platinum', 3510.00),
('2026-08-15', 'Gold 24K', 7920.00), ('2026-08-15', 'Gold 22K', 7258.00), ('2026-08-15', 'Silver', 102.50), ('2026-08-15', 'Platinum', 3540.00),
('2026-08-20', 'Gold 24K', 7950.00), ('2026-08-20', 'Gold 22K', 7286.00), ('2026-08-20', 'Silver', 103.00), ('2026-08-20', 'Platinum', 3560.00),
('2026-08-25', 'Gold 24K', 7980.00), ('2026-08-25', 'Gold 22K', 7313.00), ('2026-08-25', 'Silver', 102.80), ('2026-08-25', 'Platinum', 3550.00),
('2026-08-31', 'Gold 24K', 8000.00), ('2026-08-31', 'Gold 22K', 7333.00), ('2026-08-31', 'Silver', 103.50), ('2026-08-31', 'Platinum', 3580.00),
-- September 2026
('2026-09-05', 'Gold 24K', 8020.00), ('2026-09-05', 'Gold 22K', 7351.00), ('2026-09-05', 'Silver', 104.00), ('2026-09-05', 'Platinum', 3600.00),
('2026-09-10', 'Gold 24K', 8050.00), ('2026-09-10', 'Gold 22K', 7379.00), ('2026-09-10', 'Silver', 103.80), ('2026-09-10', 'Platinum', 3590.00),
('2026-09-15', 'Gold 24K', 8080.00), ('2026-09-15', 'Gold 22K', 7406.00), ('2026-09-15', 'Silver', 104.50), ('2026-09-15', 'Platinum', 3620.00),
('2026-09-20', 'Gold 24K', 8100.00), ('2026-09-20', 'Gold 22K', 7425.00), ('2026-09-20', 'Silver', 105.00), ('2026-09-20', 'Platinum', 3640.00),
('2026-09-24', 'Gold 24K', 8120.00), ('2026-09-24', 'Gold 22K', 7443.00), ('2026-09-24', 'Silver', 104.80), ('2026-09-24', 'Platinum', 3630.00);


-- ── INVOICES (55 invoices spread over 6 months) ─────────────
-- Totals: subtotal = sum of line_totals, discount applied, GST = 3% of (subtotal - discount), grand_total = subtotal - discount + GST
-- Triggers will fire on insert, so we need to account for that in stock numbers above
-- We insert invoices WITHOUT triggers first (triggers are created after seeding in init_db.py)

INSERT INTO invoices (id, invoice_no, customer_id, user_id, invoice_date, subtotal, discount_percent, gst_percent, gst_amount, grand_total, payment_mode) VALUES
(1,  'INV-20260401-0001', 1,  4, '2026-04-01 10:30:00',  35000.00,  0.00, 3.00, 1050.00,  36050.00,  'Cash'),
(2,  'INV-20260402-0001', 2,  5, '2026-04-02 11:00:00',  1200000.00, 5.00, 3.00, 34200.00, 1174200.00, 'Card'),
(3,  'INV-20260403-0001', 3,  4, '2026-04-03 14:20:00',  42000.00,  0.00, 3.00, 1260.00,  43260.00,  'UPI'),
(4,  'INV-20260405-0001', 4,  6, '2026-04-05 09:45:00',  55000.00,  2.00, 3.00, 1617.00,  55517.00,  'Cash'),
(5,  'INV-20260407-0001', 5,  4, '2026-04-07 16:00:00',  1525000.00, 3.00, 3.00, 44377.50, 1523627.50, 'Card'),
(6,  'INV-20260410-0001', 6,  5, '2026-04-10 10:00:00',  95000.00,  0.00, 3.00, 2850.00,  97850.00,  'Cash'),
(7,  'INV-20260412-0001', 7,  4, '2026-04-12 11:30:00',  135000.00, 5.00, 3.00, 3847.50,  132097.50, 'UPI'),
(8,  'INV-20260415-0001', 8,  6, '2026-04-15 13:45:00',  28000.00,  0.00, 3.00, 840.00,   28840.00,  'Cash'),
(9,  'INV-20260418-0001', 9,  4, '2026-04-18 09:15:00',  265000.00, 2.00, 3.00, 7791.00,  267591.00, 'Card'),
(10, 'INV-20260420-0001', 10, 5, '2026-04-20 15:30:00',  8500.00,   0.00, 3.00, 255.00,   8755.00,   'UPI'),
(11, 'INV-20260422-0001', 11, 4, '2026-04-22 10:45:00',  185000.00, 0.00, 3.00, 5550.00,  190550.00, 'Cash'),
(12, 'INV-20260425-0001', 12, 6, '2026-04-25 12:00:00',  245000.00, 3.00, 3.00, 7129.50,  244779.50, 'Card'),
(13, 'INV-20260428-0001', 13, 4, '2026-04-28 14:30:00',  380000.00, 0.00, 3.00, 11400.00, 391400.00, 'Cash'),
(14, 'INV-20260501-0001', 14, 5, '2026-05-01 09:00:00',  155000.00, 5.00, 3.00, 4417.50,  151667.50, 'UPI'),
(15, 'INV-20260503-0001', 15, 4, '2026-05-03 11:15:00',  225000.00, 0.00, 3.00, 6750.00,  231750.00, 'Cash'),
(16, 'INV-20260506-0001', 16, 6, '2026-05-06 13:00:00',  32000.00,  0.00, 3.00, 960.00,   32960.00,  'Card'),
(17, 'INV-20260508-0001', 17, 4, '2026-05-08 15:45:00',  5500.00,   0.00, 3.00, 165.00,   5665.00,   'UPI'),
(18, 'INV-20260510-0001', 18, 5, '2026-05-10 10:30:00',  38000.00,  0.00, 3.00, 1140.00,  39140.00,  'Cash'),
(19, 'INV-20260513-0001', 19, 4, '2026-05-13 12:15:00',  75000.00,  2.00, 3.00, 2205.00,  75705.00,  'Card'),
(20, 'INV-20260515-0001', 20, 6, '2026-05-15 14:00:00',  4200.00,   0.00, 3.00, 126.00,   4326.00,   'UPI'),
(21, 'INV-20260518-0001', 21, 4, '2026-05-18 09:30:00',  65000.00,  0.00, 3.00, 1950.00,  66950.00,  'Cash'),
(22, 'INV-20260520-0001', 22, 5, '2026-05-20 11:45:00',  125000.00, 0.00, 3.00, 3750.00,  128750.00, 'Card'),
(23, 'INV-20260523-0001', 23, 4, '2026-05-23 13:30:00',  48000.00,  0.00, 3.00, 1440.00,  49440.00,  'UPI'),
(24, 'INV-20260525-0001', 24, 6, '2026-05-25 15:00:00',  98000.00,  3.00, 3.00, 2851.80,  97921.80,  'Cash'),
(25, 'INV-20260528-0001', 25, 4, '2026-05-28 10:00:00',  38000.00,  0.00, 3.00, 1140.00,  39140.00,  'Card'),
(26, 'INV-20260601-0001', 26, 5, '2026-06-01 12:30:00',  85000.00,  0.00, 3.00, 2550.00,  87550.00,  'UPI'),
(27, 'INV-20260603-0001', 27, 4, '2026-06-03 14:15:00',  125000.00, 0.00, 3.00, 3750.00,  128750.00, 'Cash'),
(28, 'INV-20260606-0001', 28, 6, '2026-06-06 09:45:00',  95000.00,  2.00, 3.00, 2793.00,  95893.00,  'Card'),
(29, 'INV-20260608-0001', 29, 4, '2026-06-08 11:00:00',  145000.00, 0.00, 3.00, 4350.00,  149350.00, 'UPI'),
(30, 'INV-20260611-0001', 30, 5, '2026-06-11 13:15:00',  55000.00,  0.00, 3.00, 1650.00,  56650.00,  'Cash'),
(31, 'INV-20260613-0001', 31, 4, '2026-06-13 15:30:00',  195000.00, 5.00, 3.00, 5557.50,  190807.50, 'Card'),
(32, 'INV-20260616-0001', 32, 6, '2026-06-16 10:15:00',  310000.00, 0.00, 3.00, 9300.00,  319300.00, 'Cash'),
(33, 'INV-20260618-0001', 33, 4, '2026-06-18 12:00:00',  18000.00,  0.00, 3.00, 540.00,   18540.00,  'UPI'),
(34, 'INV-20260621-0001', 34, 5, '2026-06-21 14:45:00',  19500.00,  0.00, 3.00, 585.00,   20085.00,  'Cash'),
(35, 'INV-20260623-0001', 35, 4, '2026-06-23 09:00:00',  78000.00,  0.00, 3.00, 2340.00,  80340.00,  'Card'),
(36, 'INV-20260626-0001', 36, 6, '2026-06-26 11:30:00',  750000.00, 5.00, 3.00, 21375.00, 733875.00, 'UPI'),
(37, 'INV-20260628-0001', 37, 4, '2026-06-28 13:00:00',  22000.00,  0.00, 3.00, 660.00,   22660.00,  'Cash'),
(38, 'INV-20260701-0001', 38, 5, '2026-07-01 15:15:00',  420000.00, 3.00, 3.00, 12222.00, 419622.00, 'Card'),
(39, 'INV-20260703-0001', 39, 4, '2026-07-03 10:30:00',  3800.00,   0.00, 3.00, 114.00,   3914.00,   'UPI'),
(40, 'INV-20260706-0001', 40, 6, '2026-07-06 12:45:00',  125000.00, 0.00, 3.00, 3750.00,  128750.00, 'Cash'),
(41, 'INV-20260708-0001', 41, 4, '2026-07-08 14:00:00',  35000.00,  0.00, 3.00, 1050.00,  36050.00,  'Card'),
(42, 'INV-20260711-0001', 42, 5, '2026-07-11 09:15:00',  28000.00,  0.00, 3.00, 840.00,   28840.00,  'UPI'),
(43, 'INV-20260713-0001', 43, 4, '2026-07-13 11:00:00',  18000.00,  0.00, 3.00, 540.00,   18540.00,  'Cash'),
(44, 'INV-20260716-0001', 44, 6, '2026-07-16 13:30:00',  42000.00,  0.00, 3.00, 1260.00,  43260.00,  'Card'),
(45, 'INV-20260718-0001', 45, 4, '2026-07-18 15:00:00',  15000.00,  0.00, 3.00, 450.00,   15450.00,  'UPI'),
(46, 'INV-20260721-0001', 46, 5, '2026-07-21 10:45:00',  485000.00, 5.00, 3.00, 13822.50, 474572.50, 'Cash'),
(47, 'INV-20260723-0001', 47, 4, '2026-07-23 12:30:00',  52000.00,  0.00, 3.00, 1560.00,  53560.00,  'Card'),
(48, 'INV-20260726-0001', 48, 6, '2026-07-26 14:15:00',  185000.00, 0.00, 3.00, 5550.00,  190550.00, 'UPI'),
(49, 'INV-20260728-0001', 49, 4, '2026-07-28 09:30:00',  550000.00, 3.00, 3.00, 16005.00, 549505.00, 'Cash'),
(50, 'INV-20260801-0001', 50, 5, '2026-08-01 11:45:00',  30000.00,  0.00, 3.00, 900.00,   30900.00,  'Card'),
-- Recent invoices in Sep 2026
(51, 'INV-20260905-0001', 1,  4, '2026-09-05 10:00:00',  90000.00,  0.00, 3.00, 2700.00,  92700.00,  'Cash'),
(52, 'INV-20260910-0001', 3,  5, '2026-09-10 14:30:00',  70000.00,  2.00, 3.00, 2058.00,  70658.00,  'UPI'),
(53, 'INV-20260915-0001', 5,  4, '2026-09-15 11:00:00',  227000.00, 0.00, 3.00, 6810.00,  233810.00, 'Card'),
(54, 'INV-20260920-0001', 7,  6, '2026-09-20 16:00:00',  163000.00, 5.00, 3.00, 4645.50,  159495.50, 'Cash'),
(55, 'INV-20260924-0001', 2,  4, '2026-09-24 09:00:00',  320000.00, 0.00, 3.00, 9600.00,  329600.00, 'Card');


-- ── INVOICE ITEMS (matching above invoices, 1-3 items each) ──
INSERT INTO invoice_items (invoice_id, product_id, quantity, unit_price, line_total) VALUES
-- Invoice 1: Gold Ring x1
(1, 1, 1, 35000.00, 35000.00),
-- Invoice 2: Diamond Necklace x1
(2, 2, 1, 1200000.00, 1200000.00),
-- Invoice 3: Silver Bracelet x1
(3, 3, 1, 42000.00, 42000.00),
-- Invoice 4: Gold Earrings x1
(4, 4, 1, 55000.00, 55000.00),
-- Invoice 5: Gemstone Collection x1
(5, 5, 1, 1525000.00, 1525000.00),
-- Invoice 6: Gold Mangalsutra x1
(6, 6, 1, 95000.00, 95000.00),
-- Invoice 7: Gold Chain x1
(7, 7, 1, 135000.00, 135000.00),
-- Invoice 8: Gold Pendant x1
(8, 8, 1, 28000.00, 28000.00),
-- Invoice 9: Gold Bangle Set x1
(9, 9, 1, 265000.00, 265000.00),
-- Invoice 10: Gold Nose Pin x1
(10, 10, 1, 8500.00, 8500.00),
-- Invoice 11: Diamond Ring x1
(11, 11, 1, 185000.00, 185000.00),
-- Invoice 12: Diamond Earrings x1
(12, 12, 1, 245000.00, 245000.00),
-- Invoice 13: Diamond Bracelet x1
(13, 13, 1, 380000.00, 380000.00),
-- Invoice 14: Diamond Pendant x1
(14, 14, 1, 155000.00, 155000.00),
-- Invoice 15: Diamond Mangalsutra x1
(15, 15, 1, 225000.00, 225000.00),
-- Invoice 16: Silver Chain x1
(16, 16, 1, 32000.00, 32000.00),
-- Invoice 17: Silver Ring x1
(17, 17, 1, 5500.00, 5500.00),
-- Invoice 18: Silver Anklet x1
(18, 18, 1, 38000.00, 38000.00),
-- Invoice 19: Silver Bangle Set x1
(19, 19, 1, 75000.00, 75000.00),
-- Invoice 20: Silver Earrings x1
(20, 20, 1, 4200.00, 4200.00),
-- Invoice 21: Platinum Ring x1
(21, 21, 1, 65000.00, 65000.00),
-- Invoice 22: Platinum Chain x1
(22, 22, 1, 125000.00, 125000.00),
-- Invoice 23: Platinum Earrings x1
(23, 23, 1, 48000.00, 48000.00),
-- Invoice 24: Platinum Bracelet x1
(24, 24, 1, 98000.00, 98000.00),
-- Invoice 25: Platinum Pendant x1
(25, 25, 1, 38000.00, 38000.00),
-- Invoice 26: Yellow Sapphire x1
(26, 26, 1, 85000.00, 85000.00),
-- Invoice 27: Blue Sapphire x1
(27, 27, 1, 125000.00, 125000.00),
-- Invoice 28: Ruby x1
(28, 28, 1, 95000.00, 95000.00),
-- Invoice 29: Emerald x1
(29, 29, 1, 145000.00, 145000.00),
-- Invoice 30: Pearl Necklace x1
(30, 30, 1, 55000.00, 55000.00),
-- Invoice 31: Gold Choker x1
(31, 31, 1, 195000.00, 195000.00),
-- Invoice 32: Gold Waist Chain x1
(32, 32, 1, 310000.00, 310000.00),
-- Invoice 33: Gold Toe Ring x1
(33, 33, 1, 18000.00, 18000.00),
-- Invoice 34: Gold Stud Earrings x1
(34, 34, 1, 19500.00, 19500.00),
-- Invoice 35: Gold Bracelet Ladies x1
(35, 35, 1, 78000.00, 78000.00),
-- Invoice 36: Diamond Choker x1
(36, 36, 1, 750000.00, 750000.00),
-- Invoice 37: Diamond Nose Pin x1
(37, 37, 1, 22000.00, 22000.00),
-- Invoice 38: Diamond Bangle x1
(38, 38, 1, 420000.00, 420000.00),
-- Invoice 39: Silver Pendant x1
(39, 39, 1, 3800.00, 3800.00),
-- Invoice 40: Silver Wine Glass Set x1
(40, 40, 1, 125000.00, 125000.00),
-- Invoice 41: Cat Eye x1
(41, 41, 1, 35000.00, 35000.00),
-- Invoice 42: Coral x1
(42, 42, 1, 28000.00, 28000.00),
-- Invoice 43: Hessonite x1
(43, 43, 1, 18000.00, 18000.00),
-- Invoice 44: Opal Ring x1
(44, 44, 1, 42000.00, 42000.00),
-- Invoice 45: Turquoise Pendant x1
(45, 45, 1, 15000.00, 15000.00),
-- Invoice 46: Gold Temple Necklace x1
(46, 46, 1, 485000.00, 485000.00),
-- Invoice 47: Platinum Wedding Band x1
(47, 47, 1, 52000.00, 52000.00),
-- Invoice 48: Silver Pooja Thali x1
(48, 48, 1, 185000.00, 185000.00),
-- Invoice 49: Diamond Solitaire x1
(49, 49, 1, 550000.00, 550000.00),
-- Invoice 50: Gold Baby Bracelet x1
(50, 50, 1, 30000.00, 30000.00),
-- Invoice 51: Gold Ring x1 + Gold Earrings x1 = 90000
(51, 1, 1, 35000.00, 35000.00),
(51, 4, 1, 55000.00, 55000.00),
-- Invoice 52: Gold Ring x2 = 70000
(52, 1, 2, 35000.00, 70000.00),
-- Invoice 53: Diamond Ring x1 + Silver Bracelet x1 = 227000
(53, 11, 1, 185000.00, 185000.00),
(53, 3, 1, 42000.00, 42000.00),
-- Invoice 54: Gold Chain x1 + Gold Pendant x1 = 163000
(54, 7, 1, 135000.00, 135000.00),
(54, 8, 1, 28000.00, 28000.00),
-- Invoice 55: Gold Bangle Set x1 + Gold Earrings x1 = 320000
(55, 9, 1, 265000.00, 265000.00),
(55, 4, 1, 55000.00, 55000.00);


-- ── Update stock quantities to account for sold items ────────
-- (Since triggers are NOT active during seeding, we manually adjust)
-- Each product sold 1 unit in invoices 1-50, plus additional in 51-55
-- Product 1 (Gold Ring): sold in inv 1,51,52 => 1+1+2=4 sold. Stock was 25, so set to 21
UPDATE products SET stock_qty = 21 WHERE id = 1;
-- Product 2 (Diamond Necklace): sold in inv 2 => 1. Stock was 8, set to 7
UPDATE products SET stock_qty = 7 WHERE id = 2;
-- Product 3 (Silver Bracelet): sold in inv 3,53 => 2. Stock was 30, set to 28
UPDATE products SET stock_qty = 28 WHERE id = 3;
-- Product 4 (Gold Earrings): sold in inv 4,51,55 => 3. Stock was 20, set to 17
UPDATE products SET stock_qty = 17 WHERE id = 4;
-- Product 5: sold 1. Stock 5->4
UPDATE products SET stock_qty = 4 WHERE id = 5;
-- Products 6-10: sold 1 each
UPDATE products SET stock_qty = 14 WHERE id = 6;
UPDATE products SET stock_qty = 10 WHERE id = 7;  -- Also sold in inv 54
UPDATE products SET stock_qty = 1 WHERE id = 8;   -- Was 3, sold in inv 8,54 = 2
UPDATE products SET stock_qty = 8 WHERE id = 9;   -- Was 10, sold in inv 9,55 = 2
UPDATE products SET stock_qty = 1 WHERE id = 10;  -- Was 2, sold 1
-- Products 11-50: sold 1 each (except 11 sold in inv 11,53 = 2)
UPDATE products SET stock_qty = 12 WHERE id = 11;  -- Was 14, sold 2
UPDATE products SET stock_qty = 6 WHERE id = 12;
UPDATE products SET stock_qty = 3 WHERE id = 13;
UPDATE products SET stock_qty = 8 WHERE id = 14;
UPDATE products SET stock_qty = 5 WHERE id = 15;
UPDATE products SET stock_qty = 34 WHERE id = 16;
UPDATE products SET stock_qty = 39 WHERE id = 17;
UPDATE products SET stock_qty = 21 WHERE id = 18;
UPDATE products SET stock_qty = 0 WHERE id = 19;  -- Was 1, sold 1 -> LOW STOCK!
UPDATE products SET stock_qty = 44 WHERE id = 20;
UPDATE products SET stock_qty = 7 WHERE id = 21;
UPDATE products SET stock_qty = 4 WHERE id = 22;
UPDATE products SET stock_qty = 1 WHERE id = 23;
UPDATE products SET stock_qty = 5 WHERE id = 24;
UPDATE products SET stock_qty = 9 WHERE id = 25;
UPDATE products SET stock_qty = 11 WHERE id = 26;
UPDATE products SET stock_qty = 7 WHERE id = 27;
UPDATE products SET stock_qty = 9 WHERE id = 28;
UPDATE products SET stock_qty = 0 WHERE id = 29;  -- Was 1, sold 1 -> OUT OF STOCK
UPDATE products SET stock_qty = 14 WHERE id = 30;
UPDATE products SET stock_qty = 6 WHERE id = 31;
UPDATE products SET stock_qty = 3 WHERE id = 32;
UPDATE products SET stock_qty = 29 WHERE id = 33;
UPDATE products SET stock_qty = 34 WHERE id = 34;
UPDATE products SET stock_qty = 10 WHERE id = 35;
UPDATE products SET stock_qty = 2 WHERE id = 36;
UPDATE products SET stock_qty = 17 WHERE id = 37;
UPDATE products SET stock_qty = 4 WHERE id = 38;
UPDATE products SET stock_qty = 49 WHERE id = 39;
UPDATE products SET stock_qty = 2 WHERE id = 40;
UPDATE products SET stock_qty = 13 WHERE id = 41;
UPDATE products SET stock_qty = 19 WHERE id = 42;
UPDATE products SET stock_qty = 24 WHERE id = 43;
UPDATE products SET stock_qty = 8 WHERE id = 44;
UPDATE products SET stock_qty = 17 WHERE id = 45;
UPDATE products SET stock_qty = 2 WHERE id = 46;
UPDATE products SET stock_qty = 11 WHERE id = 47;
UPDATE products SET stock_qty = 5 WHERE id = 48;
UPDATE products SET stock_qty = 1 WHERE id = 49;
UPDATE products SET stock_qty = 19 WHERE id = 50;


-- ── Update loyalty points for customers who purchased ────────
-- 1 point per Rs.1000 of grand_total
UPDATE customers SET loyalty_points = FLOOR(36050/1000) + FLOOR(92700/1000) WHERE id = 1;     -- inv 1 + 51
UPDATE customers SET loyalty_points = FLOOR(1174200/1000) + FLOOR(329600/1000) WHERE id = 2;  -- inv 2 + 55
UPDATE customers SET loyalty_points = FLOOR(43260/1000) + FLOOR(70658/1000) WHERE id = 3;     -- inv 3 + 52
UPDATE customers SET loyalty_points = FLOOR(55517/1000) WHERE id = 4;
UPDATE customers SET loyalty_points = FLOOR(1523627.50/1000) + FLOOR(233810/1000) WHERE id = 5;
UPDATE customers SET loyalty_points = FLOOR(97850/1000) WHERE id = 6;
UPDATE customers SET loyalty_points = FLOOR(132097.50/1000) + FLOOR(159495.50/1000) WHERE id = 7;
UPDATE customers SET loyalty_points = FLOOR(28840/1000) WHERE id = 8;
UPDATE customers SET loyalty_points = FLOOR(267591/1000) WHERE id = 9;
UPDATE customers SET loyalty_points = FLOOR(8755/1000) WHERE id = 10;
UPDATE customers SET loyalty_points = FLOOR(190550/1000) WHERE id = 11;
UPDATE customers SET loyalty_points = FLOOR(244779.50/1000) WHERE id = 12;
UPDATE customers SET loyalty_points = FLOOR(391400/1000) WHERE id = 13;
UPDATE customers SET loyalty_points = FLOOR(151667.50/1000) WHERE id = 14;
UPDATE customers SET loyalty_points = FLOOR(231750/1000) WHERE id = 15;
UPDATE customers SET loyalty_points = FLOOR(32960/1000) WHERE id = 16;
UPDATE customers SET loyalty_points = FLOOR(5665/1000) WHERE id = 17;
UPDATE customers SET loyalty_points = FLOOR(39140/1000) WHERE id = 18;
UPDATE customers SET loyalty_points = FLOOR(75705/1000) WHERE id = 19;
UPDATE customers SET loyalty_points = FLOOR(4326/1000) WHERE id = 20;
UPDATE customers SET loyalty_points = FLOOR(66950/1000) WHERE id = 21;
UPDATE customers SET loyalty_points = FLOOR(128750/1000) WHERE id = 22;
UPDATE customers SET loyalty_points = FLOOR(49440/1000) WHERE id = 23;
UPDATE customers SET loyalty_points = FLOOR(97921.80/1000) WHERE id = 24;
UPDATE customers SET loyalty_points = FLOOR(39140/1000) WHERE id = 25;
UPDATE customers SET loyalty_points = FLOOR(87550/1000) WHERE id = 26;
UPDATE customers SET loyalty_points = FLOOR(128750/1000) WHERE id = 27;
UPDATE customers SET loyalty_points = FLOOR(95893/1000) WHERE id = 28;
UPDATE customers SET loyalty_points = FLOOR(149350/1000) WHERE id = 29;
UPDATE customers SET loyalty_points = FLOOR(56650/1000) WHERE id = 30;
UPDATE customers SET loyalty_points = FLOOR(190807.50/1000) WHERE id = 31;
UPDATE customers SET loyalty_points = FLOOR(319300/1000) WHERE id = 32;
UPDATE customers SET loyalty_points = FLOOR(18540/1000) WHERE id = 33;
UPDATE customers SET loyalty_points = FLOOR(20085/1000) WHERE id = 34;
UPDATE customers SET loyalty_points = FLOOR(80340/1000) WHERE id = 35;
UPDATE customers SET loyalty_points = FLOOR(733875/1000) WHERE id = 36;
UPDATE customers SET loyalty_points = FLOOR(22660/1000) WHERE id = 37;
UPDATE customers SET loyalty_points = FLOOR(419622/1000) WHERE id = 38;
UPDATE customers SET loyalty_points = FLOOR(3914/1000) WHERE id = 39;
UPDATE customers SET loyalty_points = FLOOR(128750/1000) WHERE id = 40;
UPDATE customers SET loyalty_points = FLOOR(36050/1000) WHERE id = 41;
UPDATE customers SET loyalty_points = FLOOR(28840/1000) WHERE id = 42;
UPDATE customers SET loyalty_points = FLOOR(18540/1000) WHERE id = 43;
UPDATE customers SET loyalty_points = FLOOR(43260/1000) WHERE id = 44;
UPDATE customers SET loyalty_points = FLOOR(15450/1000) WHERE id = 45;
UPDATE customers SET loyalty_points = FLOOR(474572.50/1000) WHERE id = 46;
UPDATE customers SET loyalty_points = FLOOR(53560/1000) WHERE id = 47;
UPDATE customers SET loyalty_points = FLOOR(190550/1000) WHERE id = 48;
UPDATE customers SET loyalty_points = FLOOR(549505/1000) WHERE id = 49;
UPDATE customers SET loyalty_points = FLOOR(30900/1000) WHERE id = 50;
