-- MySQL dump 10.13  Distrib 9.5.0, for macos15 (arm64)
--
-- Host: localhost    Database: vijayraj_jewellery
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'c0b8a91c-b833-11f1-9988-ea60228847c9:1-395';

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `loyalty_points` int NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_code` (`customer_code`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_customers_city` (`city`),
  KEY `idx_customers_name` (`name`),
  CONSTRAINT `customers_chk_1` CHECK ((`loyalty_points` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'C01','Disha Sherigar','9876543210','disha.sherigar@gmail.com','Flat 12, Koregaon Park','Pune',164,'2024-01-15 10:30:00'),(2,'C02','Archita Shelar','9876000112','archita.shelar@gmail.com','45, FC Road','Pune',1503,'2024-01-20 11:00:00'),(3,'C03','Atharva Tikone','9123456789','atharva.tikone@gmail.com','B-201, Hinjewadi Phase 2','Pune',113,'2024-02-05 09:45:00'),(4,'C04','Ramesh Patil','9823456701','ramesh.patil@yahoo.com','78, MG Road','Pune',55,'2024-02-10 14:20:00'),(5,'C05','Sunita Deshmukh','9823456702','sunita.d@gmail.com','12, Karve Nagar','Pune',1756,'2024-02-15 16:00:00'),(6,'C06','Prakash Joshi','9823456703','prakash.j@gmail.com','A-5, Andheri West','Mumbai',97,'2024-02-20 10:00:00'),(7,'C07','Meera Kulkarni','9823456704','meera.k@gmail.com','34, Bandra East','Mumbai',291,'2024-03-01 11:30:00'),(8,'C08','Sunil Gaikwad','9823456705','sunil.g@hotmail.com','56, Dadar West','Mumbai',28,'2024-03-05 13:45:00'),(9,'C09','Kavita Bhosale','9823456706','kavita.b@gmail.com','89, Peth Road','Nashik',267,'2024-03-10 09:15:00'),(10,'C10','Nitin Sawant','9823456707','nitin.s@gmail.com','23, Civil Lines','Nagpur',8,'2024-03-15 15:30:00'),(11,'C11','Anjali Thakur','9823456708','anjali.t@gmail.com','67, Shivaji Nagar','Pune',962,'2024-03-20 10:45:00'),(12,'C12','Vikram Pawar','9823456709','vikram.p@gmail.com','45, Camp Area','Pune',244,'2024-03-25 12:00:00'),(13,'C13','Pooja Wagh','9823456710','pooja.w@gmail.com','12, Aundh','Pune',391,'2024-04-01 14:30:00'),(14,'C14','Deepak Chavan','9823456711','deepak.c@gmail.com','78, Viman Nagar','Pune',151,'2024-04-05 09:00:00'),(15,'C15','Rashmi Iyer','9823456712','rashmi.i@gmail.com','34, Powai','Mumbai',231,'2024-04-10 11:15:00'),(16,'C16','Manoj Kale','9823456713','manoj.k@gmail.com','56, Borivali West','Mumbai',32,'2024-04-15 13:00:00'),(17,'C17','Rekha Mane','9823456714','rekha.m@gmail.com','89, Gangapur Road','Nashik',5,'2024-04-20 15:45:00'),(18,'C18','Ganesh Sonawane','9823456715','ganesh.s@gmail.com','23, Dharampeth','Nagpur',39,'2024-04-25 10:30:00'),(19,'C19','Nisha Phadke','9823456716','nisha.p@gmail.com','67, SB Road','Pune',75,'2024-05-01 12:15:00'),(20,'C20','Sachin Deshpande','9823456717','sachin.d@gmail.com','45, Kothrud','Pune',4,'2024-05-05 14:00:00'),(21,'C21','Manisha Gokhale','9823456718','manisha.g@gmail.com','12, Deccan','Pune',66,'2024-05-10 09:30:00'),(22,'C22','Ashwin Desai','9823456719','ashwin.d@gmail.com','78, Juhu','Mumbai',128,'2024-05-15 11:45:00'),(23,'C23','Lata Nimbalkar','9823456720','lata.n@gmail.com','34, Thane West','Mumbai',49,'2024-05-20 13:30:00'),(24,'C24','Dinesh Raut','9823456721','dinesh.r@gmail.com','56, College Road','Nashik',97,'2024-05-25 15:00:00'),(25,'C25','Ritu Patel','9823456722','ritu.p@gmail.com','89, Sadar','Nagpur',39,'2024-06-01 10:00:00'),(26,'C26','Hemant Thorat','9823456723','hemant.t@gmail.com','23, Wakad','Pune',87,'2024-06-05 12:30:00'),(27,'C27','Smita Naik','9823456724','smita.n@gmail.com','67, Pimple Saudagar','Pune',128,'2024-06-10 14:15:00'),(28,'C28','Pramod Khaire','9823456725','pramod.k@gmail.com','45, Worli','Mumbai',95,'2024-06-15 09:45:00'),(29,'C29','Vandana Shirke','9823456726','vandana.s@gmail.com','12, Malad East','Mumbai',149,'2024-06-20 11:00:00'),(30,'C30','Arun Phule','9823456727','arun.p@gmail.com','78, Satpur','Nashik',56,'2024-06-25 13:15:00'),(31,'C31','Geeta Salvi','9823456728','geeta.s@gmail.com','34, Ramdaspeth','Nagpur',190,'2024-07-01 15:30:00'),(32,'C32','Milind Bagwe','9823456729','milind.b@gmail.com','56, Hadapsar','Pune',319,'2024-07-05 10:15:00'),(33,'C33','Jyoti Khot','9823456730','jyoti.k@gmail.com','89, Magarpatta','Pune',18,'2024-07-10 12:00:00'),(34,'C34','Nilesh Satpute','9823456731','nilesh.s@gmail.com','23, Versova','Mumbai',20,'2024-07-15 14:45:00'),(35,'C35','Aparna Datar','9823456732','aparna.d@gmail.com','67, Goregaon East','Mumbai',80,'2024-07-20 09:00:00'),(36,'C36','Rahul Ghosh','9823456733','rahul.g@gmail.com','45, Ambad','Nashik',733,'2024-07-25 11:30:00'),(37,'C37','Shubhangi Bhise','9823456734','shubhangi.b@gmail.com','12, Manewada','Nagpur',22,'2024-08-01 13:00:00'),(38,'C38','Omkar Londhe','9823456735','omkar.l@gmail.com','78, Baner','Pune',419,'2024-08-05 15:15:00'),(39,'C39','Chitra Karpe','9823456736','chitra.k@gmail.com','34, Pashan','Pune',3,'2024-08-10 10:30:00'),(40,'C40','Sameer Jagtap','9823456737','sameer.j@gmail.com','56, Santacruz West','Mumbai',128,'2024-08-15 12:45:00'),(41,'C41','Pranjali Mahajan','9823456738','pranjali.m@gmail.com','89, Chembur','Mumbai',36,'2024-08-20 14:00:00'),(42,'C42','Tanmay Kulkarni','9823456739','tanmay.k@gmail.com','23, Trimbak Road','Nashik',28,'2024-08-25 09:15:00'),(43,'C43','Sarika Dhage','9823456740','sarika.d@gmail.com','67, Gandhibagh','Nagpur',18,'2024-09-01 11:00:00'),(44,'C44','Abhijit Mhatre','9823456741','abhijit.m@gmail.com','45, Chinchwad','Pune',43,'2024-09-05 13:30:00'),(45,'C45','Revati Godbole','9823456742','revati.g@gmail.com','12, Pimpri','Pune',15,'2024-09-10 15:00:00'),(46,'C46','Tushar Mhaske','9823456743','tushar.m@gmail.com','78, Mulund West','Mumbai',474,'2024-09-15 10:45:00'),(47,'C47','Sonal Khanvilkar','9823456744','sonal.k@gmail.com','34, Dombivli East','Mumbai',53,'2024-09-20 12:30:00'),(48,'C48','Vishal Tawde','9823456745','vishal.t@gmail.com','56, Panchavati','Nashik',190,'2024-09-25 14:15:00'),(49,'C49','Madhuri Lele','9823456746','madhuri.l@gmail.com','89, Sitabuldi','Nagpur',549,'2024-10-01 09:30:00'),(50,'C50','Kiran Bapat','9823456747','kiran.b@gmail.com','23, Shaniwar Wada Road','Pune',30,'2024-10-05 11:45:00'),(51,'C51','Vikramaditya Oberoi','9999888877','vikram@oberoi.com','Marine Drive, Nariman Point','Mumbai',856,'2026-09-24 22:26:43'),(52,'C52','Vikramaditya Oberoi','9990269041','vikram_9990269041@oberoi.com','Marine Drive, Nariman Point','Mumbai',846,'2026-09-24 22:27:21'),(53,'C53','Vikramaditya Oberoi','9990270178','vikram_9990270178@oberoi.com','Marine Drive, Nariman Point','Mumbai',675,'2026-09-24 22:46:18'),(54,'C54','Disha','1234567890','Disha@gmail.com','abcbcbcb','Pune',6180,'2026-09-24 22:51:07');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `unit_price` decimal(14,2) NOT NULL,
  `line_total` decimal(14,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_invoice_items_invoice` (`invoice_id`),
  KEY `idx_invoice_items_product` (`product_id`),
  CONSTRAINT `invoice_items_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `invoice_items_chk_1` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_items`
--

LOCK TABLES `invoice_items` WRITE;
/*!40000 ALTER TABLE `invoice_items` DISABLE KEYS */;
INSERT INTO `invoice_items` VALUES (1,1,1,1,35000.00,35000.00),(2,2,2,1,1200000.00,1200000.00),(3,3,3,1,42000.00,42000.00),(4,4,4,1,55000.00,55000.00),(5,5,5,1,1525000.00,1525000.00),(6,6,6,1,95000.00,95000.00),(7,7,7,1,135000.00,135000.00),(8,8,8,1,28000.00,28000.00),(9,9,9,1,265000.00,265000.00),(10,10,10,1,8500.00,8500.00),(11,11,11,1,185000.00,185000.00),(12,12,12,1,245000.00,245000.00),(13,13,13,1,380000.00,380000.00),(14,14,14,1,155000.00,155000.00),(15,15,15,1,225000.00,225000.00),(16,16,16,1,32000.00,32000.00),(17,17,17,1,5500.00,5500.00),(18,18,18,1,38000.00,38000.00),(19,19,19,1,75000.00,75000.00),(20,20,20,1,4200.00,4200.00),(21,21,21,1,65000.00,65000.00),(22,22,22,1,125000.00,125000.00),(23,23,23,1,48000.00,48000.00),(24,24,24,1,98000.00,98000.00),(25,25,25,1,38000.00,38000.00),(26,26,26,1,85000.00,85000.00),(27,27,27,1,125000.00,125000.00),(28,28,28,1,95000.00,95000.00),(29,29,29,1,145000.00,145000.00),(30,30,30,1,55000.00,55000.00),(31,31,31,1,195000.00,195000.00),(32,32,32,1,310000.00,310000.00),(33,33,33,1,18000.00,18000.00),(34,34,34,1,19500.00,19500.00),(35,35,35,1,78000.00,78000.00),(36,36,36,1,750000.00,750000.00),(37,37,37,1,22000.00,22000.00),(38,38,38,1,420000.00,420000.00),(39,39,39,1,3800.00,3800.00),(40,40,40,1,125000.00,125000.00),(41,41,41,1,35000.00,35000.00),(42,42,42,1,28000.00,28000.00),(43,43,43,1,18000.00,18000.00),(44,44,44,1,42000.00,42000.00),(45,45,45,1,15000.00,15000.00),(46,46,46,1,485000.00,485000.00),(47,47,47,1,52000.00,52000.00),(48,48,48,1,185000.00,185000.00),(49,49,49,1,550000.00,550000.00),(50,50,50,1,30000.00,30000.00),(51,51,1,1,35000.00,35000.00),(52,51,4,1,55000.00,55000.00),(53,52,1,2,35000.00,70000.00),(54,53,11,1,185000.00,185000.00),(55,53,3,1,42000.00,42000.00),(56,54,7,1,135000.00,135000.00),(57,54,8,1,28000.00,28000.00),(58,55,9,1,265000.00,265000.00),(59,55,4,1,55000.00,55000.00),(60,56,1,1,35000.00,35000.00),(61,57,36,1,750000.00,750000.00),(62,57,40,1,125000.00,125000.00),(63,58,46,1,485000.00,485000.00),(64,58,13,1,380000.00,380000.00),(65,59,13,1,380000.00,380000.00),(66,59,32,1,310000.00,310000.00),(67,60,36,1,750000.00,750000.00),(68,61,2,5,1200000.00,6000000.00);
/*!40000 ALTER TABLE `invoice_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_insert_invoice_items` AFTER INSERT ON `invoice_items` FOR EACH ROW BEGIN
  UPDATE products
  SET stock_qty = stock_qty - NEW.quantity
  WHERE id = NEW.product_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `invoice_no` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int NOT NULL,
  `user_id` int NOT NULL,
  `invoice_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `subtotal` decimal(14,2) NOT NULL DEFAULT '0.00',
  `discount_percent` decimal(5,2) NOT NULL DEFAULT '0.00',
  `gst_percent` decimal(5,2) NOT NULL DEFAULT '3.00',
  `gst_amount` decimal(14,2) NOT NULL DEFAULT '0.00',
  `grand_total` decimal(14,2) NOT NULL DEFAULT '0.00',
  `payment_mode` enum('Cash','Card','UPI') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Cash',
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_no` (`invoice_no`),
  KEY `user_id` (`user_id`),
  KEY `idx_invoices_date` (`invoice_date`),
  KEY `idx_invoices_customer` (`customer_id`),
  CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `invoices_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `invoices_chk_1` CHECK (((`discount_percent` >= 0) and (`discount_percent` <= 100))),
  CONSTRAINT `invoices_chk_2` CHECK ((`gst_percent` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (1,'INV-20260401-0001',1,4,'2026-04-01 10:30:00',35000.00,0.00,3.00,1050.00,36050.00,'Cash'),(2,'INV-20260402-0001',2,5,'2026-04-02 11:00:00',1200000.00,5.00,3.00,34200.00,1174200.00,'Card'),(3,'INV-20260403-0001',3,4,'2026-04-03 14:20:00',42000.00,0.00,3.00,1260.00,43260.00,'UPI'),(4,'INV-20260405-0001',4,6,'2026-04-05 09:45:00',55000.00,2.00,3.00,1617.00,55517.00,'Cash'),(5,'INV-20260407-0001',5,4,'2026-04-07 16:00:00',1525000.00,3.00,3.00,44377.50,1523627.50,'Card'),(6,'INV-20260410-0001',6,5,'2026-04-10 10:00:00',95000.00,0.00,3.00,2850.00,97850.00,'Cash'),(7,'INV-20260412-0001',7,4,'2026-04-12 11:30:00',135000.00,5.00,3.00,3847.50,132097.50,'UPI'),(8,'INV-20260415-0001',8,6,'2026-04-15 13:45:00',28000.00,0.00,3.00,840.00,28840.00,'Cash'),(9,'INV-20260418-0001',9,4,'2026-04-18 09:15:00',265000.00,2.00,3.00,7791.00,267591.00,'Card'),(10,'INV-20260420-0001',10,5,'2026-04-20 15:30:00',8500.00,0.00,3.00,255.00,8755.00,'UPI'),(11,'INV-20260422-0001',11,4,'2026-04-22 10:45:00',185000.00,0.00,3.00,5550.00,190550.00,'Cash'),(12,'INV-20260425-0001',12,6,'2026-04-25 12:00:00',245000.00,3.00,3.00,7129.50,244779.50,'Card'),(13,'INV-20260428-0001',13,4,'2026-04-28 14:30:00',380000.00,0.00,3.00,11400.00,391400.00,'Cash'),(14,'INV-20260501-0001',14,5,'2026-05-01 09:00:00',155000.00,5.00,3.00,4417.50,151667.50,'UPI'),(15,'INV-20260503-0001',15,4,'2026-05-03 11:15:00',225000.00,0.00,3.00,6750.00,231750.00,'Cash'),(16,'INV-20260506-0001',16,6,'2026-05-06 13:00:00',32000.00,0.00,3.00,960.00,32960.00,'Card'),(17,'INV-20260508-0001',17,4,'2026-05-08 15:45:00',5500.00,0.00,3.00,165.00,5665.00,'UPI'),(18,'INV-20260510-0001',18,5,'2026-05-10 10:30:00',38000.00,0.00,3.00,1140.00,39140.00,'Cash'),(19,'INV-20260513-0001',19,4,'2026-05-13 12:15:00',75000.00,2.00,3.00,2205.00,75705.00,'Card'),(20,'INV-20260515-0001',20,6,'2026-05-15 14:00:00',4200.00,0.00,3.00,126.00,4326.00,'UPI'),(21,'INV-20260518-0001',21,4,'2026-05-18 09:30:00',65000.00,0.00,3.00,1950.00,66950.00,'Cash'),(22,'INV-20260520-0001',22,5,'2026-05-20 11:45:00',125000.00,0.00,3.00,3750.00,128750.00,'Card'),(23,'INV-20260523-0001',23,4,'2026-05-23 13:30:00',48000.00,0.00,3.00,1440.00,49440.00,'UPI'),(24,'INV-20260525-0001',24,6,'2026-05-25 15:00:00',98000.00,3.00,3.00,2851.80,97921.80,'Cash'),(25,'INV-20260528-0001',25,4,'2026-05-28 10:00:00',38000.00,0.00,3.00,1140.00,39140.00,'Card'),(26,'INV-20260601-0001',26,5,'2026-06-01 12:30:00',85000.00,0.00,3.00,2550.00,87550.00,'UPI'),(27,'INV-20260603-0001',27,4,'2026-06-03 14:15:00',125000.00,0.00,3.00,3750.00,128750.00,'Cash'),(28,'INV-20260606-0001',28,6,'2026-06-06 09:45:00',95000.00,2.00,3.00,2793.00,95893.00,'Card'),(29,'INV-20260608-0001',29,4,'2026-06-08 11:00:00',145000.00,0.00,3.00,4350.00,149350.00,'UPI'),(30,'INV-20260611-0001',30,5,'2026-06-11 13:15:00',55000.00,0.00,3.00,1650.00,56650.00,'Cash'),(31,'INV-20260613-0001',31,4,'2026-06-13 15:30:00',195000.00,5.00,3.00,5557.50,190807.50,'Card'),(32,'INV-20260616-0001',32,6,'2026-06-16 10:15:00',310000.00,0.00,3.00,9300.00,319300.00,'Cash'),(33,'INV-20260618-0001',33,4,'2026-06-18 12:00:00',18000.00,0.00,3.00,540.00,18540.00,'UPI'),(34,'INV-20260621-0001',34,5,'2026-06-21 14:45:00',19500.00,0.00,3.00,585.00,20085.00,'Cash'),(35,'INV-20260623-0001',35,4,'2026-06-23 09:00:00',78000.00,0.00,3.00,2340.00,80340.00,'Card'),(36,'INV-20260626-0001',36,6,'2026-06-26 11:30:00',750000.00,5.00,3.00,21375.00,733875.00,'UPI'),(37,'INV-20260628-0001',37,4,'2026-06-28 13:00:00',22000.00,0.00,3.00,660.00,22660.00,'Cash'),(38,'INV-20260701-0001',38,5,'2026-07-01 15:15:00',420000.00,3.00,3.00,12222.00,419622.00,'Card'),(39,'INV-20260703-0001',39,4,'2026-07-03 10:30:00',3800.00,0.00,3.00,114.00,3914.00,'UPI'),(40,'INV-20260706-0001',40,6,'2026-07-06 12:45:00',125000.00,0.00,3.00,3750.00,128750.00,'Cash'),(41,'INV-20260708-0001',41,4,'2026-07-08 14:00:00',35000.00,0.00,3.00,1050.00,36050.00,'Card'),(42,'INV-20260711-0001',42,5,'2026-07-11 09:15:00',28000.00,0.00,3.00,840.00,28840.00,'UPI'),(43,'INV-20260713-0001',43,4,'2026-07-13 11:00:00',18000.00,0.00,3.00,540.00,18540.00,'Cash'),(44,'INV-20260716-0001',44,6,'2026-07-16 13:30:00',42000.00,0.00,3.00,1260.00,43260.00,'Card'),(45,'INV-20260718-0001',45,4,'2026-07-18 15:00:00',15000.00,0.00,3.00,450.00,15450.00,'UPI'),(46,'INV-20260721-0001',46,5,'2026-07-21 10:45:00',485000.00,5.00,3.00,13822.50,474572.50,'Cash'),(47,'INV-20260723-0001',47,4,'2026-07-23 12:30:00',52000.00,0.00,3.00,1560.00,53560.00,'Card'),(48,'INV-20260726-0001',48,6,'2026-07-26 14:15:00',185000.00,0.00,3.00,5550.00,190550.00,'UPI'),(49,'INV-20260728-0001',49,4,'2026-07-28 09:30:00',550000.00,3.00,3.00,16005.00,549505.00,'Cash'),(50,'INV-20260801-0001',50,5,'2026-08-01 11:45:00',30000.00,0.00,3.00,900.00,30900.00,'Card'),(51,'INV-20260905-0001',1,4,'2026-09-05 10:00:00',90000.00,0.00,3.00,2700.00,92700.00,'Cash'),(52,'INV-20260910-0001',3,5,'2026-09-10 14:30:00',70000.00,2.00,3.00,2058.00,70658.00,'UPI'),(53,'INV-20260915-0001',5,4,'2026-09-15 11:00:00',227000.00,0.00,3.00,6810.00,233810.00,'Card'),(54,'INV-20260920-0001',7,6,'2026-09-20 16:00:00',163000.00,5.00,3.00,4645.50,159495.50,'Cash'),(55,'INV-20260924-0001',2,4,'2026-09-24 09:00:00',320000.00,0.00,3.00,9600.00,329600.00,'Card'),(56,'INV-20260924-3295',1,1,'2026-09-24 21:53:13',35000.00,0.00,3.00,1050.00,36050.00,'Cash'),(57,'INV-20260924-1260',51,1,'2026-09-24 22:26:43',875000.00,5.00,3.00,24937.50,856187.50,'Card'),(58,'INV-20260924-1979',52,1,'2026-09-24 22:27:21',865000.00,5.00,3.00,24652.50,846402.50,'Card'),(59,'INV-20260924-2954',53,1,'2026-09-24 22:46:18',690000.00,5.00,3.00,19665.00,675165.00,'Card'),(60,'INV-20260924-7487',11,2,'2026-09-24 22:49:40',750000.00,0.00,3.00,22500.00,772500.00,'Cash'),(61,'INV-20260924-3327',54,1,'2026-09-24 22:51:41',6000000.00,0.00,3.00,180000.00,6180000.00,'Cash');
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_insert_invoices` AFTER INSERT ON `invoices` FOR EACH ROW BEGIN
  UPDATE customers
  SET loyalty_points = loyalty_points + FLOOR(NEW.grand_total / 1000)
  WHERE id = NEW.customer_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `metal_rates`
--

DROP TABLE IF EXISTS `metal_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metal_rates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rate_date` date NOT NULL,
  `metal` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rate_per_gram` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_metal_date` (`rate_date`,`metal`),
  KEY `idx_metal_rates_date` (`rate_date`),
  CONSTRAINT `metal_rates_chk_1` CHECK ((`rate_per_gram` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metal_rates`
--

LOCK TABLES `metal_rates` WRITE;
/*!40000 ALTER TABLE `metal_rates` DISABLE KEYS */;
INSERT INTO `metal_rates` VALUES (1,'2026-03-28','Gold 24K',7250.00),(2,'2026-03-28','Gold 22K',6645.00),(3,'2026-03-28','Silver',92.50),(4,'2026-03-28','Platinum',3150.00),(5,'2026-03-29','Gold 24K',7280.00),(6,'2026-03-29','Gold 22K',6673.00),(7,'2026-03-29','Silver',93.00),(8,'2026-03-29','Platinum',3170.00),(9,'2026-03-30','Gold 24K',7310.00),(10,'2026-03-30','Gold 22K',6700.00),(11,'2026-03-30','Silver',92.80),(12,'2026-03-30','Platinum',3160.00),(13,'2026-03-31','Gold 24K',7295.00),(14,'2026-03-31','Gold 22K',6686.00),(15,'2026-03-31','Silver',93.20),(16,'2026-03-31','Platinum',3180.00),(17,'2026-04-01','Gold 24K',7320.00),(18,'2026-04-01','Gold 22K',6710.00),(19,'2026-04-01','Silver',93.50),(20,'2026-04-01','Platinum',3200.00),(21,'2026-04-05','Gold 24K',7350.00),(22,'2026-04-05','Gold 22K',6738.00),(23,'2026-04-05','Silver',94.00),(24,'2026-04-05','Platinum',3220.00),(25,'2026-04-10','Gold 24K',7380.00),(26,'2026-04-10','Gold 22K',6765.00),(27,'2026-04-10','Silver',93.80),(28,'2026-04-10','Platinum',3210.00),(29,'2026-04-15','Gold 24K',7400.00),(30,'2026-04-15','Gold 22K',6783.00),(31,'2026-04-15','Silver',94.50),(32,'2026-04-15','Platinum',3240.00),(33,'2026-04-20','Gold 24K',7370.00),(34,'2026-04-20','Gold 22K',6756.00),(35,'2026-04-20','Silver',94.20),(36,'2026-04-20','Platinum',3230.00),(37,'2026-04-25','Gold 24K',7420.00),(38,'2026-04-25','Gold 22K',6801.00),(39,'2026-04-25','Silver',95.00),(40,'2026-04-25','Platinum',3250.00),(41,'2026-04-30','Gold 24K',7450.00),(42,'2026-04-30','Gold 22K',6828.00),(43,'2026-04-30','Silver',95.50),(44,'2026-04-30','Platinum',3270.00),(45,'2026-05-05','Gold 24K',7480.00),(46,'2026-05-05','Gold 22K',6856.00),(47,'2026-05-05','Silver',96.00),(48,'2026-05-05','Platinum',3290.00),(49,'2026-05-10','Gold 24K',7510.00),(50,'2026-05-10','Gold 22K',6883.00),(51,'2026-05-10','Silver',95.80),(52,'2026-05-10','Platinum',3280.00),(53,'2026-05-15','Gold 24K',7530.00),(54,'2026-05-15','Gold 22K',6901.00),(55,'2026-05-15','Silver',96.50),(56,'2026-05-15','Platinum',3310.00),(57,'2026-05-20','Gold 24K',7500.00),(58,'2026-05-20','Gold 22K',6875.00),(59,'2026-05-20','Silver',96.20),(60,'2026-05-20','Platinum',3300.00),(61,'2026-05-25','Gold 24K',7550.00),(62,'2026-05-25','Gold 22K',6920.00),(63,'2026-05-25','Silver',97.00),(64,'2026-05-25','Platinum',3320.00),(65,'2026-05-31','Gold 24K',7580.00),(66,'2026-05-31','Gold 22K',6947.00),(67,'2026-05-31','Silver',97.50),(68,'2026-05-31','Platinum',3340.00),(69,'2026-06-05','Gold 24K',7600.00),(70,'2026-06-05','Gold 22K',6966.00),(71,'2026-06-05','Silver',98.00),(72,'2026-06-05','Platinum',3360.00),(73,'2026-06-10','Gold 24K',7630.00),(74,'2026-06-10','Gold 22K',6993.00),(75,'2026-06-10','Silver',97.80),(76,'2026-06-10','Platinum',3350.00),(77,'2026-06-15','Gold 24K',7650.00),(78,'2026-06-15','Gold 22K',7011.00),(79,'2026-06-15','Silver',98.50),(80,'2026-06-15','Platinum',3380.00),(81,'2026-06-20','Gold 24K',7620.00),(82,'2026-06-20','Gold 22K',6984.00),(83,'2026-06-20','Silver',98.20),(84,'2026-06-20','Platinum',3370.00),(85,'2026-06-25','Gold 24K',7680.00),(86,'2026-06-25','Gold 22K',7039.00),(87,'2026-06-25','Silver',99.00),(88,'2026-06-25','Platinum',3400.00),(89,'2026-06-30','Gold 24K',7700.00),(90,'2026-06-30','Gold 22K',7057.00),(91,'2026-06-30','Silver',99.50),(92,'2026-06-30','Platinum',3420.00),(93,'2026-07-05','Gold 24K',7720.00),(94,'2026-07-05','Gold 22K',7075.00),(95,'2026-07-05','Silver',100.00),(96,'2026-07-05','Platinum',3440.00),(97,'2026-07-10','Gold 24K',7750.00),(98,'2026-07-10','Gold 22K',7103.00),(99,'2026-07-10','Silver',99.80),(100,'2026-07-10','Platinum',3430.00),(101,'2026-07-15','Gold 24K',7780.00),(102,'2026-07-15','Gold 22K',7130.00),(103,'2026-07-15','Silver',100.50),(104,'2026-07-15','Platinum',3460.00),(105,'2026-07-20','Gold 24K',7800.00),(106,'2026-07-20','Gold 22K',7148.00),(107,'2026-07-20','Silver',101.00),(108,'2026-07-20','Platinum',3480.00),(109,'2026-07-25','Gold 24K',7830.00),(110,'2026-07-25','Gold 22K',7176.00),(111,'2026-07-25','Silver',100.80),(112,'2026-07-25','Platinum',3470.00),(113,'2026-07-31','Gold 24K',7850.00),(114,'2026-07-31','Gold 22K',7194.00),(115,'2026-07-31','Silver',101.50),(116,'2026-07-31','Platinum',3500.00),(117,'2026-08-05','Gold 24K',7880.00),(118,'2026-08-05','Gold 22K',7221.00),(119,'2026-08-05','Silver',102.00),(120,'2026-08-05','Platinum',3520.00),(121,'2026-08-10','Gold 24K',7900.00),(122,'2026-08-10','Gold 22K',7240.00),(123,'2026-08-10','Silver',101.80),(124,'2026-08-10','Platinum',3510.00),(125,'2026-08-15','Gold 24K',7920.00),(126,'2026-08-15','Gold 22K',7258.00),(127,'2026-08-15','Silver',102.50),(128,'2026-08-15','Platinum',3540.00),(129,'2026-08-20','Gold 24K',7950.00),(130,'2026-08-20','Gold 22K',7286.00),(131,'2026-08-20','Silver',103.00),(132,'2026-08-20','Platinum',3560.00),(133,'2026-08-25','Gold 24K',7980.00),(134,'2026-08-25','Gold 22K',7313.00),(135,'2026-08-25','Silver',102.80),(136,'2026-08-25','Platinum',3550.00),(137,'2026-08-31','Gold 24K',8000.00),(138,'2026-08-31','Gold 22K',7333.00),(139,'2026-08-31','Silver',103.50),(140,'2026-08-31','Platinum',3580.00),(141,'2026-09-05','Gold 24K',8020.00),(142,'2026-09-05','Gold 22K',7351.00),(143,'2026-09-05','Silver',104.00),(144,'2026-09-05','Platinum',3600.00),(145,'2026-09-10','Gold 24K',8050.00),(146,'2026-09-10','Gold 22K',7379.00),(147,'2026-09-10','Silver',103.80),(148,'2026-09-10','Platinum',3590.00),(149,'2026-09-15','Gold 24K',8080.00),(150,'2026-09-15','Gold 22K',7406.00),(151,'2026-09-15','Silver',104.50),(152,'2026-09-15','Platinum',3620.00),(153,'2026-09-20','Gold 24K',8100.00),(154,'2026-09-20','Gold 22K',7425.00),(155,'2026-09-20','Silver',105.00),(156,'2026-09-20','Platinum',3640.00),(157,'2026-09-24','Gold 24K',8120.00),(158,'2026-09-24','Gold 22K',7443.00),(159,'2026-09-24','Silver',104.80),(160,'2026-09-24','Platinum',3630.00);
/*!40000 ALTER TABLE `metal_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` enum('Gold','Silver','Diamond','Platinum','Gems') COLLATE utf8mb4_unicode_ci NOT NULL,
  `purity` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight_grams` decimal(10,3) DEFAULT '0.000',
  `making_charge` decimal(12,2) DEFAULT '0.00',
  `price` decimal(14,2) NOT NULL,
  `stock_qty` int NOT NULL DEFAULT '0',
  `reorder_level` int NOT NULL DEFAULT '5',
  `design_code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_code` (`product_code`),
  KEY `idx_products_category` (`category`),
  KEY `idx_products_stock` (`stock_qty`),
  CONSTRAINT `products_chk_1` CHECK ((`price` >= 0)),
  CONSTRAINT `products_chk_2` CHECK ((`stock_qty` >= 0)),
  CONSTRAINT `products_chk_3` CHECK ((`reorder_level` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'P101','Gold Ring','Gold','22K',8.500,3500.00,35000.00,20,5,'GR-001','Classic 22K gold ring with traditional design'),(2,'P102','Diamond Necklace','Diamond','VVS1',45.000,150000.00,1200000.00,2,3,'DN-001','Premium VVS1 diamond necklace with 18K gold chain'),(3,'P103','Silver Bracelet','Silver','925',35.000,5000.00,42000.00,28,5,'SB-001','925 sterling silver bracelet with intricate carving'),(4,'P104','Gold Earrings','Gold','22K',12.000,5500.00,55000.00,17,5,'GE-001','Traditional 22K gold jhumka earrings'),(5,'P105','Gemstone Collection','Gems','Natural',0.000,0.00,1525000.00,4,2,'GC-001','Yellow sapphire, blue sapphire, rashi stones collection'),(6,'P106','Gold Mangalsutra','Gold','22K',18.000,8000.00,95000.00,14,5,'GM-001','Traditional 22K gold mangalsutra with black beads'),(7,'P107','Gold Chain (Men)','Gold','22K',25.000,6000.00,135000.00,10,5,'GC-002','Thick 22K gold chain for men'),(8,'P108','Gold Pendant','Gold','18K',5.500,2500.00,28000.00,1,5,'GP-001','18K gold pendant with Ganesh design'),(9,'P109','Gold Bangle (Set of 4)','Gold','22K',48.000,12000.00,265000.00,8,5,'GB-001','Set of 4 matching 22K gold bangles'),(10,'P110','Gold Nose Pin','Gold','22K',1.200,800.00,8500.00,1,5,'GN-001','Delicate 22K gold nose pin with tiny diamond'),(11,'P111','Diamond Ring','Diamond','VS2',6.000,25000.00,185000.00,12,5,'DR-001','Solitaire VS2 diamond ring in 18K white gold'),(12,'P112','Diamond Earrings','Diamond','VVS2',8.500,35000.00,245000.00,6,3,'DE-001','VVS2 diamond stud earrings in platinum setting'),(13,'P113','Diamond Bracelet','Diamond','VS1',22.000,45000.00,380000.00,1,3,'DB-001','Tennis bracelet with VS1 diamonds in 18K gold'),(14,'P114','Diamond Pendant','Diamond','VVS1',4.000,18000.00,155000.00,8,5,'DP-001','Heart-shaped VVS1 diamond pendant'),(15,'P115','Diamond Mangalsutra','Diamond','VS2',15.000,28000.00,225000.00,5,3,'DM-001','Modern diamond mangalsutra with gold chain'),(16,'P116','Silver Chain','Silver','925',40.000,3500.00,32000.00,34,5,'SC-001','925 silver chain with lobster clasp'),(17,'P117','Silver Ring','Silver','925',8.000,1200.00,5500.00,39,5,'SR-001','Sterling silver ring with oxidized finish'),(18,'P118','Silver Anklet (Pair)','Silver','925',50.000,4000.00,38000.00,21,5,'SA-001','Pair of silver anklets with ghungroo'),(19,'P119','Silver Bangle (Set 6)','Silver','925',120.000,8000.00,75000.00,0,5,'SBG-001','Set of 6 sterling silver bangles'),(20,'P120','Silver Earrings','Silver','925',6.000,900.00,4200.00,44,5,'SE-001','Silver jhumka earrings with mirror work'),(21,'P121','Platinum Ring (Men)','Platinum','950',10.000,8000.00,65000.00,7,3,'PR-001','950 platinum band ring for men'),(22,'P122','Platinum Chain','Platinum','950',20.000,12000.00,125000.00,4,3,'PC-001','Elegant 950 platinum chain'),(23,'P123','Platinum Earrings','Platinum','950',7.000,6000.00,48000.00,1,3,'PTE-001','950 platinum stud earrings'),(24,'P124','Platinum Bracelet','Platinum','950',18.000,10000.00,98000.00,5,3,'PB-001','950 platinum bracelet with diamond accents'),(25,'P125','Platinum Pendant','Platinum','950',5.000,5000.00,38000.00,9,5,'PP-001','950 platinum pendant with sapphire stone'),(26,'P126','Yellow Sapphire (Pukhraj)','Gems','Natural',5.200,0.00,85000.00,11,3,'YS-001','Natural certified yellow sapphire 5.2 carat'),(27,'P127','Blue Sapphire (Neelam)','Gems','Natural',4.800,0.00,125000.00,7,3,'BS-001','Natural certified blue sapphire 4.8 carat'),(28,'P128','Ruby (Manik)','Gems','Natural',3.500,0.00,95000.00,9,3,'RB-001','Burma ruby 3.5 carat certified'),(29,'P129','Emerald (Panna)','Gems','Natural',6.000,0.00,145000.00,0,3,'EM-001','Colombian emerald 6 carat premium quality'),(30,'P130','Pearl (Moti) Necklace','Gems','Natural',45.000,5000.00,55000.00,14,5,'PL-001','South sea pearl necklace with gold clasp'),(31,'P131','Gold Choker','Gold','22K',35.000,10000.00,195000.00,6,3,'GCH-001','22K gold choker necklace with kundan work'),(32,'P132','Gold Waist Chain','Gold','22K',55.000,15000.00,310000.00,2,3,'GW-001','22K gold kamarband/waist chain'),(33,'P133','Gold Toe Ring (Pair)','Gold','22K',3.000,1000.00,18000.00,29,5,'GT-001','Pair of 22K gold toe rings'),(34,'P134','Gold Stud Earrings','Gold','18K',3.500,1500.00,19500.00,34,5,'GSE-001','18K gold daily-wear stud earrings'),(35,'P135','Gold Bracelet (Ladies)','Gold','22K',14.000,4500.00,78000.00,10,5,'GBL-001','Ladies 22K gold bracelet with floral design'),(36,'P136','Diamond Choker','Diamond','VS1',65.000,85000.00,750000.00,0,2,'DCH-001','VS1 diamond choker with emerald accents'),(37,'P137','Diamond Nose Pin','Diamond','VVS2',0.500,3000.00,22000.00,17,5,'DNP-001','Tiny VVS2 diamond nose pin in white gold'),(38,'P138','Diamond Bangle','Diamond','VS2',28.000,55000.00,420000.00,4,3,'DBG-001','VS2 diamond bangle in 18K gold'),(39,'P139','Silver Pendant','Silver','925',5.000,800.00,3800.00,49,5,'SPD-001','925 silver Om pendant'),(40,'P140','Silver Wine Glass Set','Silver','925',200.000,12000.00,125000.00,1,3,'SWG-001','Set of 2 sterling silver wine glasses'),(41,'P141','Cat Eye (Lehsunia)','Gems','Natural',4.000,0.00,35000.00,13,3,'CE-001','Chrysoberyl cat eye 4 carat certified'),(42,'P142','Coral (Moonga)','Gems','Natural',7.500,0.00,28000.00,19,5,'CR-001','Italian red coral 7.5 carat triangular'),(43,'P143','Hessonite (Gomed)','Gems','Natural',5.000,0.00,18000.00,24,5,'HS-001','Sri Lankan hessonite garnet 5 carat'),(44,'P144','Opal Ring','Gems','Natural',3.200,2000.00,42000.00,8,3,'OR-001','Australian opal in 18K gold ring setting'),(45,'P145','Turquoise Pendant','Gems','Natural',8.000,1500.00,15000.00,17,5,'TP-001','Firoza pendant in silver setting'),(46,'P146','Gold Temple Necklace','Gold','22K',85.000,25000.00,485000.00,1,2,'GTN-001','Traditional South Indian temple jewellery necklace'),(47,'P147','Platinum Wedding Band','Platinum','950',8.000,6000.00,52000.00,11,5,'PWB-001','His & hers 950 platinum wedding band'),(48,'P148','Silver Pooja Thali Set','Silver','925',350.000,15000.00,185000.00,5,3,'SPT-001','Complete silver pooja thali set with accessories'),(49,'P149','Diamond Solitaire Ring','Diamond','IF',4.500,50000.00,550000.00,1,2,'DSR-001','Internally flawless 1 carat solitaire in platinum'),(50,'P150','Gold Baby Bracelet','Gold','22K',5.000,1500.00,30000.00,19,5,'GBB-001','22K gold bracelet for infants with bell charms');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','manager','staff') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'staff',
  `phone` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `salary` decimal(12,2) DEFAULT '0.00',
  `joined_date` date DEFAULT (curdate()),
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Vijayraj Admin','admin','pbkdf2:sha256:1000000$8YMO0ZA0Fb72QfdP$ec253743bdaa7dbc9ba790e0837c1d87027d168e0f4af54d0b667b102f707e24','admin','9876543001','admin@vijayraj.com',85000.00,'2020-01-15',1),(2,'Rohit Sharma','rohit.mgr','pbkdf2:sha256:1000000$fmKhpYuuo3lkxerp$b51fec6f890b0db07cfff3f97e9f3aefe575158b087ef53de8ffb74c81c3f0ed','manager','9876543002','rohit@vijayraj.com',55000.00,'2020-03-10',1),(3,'Priya Deshmukh','priya.mgr','pbkdf2:sha256:1000000$8O1UtLOMSd73T4C2$3b82c1bce2c2d9f05c5c01f785c170dc3d94cfc58cb05290e3fa139da1c0e9c8','manager','9876543003','priya@vijayraj.com',52000.00,'2020-06-22',1),(4,'Amit Patil','amit.staff','pbkdf2:sha256:1000000$kru19gJEdXWsVUKY$88be598b07505b3f8d600e4c61c81cca788073b1418dd0e1d1bb2da0b936e5af','staff','9876543004','amit@vijayraj.com',30000.00,'2021-01-05',1),(5,'Sneha Kulkarni','sneha.staff','pbkdf2:sha256:1000000$GMEcbZ1zKS5yQMdd$67132fdc5f66273121424c4439388a45749300ef0f82ec501cbd3f74eb067805','staff','9876543005','sneha@vijayraj.com',28000.00,'2021-02-14',1),(6,'Rajesh Joshi','rajesh.staff','pbkdf2:sha256:1000000$AbCzpFWbCt2BqXRW$676a8efae829114eea06cd54edbd59bc87845fdb616801de8c3d3a5ddf042db8','staff','9876543006','rajesh@vijayraj.com',32000.00,'2021-04-01',1),(7,'Meena Iyer','meena.staff','pbkdf2:sha256:1000000$PXA4i5VkslOZxQUy$d4e78bbd5d480d58464d9ed5f7a58be6dd68f8c185d3955cb078e3fea7fe400d','staff','9876543007','meena@vijayraj.com',29000.00,'2021-06-15',1),(8,'Suresh Gaikwad','suresh.staff','pbkdf2:sha256:1000000$omvgKWpBmAQvn73r$0e03b27b2013f276e5cda5ef6bd1de34c40edad6b5d29070186683fa10198a53','staff','9876543008','suresh@vijayraj.com',31000.00,'2021-08-20',1),(9,'Kavita More','kavita.staff','pbkdf2:sha256:1000000$rHWZYVEjCLbUC7ng$cf6005f708e376f7e47249bec9cefde022eb34fbdfcc630a97c88bd624905bad','staff','9876543009','kavita@vijayraj.com',27000.00,'2021-10-10',1),(10,'Nitin Pawar','nitin.mgr','pbkdf2:sha256:1000000$NS1z4dBhkhdThQ7F$277e40297ea663d650ca2909098557dca5283920f685b14e2de040d7128ad6a6','manager','9876543010','nitin@vijayraj.com',54000.00,'2022-01-03',1),(11,'Anjali Bhosale','anjali.staff','pbkdf2:sha256:1000000$e3dIzLMtYV3MjaJL$ad337dcb4244af3b1f860b73771b04ab8ed82bbb1777456c94e53aff11ed6e94','staff','9876543011','anjali@vijayraj.com',26000.00,'2022-02-20',1),(12,'Vikram Shinde','vikram.staff','pbkdf2:sha256:1000000$O6dVykYZDHVXKP11$d46a1a9c5f4e42c5f7530b6e3a5407a481881eb5213a9eb7115db1b7111e045d','staff','9876543012','vikram@vijayraj.com',30000.00,'2022-04-12',1),(13,'Pooja Wagh','pooja.staff','pbkdf2:sha256:1000000$cAXm99OGoiSLyNpz$a447f76ed12c0c0fe45d257a984cb00332a916e1878cfd9e860c0bfc240d7f50','staff','9876543013','pooja@vijayraj.com',28500.00,'2022-05-25',1),(14,'Deepak Chavan','deepak.staff','pbkdf2:sha256:1000000$jzs1qt2dxxoq3W5K$b525058b0c3e40226cdd7eac835f92e36e971a97cf1e1b27eb38ce3ea7082a8a','staff','9876543014','deepak@vijayraj.com',29500.00,'2022-07-08',1),(15,'Swati Jadhav','swati.staff','pbkdf2:sha256:1000000$n0MBVpJlrTPYOwFp$ec4c706902889cbf152f12666e9f80b68a403558c4765007a67aa1bf54984ca5','staff','9876543015','swati@vijayraj.com',27500.00,'2022-08-30',1),(16,'Manoj Kale','manoj.staff','pbkdf2:sha256:1000000$NRGP62zZyrgDg4v1$f639bbc2cfeb0516c6faa5e43d29233660ee372104c7801aaf5d387c75fa5bea','staff','9876543016','manoj@vijayraj.com',31000.00,'2022-10-15',1),(17,'Rekha Mane','rekha.staff','pbkdf2:sha256:1000000$c5gr8HhQ2PV7l6q7$5a32ab3fbcf3f14cad3f3266a614806565e6203bce64fe757d767156d323f251','staff','9876543017','rekha@vijayraj.com',26500.00,'2023-01-08',1),(18,'Ganesh Sonawane','ganesh.staff','pbkdf2:sha256:1000000$HZGpuEpimLYQsfkl$15b8092574ed3826ef60ee81f9df87a32d37062cc10d0ca8d0f63aaa10813106','staff','9876543018','ganesh@vijayraj.com',29000.00,'2023-02-22',1),(19,'Nisha Phadke','nisha.staff','pbkdf2:sha256:1000000$91C960QvM0oX9CeS$0a684a2e1608da4d436f8598d0a5298ea4a7e89b335e73a9a6142550bc1d63b2','staff','9876543019','nisha@vijayraj.com',28000.00,'2023-04-05',1),(20,'Sachin Deshpande','sachin.staff','pbkdf2:sha256:1000000$fOQLNleFdASv9APR$26b5b01aca674116c1f3a42de8a0c6a1226d1e86893e9f25090e4941596a9b28','staff','9876543020','sachin@vijayraj.com',30500.00,'2023-05-18',1),(21,'Manisha Thakur','manisha.staff','pbkdf2:sha256:1000000$TxnimtQi0lg2PW5l$4eb6361defa49485d079f2f35c96df988fce6d7ddfea1f9221f06fdf1af91371','staff','9876543021','manisha@vijayraj.com',27000.00,'2023-06-30',1),(22,'Prakash Nimbalkar','prakash.staff','pbkdf2:sha256:1000000$wpNtAyvbdz7uRM4t$6566264fb8bd6dfea82512839919fd7a34aaa0be3ac1b9109bb6d2c05b67b73a','staff','9876543022','prakash@vijayraj.com',32000.00,'2023-08-12',1),(23,'Aarti Lokhande','aarti.staff','pbkdf2:sha256:1000000$vNFk3T433AAQyMrW$d6cd08a0b23fa77166385df0b5869a0a12ecf3a050110e278b1103d72e8b4398','staff','9876543023','aarti@vijayraj.com',28500.00,'2023-09-25',1),(24,'Sanjay Tupe','sanjay.staff','pbkdf2:sha256:1000000$izVm2bCvy8z81mOf$1f7c40ddf5cd269e80397235c8595e0b6de03861edf06a664c07099fad0b98f1','staff','9876543024','sanjay@vijayraj.com',30000.00,'2023-11-07',1),(25,'Varsha Kamble','varsha.staff','pbkdf2:sha256:1000000$BXIFCnrsZ10caKDv$e61c9505f83d501489aef160b1a390a6ddd356a02b1006d1f64aa16a5ed3625f','staff','9876543025','varsha@vijayraj.com',26000.00,'2024-01-02',1),(26,'Tushar Ahire','tushar.staff','pbkdf2:sha256:1000000$c2Pa5gtWt9Sz76Y0$8902488710bb8f724d609aebd48c51f7f617309c492c325ffdf8f486c12b4bc7','staff','9876543026','tushar@vijayraj.com',29500.00,'2024-02-15',1),(27,'Seema Gawade','seema.staff','pbkdf2:sha256:1000000$kyRZUVqID6WbHRYp$5b164c4248bcfe5141b58559e18d88c36aab313528538f7e429d76fe168b7fbf','staff','9876543027','seema@vijayraj.com',27500.00,'2024-03-28',1),(28,'Kiran Dalvi','kiran.staff','pbkdf2:sha256:1000000$T0OA3OSaSxrKMnF5$b103bacdf45b75d1720522c99bf142be2f903e72174582249d874c5dc4c7e1ab','staff','9876543028','kiran@vijayraj.com',31000.00,'2024-05-10',1),(29,'Sunita Bhor','sunita.staff','pbkdf2:sha256:1000000$RzQaoEo9JXapz4aB$4a491394e9daf4a6cbeb720ba36c981d60d431773786b5cfa56547fbb9081ce5','staff','9876543029','sunita@vijayraj.com',28000.00,'2024-06-22',1),(30,'Yogesh Mhatre','yogesh.staff','pbkdf2:sha256:1000000$DoUOGLkyMKDGpoT5$13515d75f2fdb164ac8a48ba68e4009170a25a583f4c950671651a08bea0fdcf','staff','9876543030','yogesh@vijayraj.com',30000.00,'2024-08-05',1),(31,'Pallavi Randive','pallavi.staff','pbkdf2:sha256:1000000$7PqbfipKphCKY8Tp$e8083e57c2731b1091c7ea16f37cd445172b9f4806b1f96095b9379c70e35058','staff','9876543031','pallavi@vijayraj.com',27000.00,'2024-09-17',1),(32,'Ashwin Desai','ashwin.staff','pbkdf2:sha256:1000000$SDRtaytoAKAITuCr$7e66023138c984dfc9dd229e12c829fb5d66662339e80f52156814c507742c57','staff','9876543032','ashwin@vijayraj.com',32000.00,'2024-10-30',1),(33,'Lata Gokhale','lata.staff','pbkdf2:sha256:1000000$2RL5sqFVTSrSVR40$082d46d7bbb7976e132358a7a97a8b25cf7eacbdfafb97ddf4792d09f7c60855','staff','9876543033','lata@vijayraj.com',26500.00,'2025-01-12',1),(34,'Dinesh Sawant','dinesh.staff','pbkdf2:sha256:1000000$PtTJJyGG2XC3SJfC$6c72bbb4694b7ec5e03f5bd5fb48ec2ae44e0a0e4b5fc57c5f3c7cafa7683d38','staff','9876543034','dinesh@vijayraj.com',29000.00,'2025-02-24',1),(35,'Ritu Patel','ritu.staff','pbkdf2:sha256:1000000$7YcONBybeYSsPGMy$ebad792d20adb32cd818325f337cfbf138f2d0ff5fa1517283414b349ec71643','staff','9876543035','ritu@vijayraj.com',28500.00,'2025-03-15',1),(36,'Hemant Thorat','hemant.staff','pbkdf2:sha256:1000000$7KrhI8g4Z7dH0jKw$b8429fd7f320ea1f5420ea8acb272ce57e2e81e729c9373d2332c91d20f82414','staff','9876543036','hemant@vijayraj.com',31000.00,'2025-04-28',1),(37,'Smita Naik','smita.staff','pbkdf2:sha256:1000000$fBz8WjPiNvkA8T5M$afccd791061a5c79a20be5fe2d8c58af05f3796ec875064f9cf8d18b7a0bb25e','staff','9876543037','smita@vijayraj.com',27500.00,'2025-06-10',1),(38,'Pramod Khaire','pramod.staff','pbkdf2:sha256:1000000$JXmPSrMh4fceIWKb$7980b5586866f50b6f72bfd7e105c4f6940a926dc19eb6d66ea7e55b6d87d982','staff','9876543038','pramod@vijayraj.com',30000.00,'2025-07-22',1),(39,'Vandana Shirke','vandana.staff','pbkdf2:sha256:1000000$K0K5DzrSIqFeH5bT$8d14bdbe60a5cb1a7045cb734e09c806163adab21647a539b3ebba28095b0f4c','staff','9876543039','vandana@vijayraj.com',28000.00,'2025-09-01',1),(40,'Arun Phule','arun.staff','pbkdf2:sha256:1000000$kojKnYKUfjYq2gqG$d9d0616d7036c28f25b1176ac01e29c8dcc0860adc7fe582b04995a06bfe6e52','staff','9876543040','arun@vijayraj.com',29500.00,'2025-10-14',1),(41,'Geeta Salvi','geeta.staff','pbkdf2:sha256:1000000$dOUuhmP9DYdlFx01$39f8df3ec1ffb0c90ae0886e4f36b6a16b48a9bd0f838eaf32a472fb9fdd8f40','staff','9876543041','geeta@vijayraj.com',27000.00,'2025-11-26',1),(42,'Milind Bagwe','milind.staff','pbkdf2:sha256:1000000$XFEsBleRvqeJcp4d$0818e4b2a7e9b846ba63da55d3c97ece767a6a2ec28943330cc1221221f2fb31','staff','9876543042','milind@vijayraj.com',32000.00,'2026-01-08',1),(43,'Jyoti Khot','jyoti.staff','pbkdf2:sha256:1000000$S0AIks5YJ0FqAB2z$1affaf5ce94af5956cfe5a336928e6fb9ad03e1635fa4e9c58d7455b86ff9d3c','staff','9876543043','jyoti@vijayraj.com',26500.00,'2026-02-20',1),(44,'Nilesh Raut','nilesh.staff','pbkdf2:sha256:1000000$qH4qrprS38W6kqYj$b0cbfbad8329bb8cca483a6722e57f60dc075a3b4afc06f36e80107f68fa8614','staff','9876543044','nilesh@vijayraj.com',29000.00,'2026-04-03',1),(45,'Aparna Datar','aparna.staff','pbkdf2:sha256:1000000$jERZucAF4JmqrfaP$c4710de2c7e6bb466d8a092b548a7b80179630f606782aeb4835ebcdb13c67df','staff','9876543045','aparna@vijayraj.com',28500.00,'2026-05-16',1),(46,'Rahul Ghosh','rahul.staff','pbkdf2:sha256:1000000$020eTZm1pFqc19ak$7beda1cd4b11ac0c86e13d1ef890f96089296c0585ba367fece6091d87f2f786','staff','9876543046','rahul@vijayraj.com',30000.00,'2026-06-28',1),(47,'Shubhangi Bhise','shubhangi.staff','pbkdf2:sha256:1000000$ol1GePAxmKExPgjU$0b3ae6f991b380f9a9add67d342d03474ad10d855f442295ba17229b0fe70d0f','staff','9876543047','shubhangi@vijayraj.com',27500.00,'2026-07-10',1),(48,'Omkar Satpute','omkar.staff','pbkdf2:sha256:1000000$TuyqwUOLQ5vOYtUB$21b9ff61f76e8449566c94ff67cc03f4790aff182be73a7527a18cfd237d470f','staff','9876543048','omkar@vijayraj.com',31000.00,'2026-08-22',1),(49,'Chitra Londhe','chitra.staff','pbkdf2:sha256:1000000$4szgpQfP6lqX5Efw$b6edcea67893a67a2110c11a985d0ce4cff0c3701eda86b391eb0530d357d3f8','staff','9876543049','chitra@vijayraj.com',28000.00,'2026-09-01',1),(50,'Sameer Karpe','sameer.staff','pbkdf2:sha256:1000000$IKCoWI9nOFnDqR4F$a8904048b2ae499bd06ee96bec82c26ffaf7c7c744cdab0c3365fa3d4db91166','staff','9876543050','sameer@vijayraj.com',30500.00,'2026-09-15',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_customer_purchase_history`
--

DROP TABLE IF EXISTS `v_customer_purchase_history`;
/*!50001 DROP VIEW IF EXISTS `v_customer_purchase_history`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_customer_purchase_history` AS SELECT 
 1 AS `customer_id`,
 1 AS `customer_code`,
 1 AS `customer_name`,
 1 AS `phone`,
 1 AS `loyalty_points`,
 1 AS `invoice_id`,
 1 AS `invoice_no`,
 1 AS `invoice_date`,
 1 AS `grand_total`,
 1 AS `payment_mode`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_daily_sales`
--

DROP TABLE IF EXISTS `v_daily_sales`;
/*!50001 DROP VIEW IF EXISTS `v_daily_sales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_daily_sales` AS SELECT 
 1 AS `sale_date`,
 1 AS `total_invoices`,
 1 AS `total_revenue`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_low_stock`
--

DROP TABLE IF EXISTS `v_low_stock`;
/*!50001 DROP VIEW IF EXISTS `v_low_stock`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_low_stock` AS SELECT 
 1 AS `id`,
 1 AS `product_code`,
 1 AS `name`,
 1 AS `category`,
 1 AS `stock_qty`,
 1 AS `reorder_level`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_monthly_sales`
--

DROP TABLE IF EXISTS `v_monthly_sales`;
/*!50001 DROP VIEW IF EXISTS `v_monthly_sales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_monthly_sales` AS SELECT 
 1 AS `sale_year`,
 1 AS `sale_month`,
 1 AS `month_label`,
 1 AS `total_invoices`,
 1 AS `total_revenue`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_sales_by_category`
--

DROP TABLE IF EXISTS `v_sales_by_category`;
/*!50001 DROP VIEW IF EXISTS `v_sales_by_category`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_sales_by_category` AS SELECT 
 1 AS `category`,
 1 AS `total_invoices`,
 1 AS `total_qty_sold`,
 1 AS `total_revenue`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_sales_by_payment_mode`
--

DROP TABLE IF EXISTS `v_sales_by_payment_mode`;
/*!50001 DROP VIEW IF EXISTS `v_sales_by_payment_mode`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_sales_by_payment_mode` AS SELECT 
 1 AS `payment_mode`,
 1 AS `total_invoices`,
 1 AS `total_revenue`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_top_products`
--

DROP TABLE IF EXISTS `v_top_products`;
/*!50001 DROP VIEW IF EXISTS `v_top_products`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_top_products` AS SELECT 
 1 AS `id`,
 1 AS `product_code`,
 1 AS `name`,
 1 AS `category`,
 1 AS `total_qty_sold`,
 1 AS `total_revenue`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_customer_purchase_history`
--

/*!50001 DROP VIEW IF EXISTS `v_customer_purchase_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_customer_purchase_history` AS select `c`.`id` AS `customer_id`,`c`.`customer_code` AS `customer_code`,`c`.`name` AS `customer_name`,`c`.`phone` AS `phone`,`c`.`loyalty_points` AS `loyalty_points`,`i`.`id` AS `invoice_id`,`i`.`invoice_no` AS `invoice_no`,`i`.`invoice_date` AS `invoice_date`,`i`.`grand_total` AS `grand_total`,`i`.`payment_mode` AS `payment_mode` from (`customers` `c` left join `invoices` `i` on((`i`.`customer_id` = `c`.`id`))) order by `c`.`id`,`i`.`invoice_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_daily_sales`
--

/*!50001 DROP VIEW IF EXISTS `v_daily_sales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_daily_sales` AS select cast(`invoices`.`invoice_date` as date) AS `sale_date`,count(0) AS `total_invoices`,sum(`invoices`.`grand_total`) AS `total_revenue` from `invoices` group by cast(`invoices`.`invoice_date` as date) order by `sale_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_low_stock`
--

/*!50001 DROP VIEW IF EXISTS `v_low_stock`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_low_stock` AS select `products`.`id` AS `id`,`products`.`product_code` AS `product_code`,`products`.`name` AS `name`,`products`.`category` AS `category`,`products`.`stock_qty` AS `stock_qty`,`products`.`reorder_level` AS `reorder_level` from `products` where (`products`.`stock_qty` <= `products`.`reorder_level`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_monthly_sales`
--

/*!50001 DROP VIEW IF EXISTS `v_monthly_sales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_monthly_sales` AS select year(`invoices`.`invoice_date`) AS `sale_year`,month(`invoices`.`invoice_date`) AS `sale_month`,date_format(`invoices`.`invoice_date`,'%Y-%m') AS `month_label`,count(0) AS `total_invoices`,sum(`invoices`.`grand_total`) AS `total_revenue` from `invoices` group by year(`invoices`.`invoice_date`),month(`invoices`.`invoice_date`),date_format(`invoices`.`invoice_date`,'%Y-%m') order by `sale_year` desc,`sale_month` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sales_by_category`
--

/*!50001 DROP VIEW IF EXISTS `v_sales_by_category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_sales_by_category` AS select `p`.`category` AS `category`,count(distinct `i`.`id`) AS `total_invoices`,sum(`ii`.`quantity`) AS `total_qty_sold`,sum(`ii`.`line_total`) AS `total_revenue` from ((`invoice_items` `ii` join `products` `p` on((`p`.`id` = `ii`.`product_id`))) join `invoices` `i` on((`i`.`id` = `ii`.`invoice_id`))) group by `p`.`category` order by `total_revenue` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sales_by_payment_mode`
--

/*!50001 DROP VIEW IF EXISTS `v_sales_by_payment_mode`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_sales_by_payment_mode` AS select `invoices`.`payment_mode` AS `payment_mode`,count(0) AS `total_invoices`,sum(`invoices`.`grand_total`) AS `total_revenue` from `invoices` group by `invoices`.`payment_mode` order by `total_revenue` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_top_products`
--

/*!50001 DROP VIEW IF EXISTS `v_top_products`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_top_products` AS select `p`.`id` AS `id`,`p`.`product_code` AS `product_code`,`p`.`name` AS `name`,`p`.`category` AS `category`,sum(`ii`.`quantity`) AS `total_qty_sold`,sum(`ii`.`line_total`) AS `total_revenue` from (`invoice_items` `ii` join `products` `p` on((`p`.`id` = `ii`.`product_id`))) group by `p`.`id`,`p`.`product_code`,`p`.`name`,`p`.`category` order by `total_qty_sold` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-24 23:10:41
