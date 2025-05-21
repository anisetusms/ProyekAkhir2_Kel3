/*
SQLyog Community v13.2.1 (64 bit)
MySQL - 9.3.0 : Database - railway
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`railway` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `railway`;

/*Table structure for table `booking_rooms` */

DROP TABLE IF EXISTS `booking_rooms`;

CREATE TABLE `booking_rooms` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `booking_id` BIGINT UNSIGNED NOT NULL,
  `room_id` BIGINT UNSIGNED NOT NULL,
  `price` DECIMAL(12,2) NOT NULL COMMENT 'Harga saat booking',
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_rooms_booking_id_foreign` (`booking_id`),
  KEY `booking_rooms_room_id_foreign` (`room_id`),
  CONSTRAINT `booking_rooms_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `booking_rooms_room_id_foreign` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`)
) ENGINE=INNODB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `booking_rooms` */

INSERT  INTO `booking_rooms`(`id`,`booking_id`,`room_id`,`price`,`created_at`,`updated_at`) VALUES 
(2,2,24,500000.00,'2025-04-30 19:41:53','2025-04-30 19:41:53'),
(3,3,25,50000.00,'2025-04-30 19:43:01','2025-04-30 19:43:01'),
(4,4,27,4000.00,'2025-04-30 19:47:09','2025-04-30 19:47:09'),
(15,40,29,100000.00,'2025-05-09 20:30:39','2025-05-09 20:30:39'),
(16,41,29,100000.00,'2025-05-10 02:33:35','2025-05-10 02:33:35'),
(17,42,4,2000000.00,'2025-05-10 02:46:18','2025-05-10 02:46:18'),
(18,43,29,100000.00,'2025-05-10 03:52:38','2025-05-10 03:52:38'),
(19,44,32,10000000.00,'2025-05-10 09:31:18','2025-05-10 09:31:18'),
(21,46,32,10000000.00,'2025-05-11 02:13:04','2025-05-11 02:13:04'),
(22,47,34,800000.00,'2025-05-11 08:03:32','2025-05-11 08:03:32'),
(23,48,35,1234567.00,'2025-05-11 08:17:04','2025-05-11 08:17:04'),
(25,50,29,100000.00,'2025-05-12 00:55:18','2025-05-12 00:55:18'),
(31,56,35,1234567.00,'2025-05-14 08:05:55','2025-05-14 08:05:55'),
(32,57,37,2000000.00,'2025-05-15 03:19:12','2025-05-15 03:19:12');

/*Table structure for table `bookings` */

DROP TABLE IF EXISTS `bookings`;

CREATE TABLE `bookings` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `property_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `is_for_others` TINYINT(1) NOT NULL DEFAULT '0',
  `check_in` DATE NOT NULL,
  `check_out` DATE NOT NULL,
  `total_price` DECIMAL(12,2) NOT NULL,
  `status` ENUM('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'pending',
  `payment_proof` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `guest_name` VARCHAR(255) DEFAULT NULL COMMENT 'Nama tamu jika berbeda dengan pemesan',
  `guest_phone` VARCHAR(20) DEFAULT NULL COMMENT 'Kontak tamu',
  `ktp_image` VARCHAR(255) DEFAULT NULL COMMENT 'Path foto KTP',
  `identity_number` VARCHAR(20) DEFAULT NULL COMMENT 'Nomor KTP/NIK',
  `booking_group` CHAR(36) DEFAULT NULL COMMENT 'UUID untuk grouping multi-properti',
  `special_requests` TEXT COMMENT 'Catatan tambahan',
  `customer_id` BIGINT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bookings_property_id_foreign` (`property_id`),
  KEY `bookings_user_id_foreign` (`user_id`),
  KEY `bookings_customer_id_foreign` (`customer_id`),
  CONSTRAINT `bookings_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bookings_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`),
  CONSTRAINT `bookings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=INNODB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `bookings` */

INSERT  INTO `bookings`(`id`,`property_id`,`user_id`,`is_for_others`,`check_in`,`check_out`,`total_price`,`status`,`payment_proof`,`created_at`,`updated_at`,`guest_name`,`guest_phone`,`ktp_image`,`identity_number`,`booking_group`,`special_requests`,`customer_id`) VALUES 
(2,35,5,0,'2025-05-01','2025-05-05',2000000.00,'pending',NULL,'2025-04-30 19:41:52','2025-04-30 19:41:52','Danbel','0987678945','ktp/KmaJDLFtUs9i9WEqyC5NvvvkNkEUOiBLv5JlcGfx.png','5654345643452342','9c79e0cf-120a-468c-bf65-f0f320f452c5','jsngsn',NULL),
(3,35,5,0,'2025-05-01','2025-05-05',200000.00,'pending',NULL,'2025-04-30 19:43:01','2025-04-30 19:43:01','Danbel','0987678945','ktp/nc6JJdpha34odErrSBCzSMDcWljzchvcKAUMBUBa.png','5654345643452342','7104d597-da1a-4329-84b9-9b2807b49ca2','jsngsn',NULL),
(4,34,5,0,'2025-05-01','2025-05-05',16000.00,'completed',NULL,'2025-04-30 19:47:08','2025-05-12 14:31:14','Danbel','0987678945','ktp/1RlOvafCL3B69ac5lsP0WXOAudE8PoittpXwPOMj.png','5654345643452342','c616b2a5-15f0-494c-a83b-6db1b5f4bfe5','jsngsn',NULL),
(5,37,5,0,'2025-05-06','2025-06-05',600000.00,'pending',NULL,'2025-05-06 09:40:39','2025-05-06 09:40:39','Daniel','081263167246','ktp/ZgT8oqmLiMZ1RCLhXCqL1PAFyF2PjCNPWKtnrTUO.jpg','1234567890123456','48a8cce8-1907-45f8-bb7c-96d4097e7ffd','12tfzhhfshdjdy',NULL),
(6,37,5,0,'2025-05-06','2025-06-05',600000.00,'pending',NULL,'2025-05-06 09:41:03','2025-05-06 09:41:03','Daniel','081263167246','ktp/kBuEBj5WX2282DMuNdsA2e57XUiljJINKX5eGwps.jpg','1234567890123456','97e4aab3-7f49-410f-a144-e60fca4b6418','12tfzhhfshdjdy',NULL),
(7,37,5,0,'2025-05-06','2025-06-05',600000.00,'pending',NULL,'2025-05-06 09:41:36','2025-05-06 09:41:36','Daniel','081263167246','ktp/V3FCdFj7BOT9q9X0C3sFfIEpEzJrQfY5TlFgEJfZ.jpg','1234567890123456','db47345b-1ef8-46d6-97a2-c2a22db2dbcf','12tfzhhfshdjdy',NULL),
(8,37,5,0,'2025-05-06','2025-06-05',600000.00,'pending',NULL,'2025-05-06 09:41:56','2025-05-06 09:41:56','Daniel','081263167246','ktp/b4Huc0b94cwgonofYxrTBt9TghS0dAZAIkQ61wS2.jpg','1234567890123456','cf6daec2-3a17-4530-bf2b-548f93118172','12tfzhhfshdjdy',NULL),
(9,37,5,0,'2025-05-06','2025-06-05',600000.00,'pending',NULL,'2025-05-06 09:42:57','2025-05-06 09:42:57','Daniel','081263167246','ktp/8Igahw71sWEEgUfaSEP2cuahygdntjIh2MFbuiHX.jpg','1234567890123456','eef65868-a85d-4553-b111-101a966c05ca','12tfzhhfshdjdy',NULL),
(10,37,5,0,'2025-05-06','2025-06-05',600000.00,'pending',NULL,'2025-05-06 09:43:18','2025-05-06 09:43:18','Daniel','081263167246','ktp/tBONWlYOESgAYybUQ0gvnVX0scvGpHMEOaeVcO2f.jpg','1234567890123456','0e37459c-0ff0-4141-a136-a69d7b3bfa04','12tfzhhfshdjdy',NULL),
(12,37,5,0,'2025-05-06','2025-06-05',600000.00,'pending',NULL,'2025-05-06 09:44:07','2025-05-06 09:44:07','Daniel','081263167246','ktp/dRRer4m2lZtzTD4DRCPs2r9HD8z2VhMtfmwbCJJg.jpg','1234567890123456','acb296bc-933f-4098-9558-1586828d187a','12tfzhhfshdjdy',NULL),
(13,37,5,0,'2025-05-06','2025-06-05',600000.00,'pending',NULL,'2025-05-06 09:45:17','2025-05-06 09:45:17','Daniel','081263167246','ktp/eYqnUg70eRFBoGhnlVBof7nyUbRizxAr7gZ0QRyr.jpg','1234567890123456','eba78653-0efb-4daf-aef8-77564c3adacb','12tfzhhfshdjdy',NULL),
(14,37,5,0,'2025-05-08','2025-05-09',100000.00,'confirmed',NULL,'2025-05-08 06:42:38','2025-05-10 15:01:59','Deni saja','0987654234562','ktp/GcxkMvigEhKwhTl4QfB6oLK7iibdvjB8yCWlYPKq.jpg','1236547890123654','ed32889c-92be-4238-92fd-a854833d68cf','ubyvv',NULL),
(15,38,5,0,'2025-05-09','2025-05-11',-200000.00,'pending',NULL,'2025-05-09 11:09:41','2025-05-09 11:09:41','Deni yaa','0987654234562','ktp/eNZdRseaYTOtRr3DGwef2IzXD1KnBos0b7PxazBA.png','1234567890123456','68f571df-1387-4996-a596-713b5752aa6c',NULL,NULL),
(16,39,5,0,'2025-05-12','2025-05-16',493827156.00,'cancelled',NULL,'2025-05-09 15:33:43','2025-05-14 12:54:35','danbel','098765432345','ktp/8biRdlzqUnzHqQ6Hj0g3Bf01Wa1EwSeab9lFrMGi.png','1234567890123456','5c8580e0-3b6b-4f05-8b12-7991abb4ed8e','jendela',1),
(17,39,5,0,'2025-05-12','2025-05-16',493827156.00,'confirmed',NULL,'2025-05-09 15:35:03','2025-05-10 15:02:44','Deni yaa','0987654234562','ktp/EBLcSGCLwmuxzEDHCyJZpxpGW95vVLVwjrVkPFct.png','1234567890123456','e3984128-1fa1-4a00-ade0-d53e1259a489','jendela',NULL),
(18,39,5,0,'2025-05-12','2025-05-16',493827156.00,'pending',NULL,'2025-05-09 15:37:18','2025-05-09 15:37:18','danbel','098765432345','ktp/JnlLCUc3q9r31LT21slwvnhp49uu7EAd3Xa0m0QN.png','1234567890123456','802c1b4c-7a29-4dd4-abb9-30d2662e7a0a','jendela',1),
(19,39,5,0,'2025-05-12','2025-05-16',493827156.00,'cancelled',NULL,'2025-05-09 15:38:15','2025-05-12 12:21:04','danbel','098765432345','ktp/NvioRkLdxZuhG42wnr30zJyvNvXwLnspVREFiWyK.png','1234567890123456','23d94979-5543-4942-9124-4e6cc6acac5a','jendela',1),
(20,39,5,0,'2025-05-12','2025-05-16',493827156.00,'confirmed',NULL,'2025-05-09 15:38:38','2025-05-14 09:34:54','Deni yaa','0987654234562','ktp/qYuqUpQSfWCXuGJuDIJKZQSmSEiXCINDqBWfxqLp.png','1234567890123456','cbd3be32-544d-4abf-9a7b-ed58d07fcb08','jendela',NULL),
(21,26,5,0,'2025-05-10','2025-05-14',2400000.00,'cancelled',NULL,'2025-05-09 15:48:03','2025-05-14 09:29:04','Deni yaa','0987654234562','ktp/1JPFclpO0Uoeg8wzQ5bIRBVzg7gc1uDb4ppNFwJN.png','1234567890123456','b98c6e6e-78a9-4ef3-bb4f-bb19dd0dbc29',NULL,NULL),
(22,26,5,0,'2025-05-09','2025-05-11',1000000.00,'completed',NULL,'2025-05-09 16:06:52','2025-05-14 09:25:08','Deni yaa','0987654234562','ktp/a1m7BFDQLBVEr8GFnPLIbSWgoLV9SCExGRX0422p.png','1234567890123456','ee5156d3-f87a-4c60-a3eb-7ea946ee4642',NULL,NULL),
(23,26,5,0,'2025-05-12','2025-06-04',11500000.00,'completed',NULL,'2025-05-09 16:14:13','2025-05-14 09:35:49','Deni yaa','0987654234562','ktp/JPrTgQXqWm7YVePlzjfYyKrptLGFop3f1FNTvjEB.png','1234567890098765','6347fd6a-c948-450a-9874-46a5632e8dab',NULL,NULL),
(24,26,5,0,'2025-05-10','2025-05-12',1099994.00,'cancelled',NULL,'2025-05-09 17:12:44','2025-05-13 03:57:02','Deni yaa','0987654234562','ktp/Wf8349K9tsej5b3rmkbksdKOXELPPG1l12czfHlW.jpg','1234567890123456','bdbcfd97-a9b0-468a-a39a-07470e089d15',NULL,NULL),
(25,26,5,0,'2025-05-10','2025-05-12',1099994.00,'cancelled',NULL,'2025-05-09 17:12:56','2025-05-12 12:27:39','Deni yaa','0987654234562','ktp/k7kD9MOWkZwGuCHq2HfZCknfWs905L4EKs8q0Vkr.jpg','1234567890123456','c2156350-5b07-4283-80c7-10b9cae6059b',NULL,NULL),
(26,26,5,0,'2025-05-10','2025-05-12',1099994.00,'cancelled',NULL,'2025-05-09 17:13:55','2025-05-13 01:42:01','Deni yaa','0987654234562','ktp/ugUrWNu6xqKW71PnNtBLOMDJY6M6v6u9Qm6QxMk8.jpg','1234567890123456','e7f0e6bd-aa33-4523-a3df-35e8eacb0d0a',NULL,NULL),
(27,26,5,0,'2025-05-10','2025-05-12',1099994.00,'cancelled',NULL,'2025-05-09 17:26:02','2025-05-12 12:24:29','Deni yaa','0987654234562','ktp/ctPV54Yps9uMjBFtdvCp81E2SgW9FQesMKvWYPwB.jpg','1234567890123456','3d172618-9b05-490e-8e55-836d1b9fcb7b',NULL,NULL),
(28,26,5,0,'2025-05-10','2025-05-12',1000000.00,'completed',NULL,'2025-05-09 17:28:29','2025-05-14 04:02:29','Deni yaa','0987654234562','ktp/P9LPtwXpYInoQTI3Z5xqjT4U0ANNNol8EwvgJzlz.jpg','1234567890123456','888e3489-672a-4cef-93ed-466dbac30039','1wddfrgdgf',NULL),
(29,26,5,0,'2025-05-10','2025-05-12',442.00,'cancelled',NULL,'2025-05-09 17:41:10','2025-05-10 02:32:00','Deni yaa','0987654234562','ktp/1B8U2tzsPbj68UgXer4qaSAUYEzdAztd6pxeYhbh.jpg','1236547891236547','899cdd1e-77e8-4506-abd5-eb0c4ac88dcb','hjkfh',NULL),
(30,2,5,0,'2025-05-10','2025-05-12',1000000.00,'cancelled',NULL,'2025-05-09 17:43:13','2025-05-12 12:20:41','ghfgj','08521408958','ktp/MUC7f8LaqrzCidDEOglvFg8ynC483TczwgF9lJM3.jpg','0852741963123654','e234757f-2869-4fd1-bb0a-49b2ec0ee6ef','walae',NULL),
(36,38,5,0,'2025-05-10','2025-05-12',200000.00,'cancelled',NULL,'2025-05-09 19:27:19','2025-05-10 02:26:22','Deni yaa','0987654234562','ktp/bdFk8zNczAhVHt3YdcGGHfS3kD6FyslEqGRnnwZ7.jpg','1234567890123456','e962f312-9e65-4afd-b976-3fbe9903e206',NULL,NULL),
(40,38,5,0,'2025-05-10','2025-06-13',3400000.00,'cancelled',NULL,'2025-05-09 20:30:39','2025-05-10 02:25:40','Deni yaa','0987654234562','ktp/j95Ms7POvumU0HpWYKcU9PPkDKYmOUZCEzKjQDcS.jpg','1234567890123456','a6af7311-4e14-45c2-90b5-99d776e4b2f9',NULL,NULL),
(41,38,5,0,'2025-05-10','2025-05-12',200000.00,'cancelled',NULL,'2025-05-10 02:33:34','2025-05-10 02:34:20','Deni yaa','0987654234562','ktp/nA1gWGU2j7iqPCCTwwpkfZUnweHpaVqy0f7GF9g0.jpg','1234567890123456','aea3a8ec-32be-4aec-a0eb-d4cebab48e6e',NULL,NULL),
(42,10,5,0,'2025-05-10','2025-06-09',60000000.00,'cancelled',NULL,'2025-05-10 02:46:18','2025-05-12 07:38:13','Deni yaa','0987654234562','ktp/cMDR6DLg0RNddlCbeKKDcgQxoP7LWfx9YFTHaOG2.jpg','1234567890123456','45c5a7b2-f640-4c44-a316-04a77e7e8e8e',NULL,NULL),
(43,38,5,0,'2025-05-10','2025-05-12',200000.00,'cancelled',NULL,'2025-05-10 03:52:38','2025-05-10 14:57:20','Deni yaa','0987654234562','ktp/Ba6FukZCiSeYxbfIIyUMxOoIQ3FJk9oXm4QZkZjH.jpg','1234567890123456','761535f0-739f-4339-946c-9258f20e0d73','qwertyuiop',NULL),
(44,39,46,0,'2025-05-12','2025-05-18',60000000.00,'completed',NULL,'2025-05-10 09:31:18','2025-05-10 15:32:53','bakwan',NULL,'ktp/twdg7MuYHrDoqem5Ko9yNYfy20RNRwPse7oypSLD.jpg','1236547890456321','1c1dd500-6b0b-4b9f-8c97-3926e8ca6dd5','bisa dulu',NULL),
(46,39,46,0,'2025-05-11','2025-05-13',20000000.00,'cancelled',NULL,'2025-05-11 02:13:04','2025-05-13 06:20:41','Anisetys','082276735592','ktp/u7aYH6okQQJpOfUybz47sgAdciQa8pNU4rkNSZaF.jpg','1236547890123456','a6890f9c-4e09-453b-8574-d66d8e380067','olo',NULL),
(47,39,5,0,'2025-05-11','2025-05-13',1600000.00,'cancelled',NULL,'2025-05-11 08:03:31','2025-05-12 07:37:51','djwwjjwjjw','1234679806434','ktp/iylkNuRrcOLHDc3ygX6FCv77jYcKDuin2Nm2LN2j.jpg','1234567890123456','9312eda2-5925-4c9a-85c5-221565014978','1234djsjsj',1),
(48,39,46,0,'2025-05-11','2025-05-13',2469134.00,'cancelled',NULL,'2025-05-11 08:17:04','2025-05-12 00:49:38','bakwan',NULL,'ktp/Z3TduEqFWe9r46nOkgIpsb1og06eKdoNFF4b92Wt.jpg','1472508369963258','a8c58aca-0e5c-4980-91d1-8b60e4dd6050','bohai lae',NULL),
(50,38,5,0,'2025-05-12','2025-05-14',200000.00,'cancelled',NULL,'2025-05-12 00:55:18','2025-05-12 02:26:43','Deni yaa','0987654234562','ktp/iZtwtKjZ3fRHfRQKOJeujUKTlGKcpUFUlPXsvLFr.jpg','1234567890123456','0ee0b037-2f73-4351-8b11-66423e08fd41',NULL,NULL),
(56,39,46,0,'2025-05-14','2025-05-16',2469134.00,'completed',NULL,'2025-05-14 08:05:55','2025-05-14 08:49:12','bakwan',NULL,'ktp/1YqioVtmzXt8xm8ixJESpymzWOLJ6CnAeUIkKXIM.jpg','0852134679123654','513e50d6-a3fa-4b6e-afde-d46f64dcc749','bol',NULL),
(57,43,5,0,'2025-05-15','2025-05-21',12000000.00,'confirmed',NULL,'2025-05-15 03:19:12','2025-05-15 03:22:10','Deni yaa','0987654234562','ktp/zIjJGFaYkEPCWB8Jza3x8tsvTNFCiv5xhfNLqYnW.jpg','1236547890123654','5f77c6e1-d8f0-457a-920c-e102cfcfc3e0','yah',NULL);

/*Table structure for table `cache` */

DROP TABLE IF EXISTS `cache`;

CREATE TABLE `cache` (
  `key` VARCHAR(255) NOT NULL,
  `value` TEXT NOT NULL,
  `expiration` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`key`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `cache` */

/*Table structure for table `cities` */

DROP TABLE IF EXISTS `cities`;

CREATE TABLE `cities` (
  `id` BIGINT UNSIGNED NOT NULL,
  `city_name` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `prov_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cities_province_new` (`prov_id`),
  CONSTRAINT `fk_cities_province_new` FOREIGN KEY (`prov_id`) REFERENCES `provinces` (`id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `cities` */

INSERT  INTO `cities`(`id`,`city_name`,`prov_id`,`created_at`,`updated_at`) VALUES 
(1,'Medan',2,'2025-04-10 02:34:42','2025-04-10 02:34:42'),
(2,'Binjai',2,'2025-04-10 02:34:42','2025-04-10 02:34:42'),
(3,'Tebing Tinggi',2,'2025-04-10 02:34:42','2025-04-10 02:34:42'),
(4,'Pematang Siantar',2,'2025-04-10 02:34:42','2025-04-10 02:34:42'),
(5,'Toba',2,'2025-04-10 02:35:42','2025-04-10 02:35:42');

/*Table structure for table `customers` */

DROP TABLE IF EXISTS `customers`;

CREATE TABLE `customers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255) NOT NULL,
  `identity_number` VARCHAR(16) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `customers` */

INSERT  INTO `customers`(`id`,`name`,`phone`,`identity_number`,`created_at`,`updated_at`) VALUES 
(1,'djwwjjwjjw','1234679806434','1234567890123456','2025-05-09 15:33:40','2025-05-11 08:03:29'),
(2,'ghfgj','08521408958','0852741963123654','2025-05-09 17:43:12','2025-05-09 17:43:12'),
(3,'Anisetys','082276735592','1236547890123456','2025-05-11 02:13:01','2025-05-11 02:13:01');

/*Table structure for table `districts` */

DROP TABLE IF EXISTS `districts`;

CREATE TABLE `districts` (
  `id` BIGINT UNSIGNED NOT NULL,
  `dis_name` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `city_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_districts_city_new` (`city_id`),
  CONSTRAINT `fk_districts_city_new` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `districts` */

INSERT  INTO `districts`(`id`,`dis_name`,`city_id`,`created_at`,`updated_at`) VALUES 
(1,'Ajibata',5,'2025-04-10 02:38:00','2025-04-10 02:38:00'),
(2,'Balige',5,'2025-04-10 02:38:00','2025-04-10 02:38:00'),
(3,'Habinsaran',5,'2025-04-10 02:38:00','2025-04-10 02:38:00'),
(4,'Lumban Julu',5,'2025-04-10 02:38:00','2025-04-10 02:38:00'),
(5,'Nagori',5,'2025-04-10 02:38:00','2025-04-10 02:38:00'),
(6,'Porsea',5,'2025-04-10 02:38:00','2025-04-10 02:38:00'),
(7,'Silaen',5,'2025-04-10 02:38:00','2025-04-10 02:38:00'),
(8,'Tampahan',5,'2025-04-10 02:38:00','2025-04-10 02:38:00'),
(9,'Laguboti',5,'2025-04-10 02:38:00','2025-04-10 02:38:00'),
(10,'Uluan',5,'2025-04-10 02:38:00','2025-04-10 02:38:00');

/*Table structure for table `facilities` */

DROP TABLE IF EXISTS `facilities`;

CREATE TABLE `facilities` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=INNODB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `facilities` */

/*Table structure for table `homestay_details` */

DROP TABLE IF EXISTS `homestay_details`;

CREATE TABLE `homestay_details` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `property_id` BIGINT UNSIGNED NOT NULL,
  `total_units` INT NOT NULL,
  `available_units` INT NOT NULL,
  `minimum_stay` INT DEFAULT '1',
  `maximum_guest` INT NOT NULL,
  `checkin_time` TIME NOT NULL,
  `checkout_time` TIME NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `homestay_details_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `homestay_details` */

INSERT  INTO `homestay_details`(`id`,`property_id`,`total_units`,`available_units`,`minimum_stay`,`maximum_guest`,`checkin_time`,`checkout_time`,`created_at`,`updated_at`) VALUES 
(1,10,4,2,1,10,'16:00:00','15:00:00','2025-04-17 09:15:12','2025-04-17 09:15:12'),
(2,35,10,5,4,8,'10:00:00','10:00:00','2025-04-30 09:30:19','2025-05-10 16:09:45'),
(3,40,5,1,1,2,'10:00:00','10:00:00','2025-05-10 23:47:22','2025-05-12 13:38:27'),
(4,43,2,2,20,30,'20:00:00','20:00:00','2025-05-12 13:32:03','2025-05-13 15:35:09');

/*Table structure for table `kost_details` */

DROP TABLE IF EXISTS `kost_details`;

CREATE TABLE `kost_details` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `property_id` BIGINT UNSIGNED NOT NULL,
  `kost_type` ENUM('putra','putri','campur') COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_rooms` INT NOT NULL,
  `available_rooms` INT NOT NULL,
  `rules` TEXT COLLATE utf8mb4_unicode_ci NOT NULL,
  `meal_included` TINYINT(1) DEFAULT '0',
  `laundry_included` TINYINT(1) DEFAULT '0',
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `kost_details_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `kost_details` */

INSERT  INTO `kost_details`(`id`,`property_id`,`kost_type`,`total_rooms`,`available_rooms`,`rules`,`meal_included`,`laundry_included`,`created_at`,`updated_at`) VALUES 
(1,2,'putra',5,2,'ihfu',1,1,'2025-04-17 02:30:21','2025-04-17 02:30:21'),
(2,3,'campur',40,6,'jas slebew',1,1,'2025-04-17 06:53:35','2025-04-17 06:53:35'),
(3,4,'campur',34,5,'yah',1,1,'2025-04-17 07:50:16','2025-04-17 07:50:16'),
(4,5,'putri',12,3,'dw',1,1,'2025-04-17 08:01:53','2025-04-17 08:01:53'),
(5,8,'putri',6,2,'frfe',1,1,'2025-04-17 08:51:07','2025-04-17 08:51:07'),
(6,11,'putri',20,6,'dialarang bawa pacar',1,1,'2025-04-18 01:24:00','2025-04-18 01:24:00'),
(7,12,'campur',25,10,'nanti aja',1,1,'2025-04-21 03:37:30','2025-04-21 03:37:30'),
(8,13,'campur',20,6,'test aja',1,1,'2025-04-23 08:58:57','2025-04-23 08:58:57'),
(9,14,'putra',43,23,'dfbgngfd',1,1,'2025-04-25 01:09:30','2025-04-25 01:09:30'),
(10,15,'putra',43,23,'dfbgngfd',1,1,'2025-04-25 01:09:44','2025-04-25 01:09:44'),
(11,16,'putra',344,34,'rtdyughijlk',1,1,'2025-04-25 01:36:59','2025-04-25 01:36:59'),
(12,17,'putra',10,3,'ej',1,1,'2025-04-25 02:30:37','2025-04-25 02:30:37'),
(13,18,'putra',33,23,'ertgyhjhg',1,1,'2025-04-25 02:48:34','2025-04-25 02:48:34'),
(14,19,'campur',15,10,'Test',1,1,'2025-04-25 09:08:21','2025-04-25 09:08:21'),
(17,24,'campur',10,2,'jonwf',1,1,'2025-04-27 14:35:41','2025-04-27 14:35:41'),
(18,25,'putri',10,2,'fo',1,1,'2025-04-27 14:48:12','2025-04-27 14:48:12'),
(19,26,'putra',21,2,'deib',1,1,'2025-04-28 04:33:05','2025-04-28 04:33:05'),
(24,33,'putra',10,2,'cacs',1,1,'2025-04-29 02:35:17','2025-04-29 02:35:17'),
(25,34,'putra',12,12,'qwerty',1,1,'2025-04-29 09:35:33','2025-04-29 09:35:33'),
(26,36,'putra',49,20,'shwj',1,1,'2025-05-02 02:31:37','2025-05-02 02:31:37'),
(27,37,'campur',20,2,'bebasss',1,1,'2025-05-02 02:55:19','2025-05-09 07:19:44'),
(28,38,'putra',20,1,'y',1,1,'2025-05-08 01:43:20','2025-05-09 07:06:12'),
(29,39,'putra',20,5,'rajin doa',1,1,'2025-05-09 04:13:32','2025-05-09 04:41:58'),
(30,41,'campur',20,5,'tidak bisa bawa pacar ke kamar',1,1,'2025-05-12 13:25:03','2025-05-12 13:25:03'),
(31,42,'putra',20,5,'bole saja',1,1,'2025-05-12 13:29:42','2025-05-13 08:39:31');

/*Table structure for table `migrations` */

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` INT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `migrations` */

INSERT  INTO `migrations`(`id`,`migration`,`batch`) VALUES 
(1,'2025_04_08_154706_create_user_types_table',1),
(2,'2025_04_08_154727_create_user_roles_table',1),
(3,'2025_04_08_154735_create_users_table',1),
(4,'2025_04_08_154743_create_provinces_table',1),
(5,'2025_04_08_154845_create_cities_table',1),
(6,'2025_04_08_154903_create_districts_table',1),
(7,'2025_04_08_154910_create_subdistricts_table',1),
(8,'2025_04_08_154915_create_properties_table',1),
(9,'2025_04_08_154922_create_property_facilities_table',1),
(10,'2025_04_08_154928_create_property_images_table',1),
(11,'2025_04_08_154935_create_property_prices_table',1),
(12,'2025_04_08_155724_create_sessions_table',2),
(13,'2025_04_09_091411_add_username_to_users_table',3),
(17,'2025_04_09_102023_add_is_banned_to_users_table',4),
(18,'2025_04_10_030814_create_personal_access_tokens_table',5),
(21,'2025_04_11_030622_add_no_telepon_to_tabel_users',6),
(23,'2025_04_11_043843_add_photo__to_tabel_users',7),
(24,'2025_04_11_044648_add_address__to_tabel_users',8),
(25,'2025_04_13_085833_add_gender_to_users_table',9),
(26,'2025_04_17_014346_fix_properties_table_structure',10),
(27,'2025_04_26_174239_create_wishlists_table',11),
(28,'2025_04_30_163316_update_tabel_booking',12),
(29,'2025_04_30_163423_add_table_booking_rooms',13),
(30,'2025_04_30_163503_add_table_property_availability',14),
(31,'2025_05_02_141424_create_recent_searches_table',15),
(33,'2025_05_07_034542_remove_customer_id_from_bookings_table',16),
(34,'2025_05_07_021551_create_customers_table',17),
(35,'2025_05_07_033650_add_customer_id_to_bookings_table',18),
(36,'2025_05_07_100620_add_is_for_others_to_bookings_table',19);

/*Table structure for table `notifications` */

DROP TABLE IF EXISTS `notifications`;

CREATE TABLE `notifications` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `type` VARCHAR(255) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `message` TEXT NOT NULL,
  `reference_id` BIGINT UNSIGNED DEFAULT NULL,
  `is_read` TINYINT(1) DEFAULT '0',
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `notifications` */

INSERT  INTO `notifications`(`id`,`user_id`,`type`,`title`,`message`,`reference_id`,`is_read`,`created_at`,`updated_at`) VALUES 
(1,46,'booking_confirmed','Pemesanan Anda telah dikonfirmasi','Pemesanan Anda untuk Pope Francis telah dikonfirmasi oleh pemilik.',44,0,'2025-05-10 11:18:27','2025-05-10 11:18:27'),
(6,46,'booking_completed','Pemesanan Anda telah selesai','Pemesanan Anda untuk Pope Francis telah diselesaikan.',44,1,'2025-05-10 15:32:53','2025-05-12 12:34:15'),
(9,5,'booking_completed','Pemesanan Anda telah selesai','Pemesanan Anda untuk qwertyui telah diselesaikan.',4,0,'2025-05-12 14:31:15','2025-05-12 14:31:15'),
(11,1,'booking_new','Pemesanan Baru','bakwan telah memesan Pope Francis dari 14 May 2025 hingga 16 May 2025',56,1,'2025-05-14 08:06:02','2025-05-14 08:13:58'),
(12,46,'booking_confirmed','Booking Dikonfirmasi','Booking Anda untuk Pope Francis dari 14 May 2025 hingga 16 May 2025 telah dikonfirmasi oleh pemilik.',56,0,'2025-05-14 08:33:01','2025-05-14 08:33:01'),
(13,5,'booking_confirmed','Booking Dikonfirmasi','Booking Anda untuk yahh dari 12 May 2025 hingga 04 Jun 2025 telah dikonfirmasi oleh pemilik.',23,0,'2025-05-14 08:48:00','2025-05-14 08:48:00'),
(14,46,'booking_completed','Pemesanan Anda telah selesai','Pemesanan Anda untuk Pope Francis telah diselesaikan.',56,0,'2025-05-14 08:49:12','2025-05-14 08:49:12'),
(16,5,'booking_completed','Booking Selesai','Booking Anda untuk yahh dari 09 May 2025 hingga 11 May 2025 telah selesai.',22,1,'2025-05-14 09:25:08','2025-05-14 09:27:57'),
(17,5,'booking_confirmed','Pemesanan Anda telah dikonfirmasi','Pemesanan Anda untuk Pope Francis telah dikonfirmasi oleh pemilik,/n Silahkan lakukan pembayaran saat check-in di lokasi.',20,0,'2025-05-14 09:34:54','2025-05-14 09:34:54'),
(18,5,'booking_completed','Pemesanan Anda telah selesai','Pemesanan Anda untuk yahh telah diselesaikan.',23,1,'2025-05-14 09:35:50','2025-05-14 16:35:33'),
(19,1,'booking_new','Pemesanan Baru','Deni yaa telah memesan Homestay Bahagia Bulbul dari 15 May 2025 hingga 21 May 2025',57,1,'2025-05-15 03:19:14','2025-05-15 03:20:52'),
(20,5,'booking_confirmed','Booking Dikonfirmasi','Booking Anda untuk Homestay Bahagia Bulbul dari 15 May 2025 hingga 21 May 2025 telah dikonfirmasi oleh pemilik. pembayaran akan dilakukan setelah anda check-in langsung, Terimakasih .',57,0,'2025-05-15 03:22:10','2025-05-15 03:22:10');

/*Table structure for table `personal_access_tokens` */

DROP TABLE IF EXISTS `personal_access_tokens`;

CREATE TABLE `personal_access_tokens` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` VARCHAR(255) NOT NULL,
  `tokenable_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `token` VARCHAR(64) NOT NULL,
  `abilities` TEXT,
  `last_used_at` TIMESTAMP NULL DEFAULT NULL,
  `expires_at` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=INNODB AUTO_INCREMENT=874 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `personal_access_tokens` */

INSERT  INTO `personal_access_tokens`(`id`,`tokenable_type`,`tokenable_id`,`name`,`token`,`abilities`,`last_used_at`,`expires_at`,`created_at`,`updated_at`) VALUES 
(1,'App\\Models\\User',1,'api-token','5ef5fcf04e9b4cf2891b240abcaeb11e31a2e507d6115139ba4a5fb7b86f8864','[\"*\"]',NULL,NULL,'2025-04-10 09:38:49','2025-04-10 09:38:49'),
(2,'App\\Models\\User',1,'api-token','a019a2b222835a943237794192b071c1ce34ef84f9d1b2e22642bd9f6c1b062e','[\"*\"]',NULL,NULL,'2025-04-10 09:41:18','2025-04-10 09:41:18'),
(3,'App\\Models\\User',1,'api-token','d6453ded4719e6283b5a4bb3081a8e58a9626808828c4c506cd9d73f2cb8f978','[\"*\"]',NULL,NULL,'2025-04-10 09:43:46','2025-04-10 09:43:46'),
(4,'App\\Models\\User',1,'api-token','5e1f342596a7a3413f3d2a2e8bdab32f06e59cacb460d17628b86199b522501a','[\"*\"]',NULL,NULL,'2025-04-10 13:04:36','2025-04-10 13:04:36'),
(5,'App\\Models\\User',1,'api-token','9e81c08880aa845163c158d84a98679522d88bb2e68892e6debfb6b327fc8213','[\"*\"]',NULL,NULL,'2025-04-10 13:06:38','2025-04-10 13:06:38'),
(6,'App\\Models\\User',1,'api-token','93717eff67de51a5227b1eb4f2651ec18b974978cf616c589a3d57dd6f4ac89e','[\"*\"]',NULL,NULL,'2025-04-10 13:07:47','2025-04-10 13:07:47'),
(7,'App\\Models\\User',1,'api-token','08d9253373ad7dabe2111d316fba414b0578da7b6d76309a89499cdaeeee5b89','[\"*\"]',NULL,NULL,'2025-04-10 14:21:14','2025-04-10 14:21:14'),
(8,'App\\Models\\User',1,'api-token','8a3c60f75c39479851a0f70c9957215865722e3c61cde06daf71aa55843e3403','[\"*\"]',NULL,NULL,'2025-04-10 14:21:19','2025-04-10 14:21:19'),
(9,'App\\Models\\User',1,'api-token','ecb1c631c4b39a7a4a9005b9f2ca39301b8890729eaf9fe3ff1a4f243d81908e','[\"*\"]',NULL,NULL,'2025-04-10 14:21:22','2025-04-10 14:21:22'),
(10,'App\\Models\\User',1,'api-token','86ef944b014fc4fe6dde783bc2445b74f110af7fb37bab04734af9a7a72e8d56','[\"*\"]',NULL,NULL,'2025-04-10 23:22:40','2025-04-10 23:22:40'),
(11,'App\\Models\\User',1,'api-token','1595e99b1ab38fa1546d1be6d606cef268deb45b8b36ea773f4734ed5eabd1a8','[\"*\"]',NULL,NULL,'2025-04-10 23:32:20','2025-04-10 23:32:20'),
(12,'App\\Models\\User',1,'api-token','be7dababf27de6ec189ae27998f6470ebf29e4ce32b60ed57543a4feaaa9a48c','[\"*\"]',NULL,NULL,'2025-04-11 02:00:34','2025-04-11 02:00:34'),
(13,'App\\Models\\User',1,'api-token','e6a6271e7f5b5011537baacac651344193974611d3330cede35eeac4339277d3','[\"*\"]',NULL,NULL,'2025-04-11 02:01:35','2025-04-11 02:01:35'),
(14,'App\\Models\\User',1,'api-token','a9857a6d31fbbd7e137ea242569814142b72dfa53e646d8a45bc305241a3f0a7','[\"*\"]',NULL,NULL,'2025-04-11 02:22:40','2025-04-11 02:22:40'),
(15,'App\\Models\\User',1,'api-token','0759bd2fa778fead5dc34d965fe68d0eb73fb42e3656c258c9af8310e497524e','[\"*\"]',NULL,NULL,'2025-04-11 02:24:42','2025-04-11 02:24:42'),
(16,'App\\Models\\User',1,'api-token','2f988b947fb47d5dc0fc7ef61e5ed53a4427a50b5ce99e41e8306aefdae9adac','[\"*\"]',NULL,NULL,'2025-04-11 02:59:56','2025-04-11 02:59:56'),
(17,'App\\Models\\User',1,'api-token','09a53d6c95a7d55cbf9c1b1d8df59921464d701d789f8ad604c576a32b20bb95','[\"*\"]',NULL,NULL,'2025-04-11 03:26:09','2025-04-11 03:26:09'),
(18,'App\\Models\\User',7,'api-token','7416f02c21c2bc05c2a33064deb8617e8d129c613b537f54b04e72ac129f5d3f','[\"*\"]',NULL,NULL,'2025-04-11 03:31:56','2025-04-11 03:31:56'),
(19,'App\\Models\\User',7,'api-token','0a22ebb0638612976c75a45decf5250a84d0b65015607b33528b5f9d68f4d39b','[\"*\"]',NULL,NULL,'2025-04-11 03:36:02','2025-04-11 03:36:02'),
(20,'App\\Models\\User',8,'api-token','0afb6b52506e7496cfb31fd8c222b234fcd2f6e6a7448c9447eaac8694cab983','[\"*\"]',NULL,NULL,'2025-04-11 03:47:49','2025-04-11 03:47:49'),
(21,'App\\Models\\User',10,'api-token','2cd8d53d01cf03a4715831267f267ebfa3b1762bb436d42e96a5d88df5d75851','[\"*\"]',NULL,NULL,'2025-04-11 03:51:21','2025-04-11 03:51:21'),
(22,'App\\Models\\User',11,'api-token','465b3a71def7f06e40fc2a0492cb013788824361d930980aba6224697e50a24c','[\"*\"]',NULL,NULL,'2025-04-11 03:53:31','2025-04-11 03:53:31'),
(23,'App\\Models\\User',12,'api-token','d06e79d8b7aecf5cf7a5e0b1a192dcf654d0831d28ada0be2ae7e9644e4ab564','[\"*\"]',NULL,NULL,'2025-04-11 03:56:55','2025-04-11 03:56:55'),
(24,'App\\Models\\User',7,'api-token','330266f98044e3d102a89a38bd8bf6fb68ef9cf6f302aa8f1e56f899a78310e9','[\"*\"]',NULL,NULL,'2025-04-11 04:07:04','2025-04-11 04:07:04'),
(25,'App\\Models\\User',13,'api-token','518e6c2bfba0dbb752bcf615e935e13f794b862d60b60be5542f7cce4a410131','[\"*\"]',NULL,NULL,'2025-04-11 13:01:02','2025-04-11 13:01:02'),
(26,'App\\Models\\User',14,'api-token','7b1b1f2fb61d6cde8f80ab1f8b937ec582eeb9c5c8064ea5796ce35bbdbcc59d','[\"*\"]',NULL,NULL,'2025-04-11 13:08:23','2025-04-11 13:08:23'),
(27,'App\\Models\\User',1,'api-token','03090bcfeb0daf00e5950f43c6f3efb5f83473d2a2a4af012c1718aab2d1240a','[\"*\"]',NULL,NULL,'2025-04-11 13:41:33','2025-04-11 13:41:33'),
(28,'App\\Models\\User',15,'api-token','8b97131950b29dddfe918f217a32683b72272c73994a19012506418a4d5533f8','[\"*\"]',NULL,NULL,'2025-04-11 17:42:16','2025-04-11 17:42:16'),
(29,'App\\Models\\User',15,'api-token','6b2ecce44a11fa228dfb477c542a7c7bb43f781bba8578771249975a62dfb420','[\"*\"]',NULL,NULL,'2025-04-11 17:58:06','2025-04-11 17:58:06'),
(30,'App\\Models\\User',1,'api-token','774e40e1b5373e0519970e228053ecf62018cf25dc7dcfe6c553f87ceb5e0632','[\"*\"]',NULL,NULL,'2025-04-13 08:56:14','2025-04-13 08:56:14'),
(31,'App\\Models\\User',16,'api-token','21b5ed0c9ef4a79f848520ba2896a19db202c0087db308d18c08ce7397fbacf6','[\"*\"]',NULL,NULL,'2025-04-13 09:28:29','2025-04-13 09:28:29'),
(32,'App\\Models\\User',17,'api-token','553630494d6c9fe7abb5ede37fbd1f603d895ebc8c18f8e9dfd59d04ca5eb07d','[\"*\"]',NULL,NULL,'2025-04-13 09:31:16','2025-04-13 09:31:16'),
(33,'App\\Models\\User',1,'api-token','25cbf843b52f01fd05a18c60752758be2925c5043f7247c62636bf8740176eb3','[\"*\"]',NULL,NULL,'2025-04-14 02:56:51','2025-04-14 02:56:51'),
(34,'App\\Models\\User',1,'api-token','948dff8353e312bba28fed4f696f20529cab038b5b05e6c0feefe9bc306dc0c8','[\"*\"]',NULL,NULL,'2025-04-14 12:44:49','2025-04-14 12:44:49'),
(35,'App\\Models\\User',1,'api-token','85fb6297652f11696eff81e8ca8749f9693bf43d121a50f8dbf4c5d1e23baabf','[\"*\"]',NULL,NULL,'2025-04-14 14:19:28','2025-04-14 14:19:28'),
(36,'App\\Models\\User',1,'api-token','c9ff1a3bc79420a007d24daef52a4f7b659e74274a786d844e1130de27a38276','[\"*\"]',NULL,NULL,'2025-04-15 01:01:54','2025-04-15 01:01:54'),
(37,'App\\Models\\User',1,'api-token','da0c6e3f98676f3a9ac6b9b8f6e478d5740b65049289ace27a2553265fc90045','[\"*\"]',NULL,NULL,'2025-04-15 01:10:12','2025-04-15 01:10:12'),
(38,'App\\Models\\User',1,'api-token','71a478817862c7e819d630a4e985373393c1caf5af78dd5d60ac34c410e013cb','[\"*\"]',NULL,'2025-04-17 02:13:09','2025-04-17 02:12:08','2025-04-17 02:12:09'),
(39,'App\\Models\\User',1,'api-token','00db7392299b69b80d48b9eba801e983f18609e5b60070004efda72f6c1ddfc3','[\"*\"]',NULL,'2025-04-17 03:10:50','2025-04-17 03:09:49','2025-04-17 03:09:50'),
(40,'App\\Models\\User',1,'api-token','f822b35dc8e1956ec12cb9e6d7fd90bc80301ae1eec354afda574babcc2d6e20','[\"*\"]','2025-04-17 03:40:28','2025-04-17 03:40:48','2025-04-17 03:39:47','2025-04-17 03:40:28'),
(41,'App\\Models\\User',1,'api-token','541fa66f9defd8e88ed40a77f8cc3a36be91f30a214354c2832a012e884395c0','[\"*\"]','2025-04-17 03:49:58','2025-04-17 03:52:24','2025-04-17 03:47:24','2025-04-17 03:49:58'),
(42,'App\\Models\\User',1,'api-token','611b378612dd5e9bef93f6c8666e0a3c57430f1845b883e0d0554acf31c469dc','[\"*\"]',NULL,'2025-04-17 04:02:05','2025-04-17 03:57:05','2025-04-17 03:57:05'),
(43,'App\\Models\\User',1,'api-token','820f24fb931b195df8a462656916b73fcff8087a497d3d8fb4072045d96d45c5','[\"*\"]','2025-04-17 04:09:23','2025-04-17 04:14:18','2025-04-17 04:09:17','2025-04-17 04:09:23'),
(44,'App\\Models\\User',1,'api-token','4e87f35e5bd6f180239d4d54ac1770abfb652b1fa749df23ec730c60f5cdddda','[\"*\"]','2025-04-17 04:10:25','2025-04-17 04:15:08','2025-04-17 04:10:08','2025-04-17 04:10:25'),
(45,'App\\Models\\User',1,'api-token','fe15b4e226896ce231e1f74bc9ae01aa64b1b8ef7dd1825ab547964cc6fe67ff','[\"*\"]','2025-04-17 04:17:09','2025-04-17 04:22:04','2025-04-17 04:17:03','2025-04-17 04:17:09'),
(46,'App\\Models\\User',1,'api-token','8ed70301ebd371256439b780714c7c7d99134a9e6688e550e8e36db5ff121095','[\"*\"]','2025-04-17 04:31:47','2025-04-17 04:36:38','2025-04-17 04:31:37','2025-04-17 04:31:47'),
(47,'App\\Models\\User',5,'api-token','1ab13e448d316eb8c73c69c881f31a8e0d3c7328239d08d0007d578125f6e812','[\"*\"]',NULL,NULL,'2025-04-17 04:43:43','2025-04-17 04:43:43'),
(48,'App\\Models\\User',1,'api-token','3473737ba06b86a92e5c34aeccddaeb2a08c02860c5f2678cae5df569bcd58b8','[\"*\"]','2025-04-17 06:20:24','2025-04-17 06:25:13','2025-04-17 06:20:13','2025-04-17 06:20:24'),
(49,'App\\Models\\User',1,'api-token','161f0fbd12d3aa81edfc8861608ce40bad44b5351fa25b3d79d7f10c4b156da4','[\"*\"]','2025-04-17 07:28:37','2025-04-17 07:33:30','2025-04-17 07:28:30','2025-04-17 07:28:37'),
(50,'App\\Models\\User',1,'api-token','61661ab376eb33003f2b98fc7eb214881c5144a2b49a1950db5d176d5f4f24d9','[\"*\"]','2025-04-17 07:33:32','2025-04-17 07:38:14','2025-04-17 07:33:14','2025-04-17 07:33:32'),
(51,'App\\Models\\User',1,'api-token','a2762f2b848e3c40ef8a153eb0502747b60dff3a0e9dba45c594d214019c57ba','[\"*\"]','2025-04-17 08:10:26','2025-04-17 08:15:11','2025-04-17 08:10:11','2025-04-17 08:10:26'),
(52,'App\\Models\\User',8,'api-token','982aefd4cb796e7746571f40b2eecdb6c2c4ddad3b9989340fb7c93c01563677','[\"*\"]','2025-04-17 08:46:06','2025-04-17 08:50:58','2025-04-17 08:45:58','2025-04-17 08:46:06'),
(53,'App\\Models\\User',1,'api-token','3f4e9914669c2df55a570c237cdd56da31fbf3195892ceae2dde6ed6c520c284','[\"*\"]','2025-04-17 08:48:32','2025-04-17 08:53:23','2025-04-17 08:48:21','2025-04-17 08:48:32'),
(56,'App\\Models\\User',5,'api-token','45d0845bdb9f756800d7cf56c7df837a87fd17c57fb5f0b0d5c8f93c9008edf8','[\"*\"]',NULL,'2025-04-17 09:17:30','2025-04-17 09:12:29','2025-04-17 09:12:30'),
(57,'App\\Models\\User',1,'api-token','0847d534bf63fa8165c060f4883a15b1f516d343358358e4ddcb573f25a543e6','[\"*\"]','2025-04-19 05:20:23','2025-04-19 05:25:17','2025-04-19 05:20:16','2025-04-19 05:20:23'),
(58,'App\\Models\\User',1,'api-token','03c7af58ecaac625bc77c0438e21c88146d10459f2a1c1ac6b46ef77c9c132a3','[\"*\"]','2025-04-19 05:37:20','2025-04-19 05:41:36','2025-04-19 05:36:36','2025-04-19 05:37:20'),
(59,'App\\Models\\User',1,'api-token','7daa9ca26ad61b1930f53cb125ba147099041ff383e06deeab59ce2b24436080','[\"*\"]','2025-04-19 05:42:14','2025-04-19 05:47:02','2025-04-19 05:42:02','2025-04-19 05:42:14'),
(60,'App\\Models\\User',1,'api-token','5f846f67aad8aedfd493b2ee161fa6b8b0d6bb148337430414e7a34162b1438b','[\"*\"]','2025-04-19 05:48:14','2025-04-19 05:53:07','2025-04-19 05:48:07','2025-04-19 05:48:14'),
(62,'App\\Models\\User',1,'api-token','1e8f594dcc43dd383b1b9cdfafb07b588cd123429bf1be011eb92d9c22d82899','[\"*\"]','2025-04-19 06:18:41','2025-04-19 06:23:38','2025-04-19 06:18:37','2025-04-19 06:18:41'),
(63,'App\\Models\\User',1,'api-token','1b5e288946de3a7852d89b831a4a26b0ea56f4b8b4bab37f6e77e0a1991012da','[\"*\"]','2025-04-19 09:37:01','2025-04-19 09:39:18','2025-04-19 09:34:17','2025-04-19 09:37:01'),
(64,'App\\Models\\User',1,'api-token','047e881532a3b64c77fee97aa47ed6508e2545816b22ed426415efa12fbdd28f','[\"*\"]','2025-04-19 09:42:00','2025-04-19 09:44:17','2025-04-19 09:39:17','2025-04-19 09:42:00'),
(66,'App\\Models\\User',5,'api-token','dcd57a30dc5ac5acc0b3634b8e00dd029d000dbac2cd5d97f41b3f8a239e2d9e','[\"*\"]',NULL,'2025-04-21 04:39:08','2025-04-21 04:34:07','2025-04-21 04:34:08'),
(67,'App\\Models\\User',1,'api-token','ee19c30706b2613768d7e66dda4b22c0a2f44b0353478f6399e2fb644c447883','[\"*\"]','2025-04-21 09:23:30','2025-04-21 09:28:21','2025-04-21 09:23:20','2025-04-21 09:23:30'),
(68,'App\\Models\\User',1,'api-token','e6d7b331b85ae3f922d216734eb7b8e7238979f497e23116ffd4e1bb71f93032','[\"*\"]','2025-04-21 09:27:04','2025-04-21 09:31:55','2025-04-21 09:26:55','2025-04-21 09:27:04'),
(69,'App\\Models\\User',1,'api-token','d77d6cc5d87ee6e8d38b979d44ec863122bc38ba61021d758d28dde0f3729187','[\"*\"]','2025-04-21 09:28:51','2025-04-21 09:33:46','2025-04-21 09:28:45','2025-04-21 09:28:51'),
(70,'App\\Models\\User',1,'api-token','beed7ffa04c0f4b4149eb24fc942ca2ccc07bfd2ecc188ae945490bd29b8508e','[\"*\"]','2025-04-21 09:51:10','2025-04-21 09:52:03','2025-04-21 09:51:03','2025-04-21 09:51:10'),
(71,'App\\Models\\User',1,'api-token','f200c4547db8cf3dd18c249f04bee9e0c8a1133ee347fa0fd42660ea27438d3a','[\"*\"]',NULL,'2025-04-21 13:35:21','2025-04-21 13:30:21','2025-04-21 13:30:21'),
(72,'App\\Models\\User',4,'api-token','b60b1c1577b0cc39601b0156753fa608fdbd85757092856f02a0fc0101329bec','[\"*\"]',NULL,'2025-04-21 13:45:04','2025-04-21 13:40:04','2025-04-21 13:40:04'),
(73,'App\\Models\\User',1,'api-token','2fdf46fac96002e1da7d70301f561e871518217c4e22099494fab5835c079b59','[\"*\"]','2025-04-22 01:17:20','2025-04-22 01:18:07','2025-04-22 01:17:05','2025-04-22 01:17:20'),
(74,'App\\Models\\User',1,'api-token','862887a7a1699ae60611648aa1bfbb9269cace6442b35b21dae0260d666ba418','[\"*\"]','2025-04-22 01:21:43','2025-04-22 01:22:10','2025-04-22 01:20:52','2025-04-22 01:21:43'),
(75,'App\\Models\\User',1,'api-token','ee157632bac6edc251af9b5c76859a22c83e0d8ea8afd65c87445f0485283417','[\"*\"]','2025-04-22 01:24:49','2025-04-22 01:25:44','2025-04-22 01:24:44','2025-04-22 01:24:49'),
(76,'App\\Models\\User',8,'api-token','93b5a8850b6fad86082c5b4739a23c07ef55e970a740b83b277117ab1dea170f','[\"*\"]','2025-04-22 01:30:21','2025-04-22 01:31:16','2025-04-22 01:30:15','2025-04-22 01:30:21'),
(78,'App\\Models\\User',1,'api-token','cc8eff8b3e28dab0655c6f0a9a782270dd9a5f448feb9ed2ed513b9bdb45c5e4','[\"*\"]','2025-04-22 01:35:01','2025-04-22 01:35:56','2025-04-22 01:34:56','2025-04-22 01:35:01'),
(80,'App\\Models\\User',8,'api-token','0a9cff9db301f01acd0b8663b2e120ee91ab2e7371f3a82ff09db06514c93dd9','[\"*\"]','2025-04-22 01:52:00','2025-04-22 01:52:53','2025-04-22 01:51:52','2025-04-22 01:52:00'),
(81,'App\\Models\\User',1,'api-token','af8528a735b5fda868cc735ac666def7a403034045e523163d517600504431dc','[\"*\"]','2025-04-22 02:03:27','2025-04-22 02:04:23','2025-04-22 02:03:23','2025-04-22 02:03:27'),
(82,'App\\Models\\User',1,'api-token','0a0b7455cf32cd4b7aae99ab5e39ac5b69a3be54938ecd4c02a4f943f3fbf1f7','[\"*\"]',NULL,NULL,'2025-04-22 02:11:03','2025-04-22 02:11:03'),
(86,'App\\Models\\User',8,'api-token','30664328e34d1e8870af0976f4dd6576a86f3bfcf3c69ff4c401950eed085ecc','[\"*\"]','2025-04-22 02:53:58','2025-04-22 02:57:15','2025-04-22 02:53:15','2025-04-22 02:53:58'),
(87,'App\\Models\\User',1,'authToken','2c08f21c80b06d15db6d065fc7340fb303f035eaed6c668767ee1beb3173dd7d','[\"*\"]',NULL,NULL,'2025-04-22 06:27:51','2025-04-22 06:27:51'),
(88,'App\\Models\\User',4,'authToken','e9b7bd938c5062ab3abea54f6e7a8d925cf01fb432d71ca90ba7170544c29124','[\"*\"]',NULL,NULL,'2025-04-22 06:28:35','2025-04-22 06:28:35'),
(89,'App\\Models\\User',4,'authToken','08dcf526a09ed8bb0c159bdc05f069b2cecf169f39fee5d8a649d553f06111d6','[\"*\"]','2025-04-22 06:32:31',NULL,'2025-04-22 06:29:35','2025-04-22 06:32:31'),
(90,'App\\Models\\User',1,'authToken','054c6736b2bae76038df761143961d74442b011ece2653708f62b15f444a1eaf','[\"*\"]','2025-04-22 06:54:03',NULL,'2025-04-22 06:35:52','2025-04-22 06:54:03'),
(91,'App\\Models\\User',1,'authToken','03eec4de7e9091f4873cf1dab36417818f37fa129e72815c6039373714b8f9d7','[\"*\"]','2025-04-22 08:58:13',NULL,'2025-04-22 06:56:33','2025-04-22 08:58:13'),
(92,'App\\Models\\User',1,'api-token','4f6b72615bb7fa844a3a4a389d0dc70b10d3cbcb959fe66bde0147b108e9fda4','[\"*\"]',NULL,'2025-04-22 07:01:22','2025-04-22 06:57:20','2025-04-22 06:57:22'),
(93,'App\\Models\\User',1,'api-token','d88e43136d8b08c397c007d3b273012954b4260c2ecdbeeb66b53253555e860a','[\"*\"]',NULL,'2025-04-22 07:01:27','2025-04-22 06:57:26','2025-04-22 06:57:27'),
(94,'App\\Models\\User',1,'api-token','97da10766fc1a758e3bd4ec868b110e1f65f2d3923a7f67c2979c4127baa83c4','[\"*\"]',NULL,'2025-04-22 07:01:30','2025-04-22 06:57:30','2025-04-22 06:57:30'),
(95,'App\\Models\\User',1,'api-token','0bbfc9828493028d2e4998264992f66bc9e718913cd0ffac5c550ba786507aa1','[\"*\"]','2025-04-22 06:57:41','2025-04-22 07:01:32','2025-04-22 06:57:31','2025-04-22 06:57:41'),
(96,'App\\Models\\User',1,'api-token','d308b75fc65c2b9987b417f4b69bd122b90b1c317e1347a5e8eca763f1f4c068','[\"*\"]','2025-04-22 07:24:31','2025-04-22 07:28:22','2025-04-22 07:24:20','2025-04-22 07:24:31'),
(97,'App\\Models\\User',1,'api-token','7e91a36114674102e8d46cb357fb44ae7042de4476f0b9e6631f18b4063d1dae','[\"*\"]','2025-04-22 08:10:45','2025-04-22 08:14:39','2025-04-22 08:10:38','2025-04-22 08:10:45'),
(99,'App\\Models\\User',1,'api-token','32b960bb688073342e5ad829cb89d330a771705286602066fc5da49bba6a0552','[\"*\"]','2025-04-22 08:48:33','2025-04-22 08:53:55','2025-04-22 08:33:55','2025-04-22 08:48:33'),
(100,'App\\Models\\User',1,'api-token','58e2622927648caf943edf97b785d28fa1b0974f4ce4aab828b9343d77e41b47','[\"*\"]','2025-04-22 08:39:32','2025-04-22 08:59:06','2025-04-22 08:39:05','2025-04-22 08:39:32'),
(101,'App\\Models\\User',1,'authToken','57a9435a3ee4e0ac77d776d49b47194bc5aa00ebba8ef51fe4198a5c680a333e','[\"*\"]','2025-04-22 09:01:40',NULL,'2025-04-22 09:01:37','2025-04-22 09:01:40'),
(102,'App\\Models\\User',1,'authToken','3f52523064405e869b3b1f2c6f5c0aa09f4798549d09b369dbc1ab4985fac4f6','[\"*\"]','2025-04-22 09:30:31',NULL,'2025-04-22 09:09:44','2025-04-22 09:30:31'),
(103,'App\\Models\\User',1,'api-token','436f98aa34d49bffdd11841f3684f97f02beba210832db6fd132e9a9f3897705','[\"*\"]','2025-04-22 09:21:16','2025-04-22 09:40:57','2025-04-22 09:20:57','2025-04-22 09:21:16'),
(104,'App\\Models\\User',1,'authToken','3798424f19954229414303a0870cd175fd803478d4359e07f31b2637e258495d','[\"*\"]','2025-04-22 09:37:46',NULL,'2025-04-22 09:32:46','2025-04-22 09:37:46'),
(105,'App\\Models\\User',1,'authToken','293d552cc634cc41eb4e6f87a5c69e8989ab721f6a6c5c126d734a26736cd86d','[\"*\"]','2025-04-22 13:58:55',NULL,'2025-04-22 13:01:59','2025-04-22 13:58:55'),
(106,'App\\Models\\User',1,'authToken','2e37aaf9b453f4daee24bc99306ee914b1dd54522e843d1acf64708159c255bf','[\"*\"]','2025-04-22 13:50:47',NULL,'2025-04-22 13:50:30','2025-04-22 13:50:47'),
(107,'App\\Models\\User',10,'authToken','43ee2123f1f4cc441c0387298a8b57faf7eeac4d64ffc110c8d6a419d187c665','[\"*\"]','2025-04-22 14:09:59',NULL,'2025-04-22 14:03:42','2025-04-22 14:09:59'),
(108,'App\\Models\\User',1,'authToken','8c0bd9d8a3061db7e90f1d9c0e3b4de2d35942edaa49008f4996b566ef538a0e','[\"*\"]','2025-04-22 14:17:16',NULL,'2025-04-22 14:15:53','2025-04-22 14:17:16'),
(109,'App\\Models\\User',1,'authToken','e9dcee3637810cfdc12844261479b4f8a2fd5511b9d41500a4fa200217b27019','[\"*\"]','2025-04-23 01:20:50',NULL,'2025-04-23 01:04:58','2025-04-23 01:20:50'),
(110,'App\\Models\\User',1,'authToken','a063c10d50550d7b90ea676871851059738f92e8befa9154d9ca1bae374358e9','[\"*\"]','2025-04-23 01:31:28',NULL,'2025-04-23 01:30:55','2025-04-23 01:31:28'),
(111,'App\\Models\\User',1,'authToken','3b6c96575f458befef51bafda808228cdb6b3bc107e0853f1de22f8e50040aae','[\"*\"]','2025-04-23 01:38:19',NULL,'2025-04-23 01:37:55','2025-04-23 01:38:19'),
(112,'App\\Models\\User',1,'authToken','a1816ccec8622efc21f1569bbd82bd7a3ac0c8fcad5fbeb36df23e865e1e0294','[\"*\"]','2025-04-23 01:45:24',NULL,'2025-04-23 01:45:07','2025-04-23 01:45:24'),
(113,'App\\Models\\User',1,'authToken','286b6c7ae075f370f9c0feb2e80d741c3ad7bf45ba7d7f08e62ec2fa2114bd93','[\"*\"]','2025-04-23 01:50:31',NULL,'2025-04-23 01:50:10','2025-04-23 01:50:31'),
(114,'App\\Models\\User',1,'authToken','d2b4959089770e63e08e65787f7ad361616b1b5a197a90ba3b42a3c707e1bb21','[\"*\"]','2025-04-23 01:56:34',NULL,'2025-04-23 01:55:29','2025-04-23 01:56:34'),
(115,'App\\Models\\User',1,'authToken','c885a3fd79cf071531b2968a99a2fa89896713f6d6c219b55d65158b2a947249','[\"*\"]','2025-04-23 02:22:46',NULL,'2025-04-23 02:08:02','2025-04-23 02:22:46'),
(116,'App\\Models\\User',1,'authToken','524446b5fad645fb93b6711bac677e313259dfa7c276cacdefb4c49e73141ec5','[\"*\"]','2025-04-23 08:51:15',NULL,'2025-04-23 08:27:22','2025-04-23 08:51:15'),
(117,'App\\Models\\User',1,'authToken','62a11899926cb50eabe6b3a01940f61144e52da50dc3b5bc889f49f878351311','[\"*\"]','2025-04-23 09:06:03',NULL,'2025-04-23 08:53:30','2025-04-23 09:06:03'),
(118,'App\\Models\\User',1,'authToken','aae01d293ecbd3d6096f0f3f6324b1b00a88a9ece09f8b1724ea0e3e7f5e1711','[\"*\"]','2025-04-23 15:03:04',NULL,'2025-04-23 14:57:14','2025-04-23 15:03:04'),
(119,'App\\Models\\User',1,'authToken','044c259545222dcab2aac9b3bcafef4fc889e6dd30bc99f174088c03e03f0ea8','[\"*\"]','2025-04-24 01:09:59',NULL,'2025-04-24 01:02:02','2025-04-24 01:09:59'),
(120,'App\\Models\\User',1,'authToken','3f5b045edc6d212ae13547abf044823fe08ef39a31d60932e286e7df078f93b7','[\"*\"]','2025-04-24 01:19:26',NULL,'2025-04-24 01:13:42','2025-04-24 01:19:26'),
(121,'App\\Models\\User',1,'authToken','47af8507ff423baa1ede6e10ded096e7fc81825392e4b3e3b19e1ed53e66ae71','[\"*\"]','2025-04-24 01:16:44',NULL,'2025-04-24 01:16:40','2025-04-24 01:16:44'),
(122,'App\\Models\\User',1,'authToken','bcb8c7b414213a52b7cd9ba8f278339d6ded2564ec17e20f17d59679813de3f6','[\"*\"]','2025-04-24 01:31:55',NULL,'2025-04-24 01:23:23','2025-04-24 01:31:55'),
(123,'App\\Models\\User',1,'authToken','72dcbe96a02a094c0c898b489538d6e31e74d70d3fa39d3ada4fc0cf3202d9d3','[\"*\"]',NULL,NULL,'2025-04-24 01:28:27','2025-04-24 01:28:27'),
(124,'App\\Models\\User',1,'authToken','2628cfc798a9da226c6e528ba643fcb061ca0045cd259639d58a56eecca7f187','[\"*\"]','2025-04-24 01:52:49',NULL,'2025-04-24 01:35:51','2025-04-24 01:52:49'),
(125,'App\\Models\\User',1,'authToken','36493c919fb382329a4d73af873e7e9485ad4a8a3bb6487702fe4660cabdba2e','[\"*\"]',NULL,NULL,'2025-04-24 01:37:32','2025-04-24 01:37:32'),
(126,'App\\Models\\User',1,'authToken','b6faf7950f6dc7200f729da2c1949a495fdb71ddb6a0247dda300bf9a5c5d7fc','[\"*\"]',NULL,NULL,'2025-04-24 01:44:08','2025-04-24 01:44:08'),
(127,'App\\Models\\User',1,'authToken','3c8a41cea0157e8b41905250b1a2f2f289a1d4806b9a88400a77b83d6df86fe0','[\"*\"]',NULL,NULL,'2025-04-24 01:54:08','2025-04-24 01:54:08'),
(128,'App\\Models\\User',1,'authToken','6233e14fd3c2aadceea492be997b282dad14153f1be8b12922111336c43bfc55','[\"*\"]',NULL,NULL,'2025-04-24 01:58:15','2025-04-24 01:58:15'),
(129,'App\\Models\\User',1,'authToken','655b68437d6f8e2eaca00d431f93bf24b2097b957eb649046780e05485d901d3','[\"*\"]','2025-04-24 02:17:53',NULL,'2025-04-24 02:09:31','2025-04-24 02:17:53'),
(130,'App\\Models\\User',1,'authToken','475278e1c007d25f969366d19519ebc6888d85d5f5ca0509a9e5018271970c51','[\"*\"]',NULL,NULL,'2025-04-24 02:10:38','2025-04-24 02:10:38'),
(131,'App\\Models\\User',13,'authToken','79334125003aba1fa00bb2e31fd3e9d718ff987a25a68a8c176a7bb217710e6b','[\"*\"]','2025-04-24 02:25:33',NULL,'2025-04-24 02:24:39','2025-04-24 02:25:33'),
(132,'App\\Models\\User',1,'authToken','b85ffedf360eef47c4af5893aeb39f60df79873a8346ba69c3354b249368a010','[\"*\"]','2025-04-24 07:23:34',NULL,'2025-04-24 04:16:05','2025-04-24 07:23:34'),
(133,'App\\Models\\User',14,'authToken','94ab7cfc507edaf9e0b8d1d7d77b99c918e9e856c733da3573f6646b19ec3c76','[\"*\"]',NULL,NULL,'2025-04-24 04:16:17','2025-04-24 04:16:17'),
(134,'App\\Models\\User',15,'authToken','09831da5add0d2cf4552478d047e2fa3158c5d28c3ec4139833014e71ac31356','[\"*\"]',NULL,NULL,'2025-04-24 04:18:21','2025-04-24 04:18:21'),
(135,'App\\Models\\User',16,'authToken','6e8899ff5c3f532205b91e3bb044cc5df68b12b281ded24b1c97711caca8ac72','[\"*\"]',NULL,NULL,'2025-04-24 04:19:54','2025-04-24 04:19:54'),
(136,'App\\Models\\User',16,'authToken','305a543402cf7ea6029d66ab4b582ed69743e5a21018f02e17c8bd6b3f6d8a33','[\"*\"]','2025-04-24 04:49:47',NULL,'2025-04-24 04:49:44','2025-04-24 04:49:47'),
(137,'App\\Models\\User',16,'authToken','9160ec39f8a4774200e2ca0b72f5f6f15d2c34722a41ad535494c7e6234666e0','[\"*\"]',NULL,NULL,'2025-04-24 05:59:11','2025-04-24 05:59:11'),
(138,'App\\Models\\User',1,'authToken','a250d49dcab1f0da6562e9c54a34dbc4e99222356c6aae99bd73e71f8b43512a','[\"*\"]',NULL,NULL,'2025-04-24 06:01:24','2025-04-24 06:01:24'),
(139,'App\\Models\\User',1,'authToken','9d473c6c9b4554fcf7d43dbde9f587ea9501051379f98193fd2ae5982ec039bc','[\"*\"]',NULL,NULL,'2025-04-24 06:03:40','2025-04-24 06:03:40'),
(140,'App\\Models\\User',1,'authToken','0315262eeb82da6e8dcc9fc2016ed32276887a46ef7e70e50fc0ace3a11c465a','[\"*\"]',NULL,NULL,'2025-04-24 06:04:40','2025-04-24 06:04:40'),
(141,'App\\Models\\User',1,'authToken','767aa075f235d9f4df385af894a13f125d1c6b4e91a8c31cd8f89c56fd9332a8','[\"*\"]',NULL,NULL,'2025-04-24 06:13:05','2025-04-24 06:13:05'),
(142,'App\\Models\\User',1,'authToken','5cc0ca4280e569689d6ffb90310ed5e5dde531124f1165bac1bcb09cdf795d7c','[\"*\"]',NULL,NULL,'2025-04-24 06:16:06','2025-04-24 06:16:06'),
(143,'App\\Models\\User',1,'authToken','e2c3dd8310af399ed34d7d9deb76f21a4854b40b3dea41158a30ee0430447554','[\"*\"]',NULL,NULL,'2025-04-24 06:19:55','2025-04-24 06:19:55'),
(144,'App\\Models\\User',1,'authToken','ac34405ffd48780c4a13e25b98d1fc3fcaca2017591f3361b96183b5d8c70a6a','[\"*\"]',NULL,NULL,'2025-04-24 06:24:02','2025-04-24 06:24:02'),
(145,'App\\Models\\User',1,'authToken','51bbafbb6bef0e9dbe591df401c42b4b17580783a18a02dd33c952c6d576be3c','[\"*\"]',NULL,NULL,'2025-04-24 06:29:57','2025-04-24 06:29:57'),
(146,'App\\Models\\User',16,'authToken','4e37a11616bef66e1d59ec23c02e8ef80ed3d0f7f36b775eb3a018d083fc716d','[\"*\"]',NULL,NULL,'2025-04-24 06:33:07','2025-04-24 06:33:07'),
(147,'App\\Models\\User',1,'authToken','af8eb1402932973d7c282d3c370795072c8dfb72dbb9f50fdc62d20f14cf93e8','[\"*\"]','2025-04-24 06:53:15',NULL,'2025-04-24 06:36:32','2025-04-24 06:53:15'),
(148,'App\\Models\\User',1,'authToken','8742e44168a77332ce761c2ecd700170e06552f73b2ee565adc7d922fb6e5fbe','[\"*\"]','2025-04-24 08:01:04',NULL,'2025-04-24 07:23:53','2025-04-24 08:01:04'),
(149,'App\\Models\\User',1,'authToken','a0d7afd09acc41958363fe5277f2ffcc5bd589ee03099fcf28c56a79ac7c27f1','[\"*\"]','2025-04-24 07:52:05',NULL,'2025-04-24 07:47:31','2025-04-24 07:52:05'),
(150,'App\\Models\\User',1,'authToken','8615edaebbbd0ccf163f19f3d0b30ac8f600dc2f27139e27c555f2ba0fe1e103','[\"*\"]','2025-04-24 08:11:22',NULL,'2025-04-24 08:01:21','2025-04-24 08:11:22'),
(151,'App\\Models\\User',1,'authToken','a93c5b4e268ae9151220427782b8528acd377db3ec8e1c6bd27c4bc6471ad30a','[\"*\"]','2025-04-24 08:21:16',NULL,'2025-04-24 08:08:45','2025-04-24 08:21:16'),
(152,'App\\Models\\User',1,'authToken','366bf287501b36bf300248f7283d4acf1ece171c4bb2aaa58374132ae5ddf9af','[\"*\"]','2025-04-24 08:17:29',NULL,'2025-04-24 08:17:03','2025-04-24 08:17:29'),
(153,'App\\Models\\User',1,'authToken','8403463d23b9945f3333f337189859b95b298e34c2b30fce7d39f916f742a202','[\"*\"]','2025-04-24 08:18:39',NULL,'2025-04-24 08:18:14','2025-04-24 08:18:39'),
(154,'App\\Models\\User',1,'authToken','3653a0b21f1ed812256560ae772111f5d043cd332f481eb5f0f685cb6dcde298','[\"*\"]','2025-04-24 08:28:49',NULL,'2025-04-24 08:20:15','2025-04-24 08:28:49'),
(155,'App\\Models\\User',1,'authToken','8b0dc3aaad4378a18ad061f54ecb4fec9ab96baadf28dd3f2c76527f532188e8','[\"*\"]','2025-04-24 08:30:55',NULL,'2025-04-24 08:28:39','2025-04-24 08:30:55'),
(156,'App\\Models\\User',1,'authToken','8ee07a15eb2df30f0eb7ed2167176b75cfdc6ca01aca5d8d341c5910125053a2','[\"*\"]','2025-04-24 08:35:37',NULL,'2025-04-24 08:30:49','2025-04-24 08:35:37'),
(157,'App\\Models\\User',16,'authToken','a4b7fff70438332504e81a481291bad9518b04a8f256d959325913de45b68076','[\"*\"]',NULL,NULL,'2025-04-24 08:36:05','2025-04-24 08:36:05'),
(158,'App\\Models\\User',1,'authToken','ede0ceaca06bab45d35626410ec60d140c481e6556a543f77cd190d206254287','[\"*\"]','2025-04-24 08:55:13',NULL,'2025-04-24 08:36:35','2025-04-24 08:55:13'),
(159,'App\\Models\\User',16,'authToken','a80806a2f9baaabd64b636076eb50a4e7a7340a6f8166d27941d7e58385cd937','[\"*\"]',NULL,NULL,'2025-04-24 08:37:23','2025-04-24 08:37:23'),
(160,'App\\Models\\User',16,'authToken','547e640bc40b911a3be6620a6a626b2ae456fdaff033df1f9593a2d63fa21095','[\"*\"]',NULL,NULL,'2025-04-24 08:37:34','2025-04-24 08:37:34'),
(161,'App\\Models\\User',16,'authToken','94919238ec5e1a109558d5a9f740e1c22b2773efe1819290cd6909df34a66c0f','[\"*\"]',NULL,NULL,'2025-04-24 08:38:12','2025-04-24 08:38:12'),
(162,'App\\Models\\User',16,'authToken','4578e7464b8e4b3d645a2f3862fc03549e54a93df15235712015d93c0515871e','[\"*\"]',NULL,NULL,'2025-04-24 08:38:14','2025-04-24 08:38:14'),
(163,'App\\Models\\User',16,'authToken','db0bd509dafc2ad1bfa3c7e15a425bcb50761b6b5561b489fc935a08ffb696a0','[\"*\"]',NULL,NULL,'2025-04-24 08:38:16','2025-04-24 08:38:16'),
(164,'App\\Models\\User',16,'authToken','3a9944365d9ca460cdd92c8af3520eeaa6a3a253ec17448762252ccc20e77e4b','[\"*\"]',NULL,NULL,'2025-04-24 08:38:17','2025-04-24 08:38:17'),
(165,'App\\Models\\User',1,'authToken','8a7d2d1f74860f91f78d936b60e0a9bc58a2c2c9670b11e010d81d2f18683949','[\"*\"]',NULL,NULL,'2025-04-24 08:44:07','2025-04-24 08:44:07'),
(166,'App\\Models\\User',16,'authToken','3810569db7a4f87f9bf882b4b79cf4b4f1d46f2c679223546a73ff069e9fed1d','[\"*\"]',NULL,NULL,'2025-04-24 08:46:07','2025-04-24 08:46:07'),
(167,'App\\Models\\User',1,'authToken','38749d1877d75ab5898d439b9a30b679b6fdf06799fe6b7eb585f806e763dd73','[\"*\"]','2025-04-24 08:58:47',NULL,'2025-04-24 08:58:29','2025-04-24 08:58:47'),
(168,'App\\Models\\User',1,'authToken','458ed7772368ea844b32a3ca08eed427730b0cb78776fb0343c494f0f46462ca','[\"*\"]','2025-04-24 09:00:02',NULL,'2025-04-24 08:58:30','2025-04-24 09:00:02'),
(169,'App\\Models\\User',1,'authToken','588734c1082017f177549e752030fd0979e506cd157d43054fd567af1239476f','[\"*\"]','2025-04-24 08:59:38',NULL,'2025-04-24 08:59:29','2025-04-24 08:59:38'),
(170,'App\\Models\\User',16,'authToken','758dfe5e86be2d70b036c9e8f07ca8ab18460fbc7c8c801ea29b79af820128e6','[\"*\"]',NULL,NULL,'2025-04-24 09:00:35','2025-04-24 09:00:35'),
(171,'App\\Models\\User',16,'authToken','c53d3da230f1e929a795087852f58b9bebdfab50c9fb9699b041b4128760031e','[\"*\"]',NULL,NULL,'2025-04-24 09:05:49','2025-04-24 09:05:49'),
(172,'App\\Models\\User',1,'authToken','add701c8db4dd0ada55e10cd58d4071dcb975735cd62d61fc64b00190776ae8b','[\"*\"]','2025-04-24 09:13:37',NULL,'2025-04-24 09:12:58','2025-04-24 09:13:37'),
(173,'App\\Models\\User',1,'authToken','e18deac72b4168d9c0a38a13b009dda589f32d29d2cc47a233a7333608b4303d','[\"*\"]','2025-04-24 09:15:37',NULL,'2025-04-24 09:15:29','2025-04-24 09:15:37'),
(174,'App\\Models\\User',1,'authToken','a36aecda8702e64adae7d9bda412f26c8894a2fc9f699cec410f6ffed40c4984','[\"*\"]','2025-04-24 09:22:34',NULL,'2025-04-24 09:22:03','2025-04-24 09:22:34'),
(175,'App\\Models\\User',1,'authToken','9fd3b19825c1e052b8eebc9e393b6f48147aaee815eab8f4ce99bd8e618aac1b','[\"*\"]','2025-04-24 09:28:03',NULL,'2025-04-24 09:27:37','2025-04-24 09:28:03'),
(176,'App\\Models\\User',1,'authToken','865c717bb8cf40c92e0806f5da113f3b20f711d0e9d0ea1c4bab9a71372a86e5','[\"*\"]','2025-04-24 09:59:11',NULL,'2025-04-24 09:33:24','2025-04-24 09:59:11'),
(177,'App\\Models\\User',1,'authToken','8cf77ce72a4ede08e17c9d902c138d4475edc106e28ecaf5ef71d1bac33fa530','[\"*\"]','2025-04-24 11:38:39',NULL,'2025-04-24 11:37:36','2025-04-24 11:38:39'),
(178,'App\\Models\\User',1,'authToken','b4d6fa65522dd2b25ca97aee7a42a50f743298a28209611e205c40cdde15998e','[\"*\"]','2025-04-24 12:54:10',NULL,'2025-04-24 12:51:41','2025-04-24 12:54:10'),
(179,'App\\Models\\User',1,'authToken','3c7b24abc92948e549a9af62a53667f26347914edc5bffc814dc80c299785506','[\"*\"]','2025-04-24 12:59:54',NULL,'2025-04-24 12:58:55','2025-04-24 12:59:54'),
(180,'App\\Models\\User',1,'authToken','134ed35c2adab84bac24eb7f8a00902884965af02400875d180141572c0500b4','[\"*\"]','2025-04-24 13:12:20',NULL,'2025-04-24 13:07:32','2025-04-24 13:12:20'),
(181,'App\\Models\\User',1,'authToken','f1a37b0d5514f5d0fcc65a898955c3bf60ec068460119e77a9dae1b3da60f1e4','[\"*\"]','2025-04-24 13:15:52',NULL,'2025-04-24 13:14:31','2025-04-24 13:15:52'),
(182,'App\\Models\\User',1,'authToken','e684d3d7f7c0c17dad4445b40396358226e1de2618532a0389bc78c3a9284eec','[\"*\"]','2025-04-24 13:41:29',NULL,'2025-04-24 13:30:48','2025-04-24 13:41:29'),
(183,'App\\Models\\User',1,'authToken','e513f31a13d29717c3e595236bbe58bd771ebee807161612917e417bbd673c88','[\"*\"]','2025-04-24 13:33:44',NULL,'2025-04-24 13:32:00','2025-04-24 13:33:44'),
(184,'App\\Models\\User',1,'authToken','5a91682dfd80068aa580c9ee5c7924f05badc413d08f33ddd67c2018e3c2eeff','[\"*\"]','2025-04-24 14:10:53',NULL,'2025-04-24 13:44:23','2025-04-24 14:10:53'),
(185,'App\\Models\\User',1,'authToken','388fe0060dade76cdf6899f0f89b6a1e5ef0d211d77683ba5810a7c004b80e32','[\"*\"]','2025-04-24 13:48:21',NULL,'2025-04-24 13:44:48','2025-04-24 13:48:21'),
(186,'App\\Models\\User',1,'authToken','ceddab048e2e84faa03d2008a9c3dd4bebe24c5c3a6788b524da90c5caa31c99','[\"*\"]','2025-04-24 13:57:12',NULL,'2025-04-24 13:55:53','2025-04-24 13:57:12'),
(187,'App\\Models\\User',1,'authToken','fb54ea4e783774a3eceb4d30dcc52984fb9eed2c36e3913a49b85f3b34046489','[\"*\"]','2025-04-24 14:02:11',NULL,'2025-04-24 14:01:09','2025-04-24 14:02:11'),
(188,'App\\Models\\User',1,'authToken','40d1034e60d964cb70d589a2395a08d272ea2e80c190a1becdd204db1fc0f28f','[\"*\"]','2025-04-24 14:11:18',NULL,'2025-04-24 14:11:03','2025-04-24 14:11:18'),
(189,'App\\Models\\User',1,'authToken','2c2c8fd90c0ba860b0e6f5853653911534c60597615124367ea8d75d2b11becf','[\"*\"]','2025-04-24 14:12:12',NULL,'2025-04-24 14:11:24','2025-04-24 14:12:12'),
(190,'App\\Models\\User',1,'authToken','bc11dfbfffbe082a8c4b9a6d820552e5d8226767b64d48333b75d957f39cb881','[\"*\"]','2025-04-24 14:17:33',NULL,'2025-04-24 14:16:38','2025-04-24 14:17:33'),
(191,'App\\Models\\User',1,'authToken','734e997c573604811025adbdfdde57cc2c0ccb25d994ac8d054200c54436350f','[\"*\"]','2025-04-24 14:21:17',NULL,'2025-04-24 14:20:28','2025-04-24 14:21:17'),
(192,'App\\Models\\User',1,'authToken','d03aa4907757fa56c12a6ebd9205609414fe0eff6457ea97690aa978064878e2','[\"*\"]','2025-04-25 01:26:50',NULL,'2025-04-25 01:07:53','2025-04-25 01:26:50'),
(193,'App\\Models\\User',1,'authToken','92e2eeb94061090f9e57e0bb86a8601d3cb1b4450c7cbdd8c235ddb2952b012d','[\"*\"]','2025-04-25 01:15:48',NULL,'2025-04-25 01:14:21','2025-04-25 01:15:48'),
(194,'App\\Models\\User',1,'authToken','80ce239be8c3b2c2117bf74120cfe171aa837da51dd3c922e640162064979bf9','[\"*\"]','2025-04-25 01:53:44',NULL,'2025-04-25 01:28:34','2025-04-25 01:53:44'),
(195,'App\\Models\\User',1,'authToken','4fdd30c8251341cdd1ac21924cee6cab56a04516540580a1e8fa6c439fe233fd','[\"*\"]','2025-04-25 01:59:39',NULL,'2025-04-25 01:38:38','2025-04-25 01:59:39'),
(196,'App\\Models\\User',1,'authToken','a1edd32b8b014dd6630932115840dfa4b76269c0472a00299048f1f1a76e2663','[\"*\"]','2025-04-25 02:16:43',NULL,'2025-04-25 02:15:20','2025-04-25 02:16:43'),
(197,'App\\Models\\User',1,'authToken','238888d3eafd391b43da809b5747a662ad8f9e4db67af8a7c2f4df2e972d99c4','[\"*\"]','2025-04-25 02:20:08',NULL,'2025-04-25 02:18:25','2025-04-25 02:20:08'),
(198,'App\\Models\\User',1,'authToken','2f0d745544b1c1821072b4c070e818526c48cfbd840135a6c558f8179812e6cb','[\"*\"]','2025-04-25 02:45:50',NULL,'2025-04-25 02:25:05','2025-04-25 02:45:50'),
(199,'App\\Models\\User',1,'authToken','c1c2ce5cf8c17411b048704295c289a595db1dceebe8a5ba123e351648fb61cb','[\"*\"]','2025-04-25 02:49:02',NULL,'2025-04-25 02:46:29','2025-04-25 02:49:02'),
(200,'App\\Models\\User',13,'authToken','b6f31ec0481914a3be8606b8f0e86ce0321f3baa3cfaf53fe2df056b39daf599','[\"*\"]','2025-04-25 02:58:15',NULL,'2025-04-25 02:56:25','2025-04-25 02:58:15'),
(201,'App\\Models\\User',5,'authToken','4f0a291a06a3af687034e99615605715fb404a0f61cd9c19be0adf67c4a12239','[\"*\"]',NULL,NULL,'2025-04-25 03:04:41','2025-04-25 03:04:41'),
(202,'App\\Models\\User',1,'authToken','f4991a8ab087fcf1706aeef2a6f464fc251294ff359550d851ed79dbddb8889f','[\"*\"]','2025-04-25 03:22:54',NULL,'2025-04-25 03:19:22','2025-04-25 03:22:54'),
(203,'App\\Models\\User',1,'authToken','5014ad0b92f0575dbced71228fa9b9c80342d96720d73af19c3312f72ffe39bf','[\"*\"]','2025-04-25 13:04:48',NULL,'2025-04-25 12:25:10','2025-04-25 13:04:48'),
(204,'App\\Models\\User',5,'authToken','dd4bfc438d8d06189dd81025bf6d6bed4c75ef594daddb6129a50050edeb649c','[\"*\"]',NULL,NULL,'2025-04-25 12:56:43','2025-04-25 12:56:43'),
(205,'App\\Models\\User',1,'authToken','c47cc17f8d2a4641fcfe03b01073497618b282a32c148bb6b9bb893ceba5c09b','[\"*\"]','2025-04-25 14:06:43',NULL,'2025-04-25 13:23:40','2025-04-25 14:06:43'),
(206,'App\\Models\\User',1,'authToken','e23802655c4d5fdf8ea19c1e4ec6ef58288d5d8e5142380ff0deef88272b460a','[\"*\"]','2025-04-25 14:22:36',NULL,'2025-04-25 14:07:13','2025-04-25 14:22:36'),
(207,'App\\Models\\User',1,'authToken','a07da953c39f02dbb445d1388a3bd47f413c9fc45d4ffd04badd837b566fffc6','[\"*\"]','2025-04-25 14:27:59',NULL,'2025-04-25 14:22:53','2025-04-25 14:27:59'),
(208,'App\\Models\\User',5,'authToken','8fd86e60388f2e90389f14d1a12d053ab9641f4ec15f89210da4c12f76cbffe0','[\"*\"]',NULL,NULL,'2025-04-25 22:04:30','2025-04-25 22:04:30'),
(209,'App\\Models\\User',5,'authToken','afa2e656fbc6d7994def3f1fe420271c63171fc5531d7111c30b545874006818','[\"*\"]','2025-04-26 09:22:48',NULL,'2025-04-25 23:18:16','2025-04-26 09:22:48'),
(210,'App\\Models\\User',5,'authToken','4a23717407a413feba39ba5746aad33476f9b2cd3b3aef26df19147d7423c75c','[\"*\"]',NULL,NULL,'2025-04-25 23:58:30','2025-04-25 23:58:30'),
(211,'App\\Models\\User',5,'authToken','70f10ffb4390f7d3c10e225569619f563442cf2bbd1d797d00ad28069fd65212','[\"*\"]','2025-04-28 13:57:12',NULL,'2025-04-26 09:23:41','2025-04-28 13:57:12'),
(212,'App\\Models\\User',5,'authToken','b5cd498701f1b7314bdd1ee415f8318405fa23eabb2d2973f09e734fabfac214','[\"*\"]',NULL,NULL,'2025-04-26 10:42:08','2025-04-26 10:42:08'),
(213,'App\\Models\\User',5,'authToken','dfa757ad47ee32d83b844e5a8d162ef9c5e1243f912e3593278b5261b77b4209','[\"*\"]',NULL,NULL,'2025-04-26 11:01:05','2025-04-26 11:01:05'),
(214,'App\\Models\\User',5,'authToken','d7f63cae305872c658d1e5930effc6c76d50e412be237c0563238f85c2f3f880','[\"*\"]','2025-04-26 11:16:24',NULL,'2025-04-26 11:16:21','2025-04-26 11:16:24'),
(215,'App\\Models\\User',1,'authToken','6e55428f1feb7ed5e9ee1b7d29871e216b67113fa118a36ec78805c9ab56653e','[\"*\"]','2025-04-26 13:54:03',NULL,'2025-04-26 13:48:33','2025-04-26 13:54:03'),
(216,'App\\Models\\User',1,'authToken','8f9d00606f5ea31a5fd5fc9bb69d182f5bff0da283074d062622934c50c5392d','[\"*\"]','2025-04-26 13:59:38',NULL,'2025-04-26 13:58:46','2025-04-26 13:59:38'),
(217,'App\\Models\\User',5,'authToken','a79a5a4787e17550d9fcab5d45f897e593664d1c85c8a2d0295578dd1f230797','[\"*\"]','2025-04-26 14:18:49',NULL,'2025-04-26 14:18:30','2025-04-26 14:18:49'),
(218,'App\\Models\\User',5,'authToken','26a6155d14c015d91c25d65f335c3ddbb7341379872656ce68a37edb463661ab','[\"*\"]','2025-04-26 15:01:22',NULL,'2025-04-26 14:20:45','2025-04-26 15:01:22'),
(219,'App\\Models\\User',5,'authToken','abccb57c191e94e3d779bc37fac6ab1e6a6ea43fdebfce57a02b4be9cf8a45aa','[\"*\"]','2025-05-09 15:38:37',NULL,'2025-04-26 14:30:51','2025-05-09 15:38:37'),
(220,'App\\Models\\User',1,'authToken','9fdf5013a021d94731fb4663c4ef3210d2f571c58af12981dc87fcbb9ed7156a','[\"*\"]','2025-04-26 15:09:54',NULL,'2025-04-26 14:36:00','2025-04-26 15:09:54'),
(221,'App\\Models\\User',5,'authToken','b49d06e53411e731406c55c1a2543124a6ae7d848298a3ec70726b0d182d2e2a','[\"*\"]','2025-04-26 15:18:42',NULL,'2025-04-26 15:17:35','2025-04-26 15:18:42'),
(222,'App\\Models\\User',1,'authToken','db0ddba02597ab3f2f472fbbf1b0cd295f3e2d2bdc20d28578a3616827f2a1c3','[\"*\"]','2025-04-26 15:19:38',NULL,'2025-04-26 15:19:33','2025-04-26 15:19:38'),
(223,'App\\Models\\User',5,'authToken','4bcf49cd37459e038eb825bd5c6bc66a6a44eed217975fa4d4531216ea1d9601','[\"*\"]','2025-04-26 16:05:44',NULL,'2025-04-26 15:20:51','2025-04-26 16:05:44'),
(224,'App\\Models\\User',1,'authToken','d7de82babf8ce78cde06ad71b4cd8b40efbca5cb3344cb00afc96d392f0cc121','[\"*\"]','2025-04-26 15:22:08',NULL,'2025-04-26 15:21:45','2025-04-26 15:22:08'),
(225,'App\\Models\\User',1,'authToken','e87b32bfeb440b8c72f412da77e21acbd6a99465c218b80d085b239038fc28a8','[\"*\"]','2025-04-26 15:58:12',NULL,'2025-04-26 15:30:49','2025-04-26 15:58:12'),
(226,'App\\Models\\User',5,'authToken','a069c91afff21b853d472b65668cb50b19cb42924d564c2f8b278e2f32b882ee','[\"*\"]','2025-04-26 17:00:14',NULL,'2025-04-26 16:06:57','2025-04-26 17:00:14'),
(227,'App\\Models\\User',1,'authToken','7f3b293f53e1a03a63ff818972745b47c3f52d23709f1f7f52a3eebc3216a220','[\"*\"]','2025-04-26 16:09:45',NULL,'2025-04-26 16:09:20','2025-04-26 16:09:45'),
(228,'App\\Models\\User',5,'authToken','258d63f1e7f0b84e7d94a1af47cd183932502b001257b208280026f5caecdb71','[\"*\"]','2025-04-26 17:05:58',NULL,'2025-04-26 17:01:37','2025-04-26 17:05:58'),
(229,'App\\Models\\User',5,'authToken','fb25c86c51518d57417485c0ecccaef6c1ffc08ae05e08711ced4f81a9eef8f6','[\"*\"]',NULL,NULL,'2025-04-26 17:55:08','2025-04-26 17:55:08'),
(230,'App\\Models\\User',5,'authToken','220e97a216ed93cd1d01c11888d8f1d2ec7f033568ff144af852c62258e63a50','[\"*\"]','2025-04-26 20:35:38',NULL,'2025-04-26 20:18:28','2025-04-26 20:35:38'),
(231,'App\\Models\\User',5,'authToken','df687d2b42db9e709893dc8a3fdc355ea196b4ebe0fb9bf03cda9380af4f801b','[\"*\"]','2025-05-01 10:05:25',NULL,'2025-04-26 20:28:02','2025-05-01 10:05:25'),
(232,'App\\Models\\User',5,'authToken','766853b774bb21c143df1ba9e50c9f540c70f81fbfb4d5ff502c6580c51a6969','[\"*\"]','2025-04-27 02:10:06',NULL,'2025-04-27 02:09:17','2025-04-27 02:10:06'),
(233,'App\\Models\\User',5,'authToken','977278bcb696431d36edece8ed74a6393112eeea15c3d9d200582d2f410e318e','[\"*\"]','2025-04-27 10:27:46',NULL,'2025-04-27 08:53:51','2025-04-27 10:27:46'),
(234,'App\\Models\\User',1,'authToken','899dad9040caeb2251c54c377d717848aa098097f39d5dc12e0139a24b76832b','[\"*\"]','2025-04-28 02:25:15',NULL,'2025-04-28 02:24:36','2025-04-28 02:25:15'),
(235,'App\\Models\\User',4,'authToken','38f8e3caa805a67b3df15a147a0533f9054905d8b64e228d8d4d05a0a28809df','[\"*\"]',NULL,NULL,'2025-04-28 02:27:13','2025-04-28 02:27:13'),
(236,'App\\Models\\User',5,'authToken','035d9a2bad4620db5b91ab8d8f56b342612f8ac05147b1e815caa83ca577637d','[\"*\"]','2025-04-28 03:27:06',NULL,'2025-04-28 03:20:36','2025-04-28 03:27:06'),
(237,'App\\Models\\User',5,'authToken','20b77a9e8d45968a843f8fc148af889f84a2f5357d6c140380f5624a91b62de0','[\"*\"]','2025-04-28 06:10:32',NULL,'2025-04-28 04:20:49','2025-04-28 06:10:32'),
(238,'App\\Models\\User',4,'authToken','adb9fad1f1e353a9e4f18cd96b1df42e37b4e06c18f0441005e88613174b5c20','[\"*\"]',NULL,NULL,'2025-04-28 06:21:48','2025-04-28 06:21:48'),
(239,'App\\Models\\User',1,'authToken','8dd3e907eb431f8e64207fc219fe4fa00c73da1b54b391fec15f299f874d8271','[\"*\"]','2025-04-28 06:22:29',NULL,'2025-04-28 06:22:18','2025-04-28 06:22:29'),
(240,'App\\Models\\User',1,'authToken','d33344cb1c0b87685c1262f35145cb1aa3664505c6b00b2af1f4ea3d5c142c15','[\"*\"]','2025-04-28 06:44:32',NULL,'2025-04-28 06:28:40','2025-04-28 06:44:32'),
(241,'App\\Models\\User',19,'authToken','682a1ac2685f373c7d147f6f763e5cb6063328744a69e8b9a758010c9a2f9c28','[\"*\"]',NULL,NULL,'2025-04-28 06:46:17','2025-04-28 06:46:17'),
(242,'App\\Models\\User',19,'authToken','39626cc3d1c3f8e72c9e9f218ea29d2e5b28a56ea7c81c269f19feb5f40ae903','[\"*\"]','2025-04-28 06:50:24',NULL,'2025-04-28 06:49:47','2025-04-28 06:50:24'),
(243,'App\\Models\\User',5,'authToken','4be6651e41d117cecb2b5f22d13c638031d9f37276ebc94b46e59326d363bb6a','[\"*\"]','2025-04-28 07:39:57',NULL,'2025-04-28 07:38:51','2025-04-28 07:39:57'),
(244,'App\\Models\\User',1,'authToken','d1c477fc7a6936793f5881d152707ea06bd3fe4c6a5cb2142e105f722107a074','[\"*\"]','2025-04-28 07:39:13',NULL,'2025-04-28 07:39:09','2025-04-28 07:39:13'),
(245,'App\\Models\\User',4,'authToken','962948537318a055daa86531b5c36c4878e08a743842cf40a163d194d8dfce0e','[\"*\"]','2025-04-28 10:41:25',NULL,'2025-04-28 10:39:53','2025-04-28 10:41:25'),
(246,'App\\Models\\User',1,'authToken','767e8bd2394cbf6995c3ad76acf956266d9738eac48caee3b6e9ca811cdd3a42','[\"*\"]','2025-04-28 10:54:21',NULL,'2025-04-28 10:43:02','2025-04-28 10:54:21'),
(247,'App\\Models\\User',1,'authToken','be34b4b7fac021f38764216d0753aee29a9364b3f173d57ac4033a983610e989','[\"*\"]','2025-04-28 11:14:36',NULL,'2025-04-28 11:05:45','2025-04-28 11:14:36'),
(248,'App\\Models\\User',1,'authToken','ce0136731770a420b1c8d01298e08b47081dfd3007ae57d8770b250e1c593a26','[\"*\"]','2025-04-28 14:10:23',NULL,'2025-04-28 12:57:54','2025-04-28 14:10:23'),
(249,'App\\Models\\User',1,'authToken','bb1307ec51a2bc7277c8b3855849ce20588b9af4d207117409ad718e9f31f6c8','[\"*\"]','2025-04-28 13:01:40',NULL,'2025-04-28 13:00:49','2025-04-28 13:01:40'),
(250,'App\\Models\\User',5,'authToken','9fe166d2175fc2ba58e80679c704f947d6851f691ed8201ed282d695b4e37e9f','[\"*\"]','2025-04-28 13:13:18',NULL,'2025-04-28 13:10:19','2025-04-28 13:13:18'),
(251,'App\\Models\\User',1,'authToken','e209170b5927a4fb2ff3cb9e204fd33b836fe95e1ad79f402ab23483c838bc7d','[\"*\"]','2025-04-28 13:33:12',NULL,'2025-04-28 13:31:09','2025-04-28 13:33:12'),
(252,'App\\Models\\User',5,'authToken','de0cebc2239021b1e573b8486556cc648ce35e22ee05e8409bef31cbfb71cfcc','[\"*\"]','2025-04-28 13:43:18',NULL,'2025-04-28 13:42:55','2025-04-28 13:43:18'),
(253,'App\\Models\\User',5,'authToken','83036bcb05f197a2c8c560cdbab4df5b402741c987032fda162e96f9febd45b6','[\"*\"]','2025-04-28 14:19:17',NULL,'2025-04-28 13:57:45','2025-04-28 14:19:17'),
(254,'App\\Models\\User',5,'authToken','00eb86cf413c10f8538deb8968d4b7145ee915cd9af1b0feb9aa96c4f0da3f03','[\"*\"]','2025-04-29 01:06:10',NULL,'2025-04-29 01:05:19','2025-04-29 01:06:10'),
(255,'App\\Models\\User',5,'authToken','8c43252262aeef41d51d78b5ae4a52011a7281f2c152f4738b784681df8a77b4','[\"*\"]',NULL,NULL,'2025-04-29 02:02:19','2025-04-29 02:02:19'),
(256,'App\\Models\\User',5,'authToken','a010b79fbec4416d57131e7e609f1481fa4ea1653062c10cacd1880bba849034','[\"*\"]','2025-04-29 02:30:46',NULL,'2025-04-29 02:30:14','2025-04-29 02:30:46'),
(257,'App\\Models\\User',5,'authToken','e27ea0c6690f9a7fc1000be2e7c9f7a125e99320d414bfcec61944787bd7ced8','[\"*\"]','2025-04-29 02:37:20',NULL,'2025-04-29 02:36:52','2025-04-29 02:37:20'),
(258,'App\\Models\\User',5,'authToken','f02e1d18167aefc1d28f1de20a3e931a7edc377f2a94a016010854b3f3d2aaf7','[\"*\"]','2025-04-29 02:59:08',NULL,'2025-04-29 02:58:42','2025-04-29 02:59:08'),
(259,'App\\Models\\User',5,'authToken','53c0b08f9a2a3b2a09a549c6c800dceccdc0e04153e6bdb222f7051f9aaf31f9','[\"*\"]','2025-04-29 03:56:43',NULL,'2025-04-29 03:56:10','2025-04-29 03:56:43'),
(260,'App\\Models\\User',5,'authToken','2428dcda7acbb78dd6855daf5d103bbe78e6b7caa8feabaa9ca0d94fd05e26a8','[\"*\"]','2025-04-29 04:02:42',NULL,'2025-04-29 04:02:18','2025-04-29 04:02:42'),
(261,'App\\Models\\User',5,'authToken','298f772a2adf105faa339d7166fbb7aa89484bb0e28c0af6c9f857a0b916ad91','[\"*\"]','2025-04-29 04:11:08',NULL,'2025-04-29 04:10:40','2025-04-29 04:11:08'),
(262,'App\\Models\\User',1,'authToken','1ced125c958577761a778f18d20466d092d898bacfe4f9706c069b12702f0224','[\"*\"]','2025-04-29 07:31:56',NULL,'2025-04-29 07:02:21','2025-04-29 07:31:56'),
(263,'App\\Models\\User',5,'authToken','4289c614b322778f017ed8acd52216d07dd63e81d285396bffe666dcdf9bee61','[\"*\"]','2025-04-29 07:56:04',NULL,'2025-04-29 07:55:06','2025-04-29 07:56:04'),
(264,'App\\Models\\User',5,'authToken','3e8d54a83cb67eb74e557f14958fc40d0b627deefc98e8695e5635ae533d374a','[\"*\"]','2025-04-29 08:17:04',NULL,'2025-04-29 08:16:25','2025-04-29 08:17:04'),
(265,'App\\Models\\User',1,'authToken','5bd57b04ee01fcd08c7b1a200dcdeb668d932eebb0d550dbef2ca4119fe2c137','[\"*\"]','2025-04-29 08:41:27',NULL,'2025-04-29 08:40:10','2025-04-29 08:41:27'),
(266,'App\\Models\\User',1,'authToken','5f9ed0bfdea6cf474d6102ea3a4fc116e3023e2f2e4b3a81906f4743049fba46','[\"*\"]','2025-04-29 08:49:44',NULL,'2025-04-29 08:49:03','2025-04-29 08:49:44'),
(267,'App\\Models\\User',1,'authToken','a100b0f2b0ab78e21bb8c13b5f9322e9f12beef023aefe944ad8d337e10f5cc7','[\"*\"]','2025-04-29 09:24:58',NULL,'2025-04-29 09:18:59','2025-04-29 09:24:58'),
(268,'App\\Models\\User',1,'authToken','76f5ad04b259176f2ca39ad7aacae73e6c05038439cd9d947c97236ad422e95f','[\"*\"]','2025-04-29 09:35:31',NULL,'2025-04-29 09:30:57','2025-04-29 09:35:31'),
(269,'App\\Models\\User',5,'authToken','e09eadbee7b3e063e2addbb872275223454e387f9900e16593e0eca5aeb542c2','[\"*\"]','2025-04-29 09:51:07',NULL,'2025-04-29 09:35:57','2025-04-29 09:51:07'),
(270,'App\\Models\\User',1,'authToken','865ab6f5563d03de8a4e39d7b9208b154ed2bd7526a8c4d156501b039aa94eec','[\"*\"]','2025-04-29 09:52:57',NULL,'2025-04-29 09:51:34','2025-04-29 09:52:57'),
(271,'App\\Models\\User',5,'authToken','37ca63fbfd78c46381ee19018084307eb40ab6f8b1b7342adbbb8c3de8d95cf1','[\"*\"]','2025-04-29 09:55:39',NULL,'2025-04-29 09:55:18','2025-04-29 09:55:39'),
(272,'App\\Models\\User',1,'authToken','a7e21e4097c49c08717e7c5bff7ed5e8dca42a38bc32e8618a5df1ed51c7bcf7','[\"*\"]','2025-04-29 13:12:15',NULL,'2025-04-29 13:10:45','2025-04-29 13:12:15'),
(273,'App\\Models\\User',1,'authToken','00e971fe90fd543735ac975456c189ae62af30dc5395970e904979f82948b269','[\"*\"]','2025-04-29 13:22:37',NULL,'2025-04-29 13:14:54','2025-04-29 13:22:37'),
(274,'App\\Models\\User',1,'authToken','4076e696c46c3df529370a883ce8739db4234cd7fa5f016fd299f8b7a7c95dea','[\"*\"]','2025-04-29 13:51:31',NULL,'2025-04-29 13:50:33','2025-04-29 13:51:31'),
(275,'App\\Models\\User',1,'authToken','1ce022bbc0d0d50042fafff777c03ddbe8527840e1baea63fed0be6de83c1fb0','[\"*\"]','2025-04-29 13:58:10',NULL,'2025-04-29 13:55:20','2025-04-29 13:58:10'),
(276,'App\\Models\\User',5,'authToken','ea32258e0918b4aa31d66a1e9a7e522c2795671317e949cf993ae8413aefc9c4','[\"*\"]','2025-04-29 14:16:56',NULL,'2025-04-29 14:13:31','2025-04-29 14:16:56'),
(277,'App\\Models\\User',1,'authToken','3433b8042805edbda45b56746d0edcffd76a29ac563cbfd3328162e4d5ecfc2b','[\"*\"]','2025-04-30 01:12:19',NULL,'2025-04-30 01:11:47','2025-04-30 01:12:19'),
(278,'App\\Models\\User',1,'authToken','431d1b2bb6b88aee45540211d04359dd96f64b0c2cde4a9e7c405fb332e3d9e3','[\"*\"]','2025-04-30 01:38:02',NULL,'2025-04-30 01:16:58','2025-04-30 01:38:02'),
(279,'App\\Models\\User',5,'authToken','04b146ad8abd50894819f04c9ccc5408d97abce9d96c2ee615eb343a4c7a5d60','[\"*\"]','2025-04-30 03:40:30',NULL,'2025-04-30 01:43:51','2025-04-30 03:40:30'),
(280,'App\\Models\\User',1,'authToken','bd40f443f9d992da4d4290a7221b3d9ae145217b0a3ecc8454ce2cc2cfb8e931','[\"*\"]','2025-04-30 02:21:12',NULL,'2025-04-30 02:07:16','2025-04-30 02:21:12'),
(281,'App\\Models\\User',4,'authToken','8f5cb5cd73b64168c4dcb28ff0b03dd1d5896ec1596c14b9adacbe4dd48fe75d','[\"*\"]','2025-04-30 02:22:50',NULL,'2025-04-30 02:22:16','2025-04-30 02:22:50'),
(282,'App\\Models\\User',4,'authToken','3d39e71a2bf9f6617cebecfb2eedd13b29ae30d0fb63d2c911ecf3a279c4a8f0','[\"*\"]','2025-04-30 02:25:39',NULL,'2025-04-30 02:25:13','2025-04-30 02:25:39'),
(283,'App\\Models\\User',1,'authToken','12ff68699e4572ce12103a0a9a10322e2b8a890f4cc226e6022401d9c75f7612','[\"*\"]','2025-04-30 04:25:09',NULL,'2025-04-30 04:17:41','2025-04-30 04:25:09'),
(284,'App\\Models\\User',1,'authToken','5585eea45dfc90c721345f1bb3aa89afbba5194261e7463d8f882e030839e8d0','[\"*\"]','2025-04-30 04:32:01',NULL,'2025-04-30 04:31:10','2025-04-30 04:32:01'),
(285,'App\\Models\\User',1,'authToken','a362932d38b3ec81801284820df18e58f2568620fc88835623a26134d8665ebb','[\"*\"]','2025-04-30 04:35:25',NULL,'2025-04-30 04:34:16','2025-04-30 04:35:25'),
(286,'App\\Models\\User',5,'authToken','b2851844582c4e8da7b071fa6e818293b00e0379e2c5b282ac2f85e77692d573','[\"*\"]','2025-04-30 04:38:48',NULL,'2025-04-30 04:38:07','2025-04-30 04:38:48'),
(287,'App\\Models\\User',5,'authToken','d87d87358b53ec256d88d3c46905b971815af22c5a5b8e8298639b3c94848676','[\"*\"]','2025-04-30 08:25:14',NULL,'2025-04-30 08:12:37','2025-04-30 08:25:14'),
(288,'App\\Models\\User',1,'authToken','05b0eb8ae39264ea364a16ae8cd32e1aac6dd5ebf15098fea33fca00f5643942','[\"*\"]','2025-04-30 08:57:55',NULL,'2025-04-30 08:50:23','2025-04-30 08:57:55'),
(289,'App\\Models\\User',1,'authToken','28276ca8bbd5840d115882decc53aec291e63f609081e6313ff12fce7b7b2f74','[\"*\"]','2025-04-30 09:47:57',NULL,'2025-04-30 09:03:19','2025-04-30 09:47:57'),
(290,'App\\Models\\User',1,'authToken','9809559376cc013ef841861fdc3696390eeb66418a8af2630e88fb53f4ab1763','[\"*\"]','2025-04-30 09:30:17',NULL,'2025-04-30 09:19:10','2025-04-30 09:30:17'),
(291,'App\\Models\\User',5,'authToken','e48fdaf3f99efaf27b91b0d762a97df3f832a4be134218367eaa7a3df9a04933','[\"*\"]','2025-04-30 09:51:43',NULL,'2025-04-30 09:31:44','2025-04-30 09:51:43'),
(292,'App\\Models\\User',1,'authToken','a08fec2b0845bf11d8946f69e5527a291848c8f3a25e7fbd77c006fbf84613ba','[\"*\"]','2025-04-30 10:04:04',NULL,'2025-04-30 09:58:55','2025-04-30 10:04:04'),
(293,'App\\Models\\User',1,'authToken','ab57f9e502987a0f2ad96a30c3b658d9c0ff92c8ff0271d948175c36a9865a18','[\"*\"]','2025-04-30 10:05:37',NULL,'2025-04-30 10:05:11','2025-04-30 10:05:37'),
(294,'App\\Models\\User',5,'authToken','463e4c220a6ba90c0993e808a216234ae5103694e63dcb148951d4f8ec19d175','[\"*\"]','2025-04-30 10:07:16',NULL,'2025-04-30 10:05:57','2025-04-30 10:07:16'),
(295,'App\\Models\\User',1,'authToken','3302f2b14eedb34ec81a4602ced3a76cc76ca72884d95a2d306213f2043c82f8','[\"*\"]','2025-04-30 10:23:40',NULL,'2025-04-30 10:23:24','2025-04-30 10:23:40'),
(296,'App\\Models\\User',1,'authToken','3a711a2905f02651bca447e109dd08616e75e5af63bf00c5ffd73ae5758e366c','[\"*\"]','2025-04-30 10:45:14',NULL,'2025-04-30 10:32:20','2025-04-30 10:45:14'),
(297,'App\\Models\\User',5,'authToken','dc996a3e40a3a8dfa27de34d26e1ffa8360c7789956c6973224877a26f650cd5','[\"*\"]','2025-04-30 10:55:49',NULL,'2025-04-30 10:38:24','2025-04-30 10:55:49'),
(298,'App\\Models\\User',1,'authToken','34aad71e9c9457482aef23766e69fc931f60a0858d546cc119d320af123ab92f','[\"*\"]','2025-04-30 10:58:14',NULL,'2025-04-30 10:58:03','2025-04-30 10:58:14'),
(299,'App\\Models\\User',5,'authToken','320c5716591d64a8e1b6e5eaef462faffe2b7f17bff6a996f1a41e3bb3382090','[\"*\"]','2025-04-30 14:02:19',NULL,'2025-04-30 14:02:02','2025-04-30 14:02:19'),
(300,'App\\Models\\User',4,'authToken','f15b00b736dcd3134580b980527f3f8e74e5be163327d02ca744e69f936b37cb','[\"*\"]','2025-04-30 14:14:49',NULL,'2025-04-30 14:14:24','2025-04-30 14:14:49'),
(301,'App\\Models\\User',1,'authToken','56dfb998cbfe7d43879b60ecff52ba99b1ba72dad1f79db10ce714c7ec641a87','[\"*\"]','2025-04-30 14:21:25',NULL,'2025-04-30 14:19:22','2025-04-30 14:21:25'),
(302,'App\\Models\\User',5,'authToken','b4d1784fa1e414d0da9b7ecd1491119f5e9ff21da7b117884aede8dc78aaeb6b','[\"*\"]','2025-04-30 19:53:00',NULL,'2025-04-30 14:48:51','2025-04-30 19:53:00'),
(303,'App\\Models\\User',1,'authToken','da652da62cbb0a7f8630cd59c7ff16e2153716a84abe5fa54f9a3ab5ebe3672d','[\"*\"]','2025-04-30 15:16:43',NULL,'2025-04-30 15:06:21','2025-04-30 15:16:43'),
(304,'App\\Models\\User',1,'authToken','b42e8f4cc3b861f544c4db55f4c43cc69d6af217bc56cc4c18ef6456d49066c1','[\"*\"]','2025-04-30 15:47:50',NULL,'2025-04-30 15:08:40','2025-04-30 15:47:50'),
(305,'App\\Models\\User',1,'authToken','17607aa0fcc9ebc3a6337f60ff43093c188d845ceb2c8a93690da324585490ec','[\"*\"]','2025-04-30 15:57:22',NULL,'2025-04-30 15:49:47','2025-04-30 15:57:22'),
(306,'App\\Models\\User',1,'authToken','5d4ac6fb4ab873767c328318503094aeaaccdb7924d31fad776741e8adb5790e','[\"*\"]','2025-04-30 16:28:15',NULL,'2025-04-30 15:53:40','2025-04-30 16:28:15'),
(307,'App\\Models\\User',1,'authToken','f1639682ba623a1a67e37bbe639f5d96a11a5e56c1f2f67a27e98ce5b8be8fd8','[\"*\"]','2025-04-30 16:15:57',NULL,'2025-04-30 16:02:08','2025-04-30 16:15:57'),
(308,'App\\Models\\User',4,'authToken','d02ff2e1112218413a69b9fcc663790b1cf93fc88bdf64422c695bd2887645a4','[\"*\"]','2025-04-30 16:27:00',NULL,'2025-04-30 16:24:40','2025-04-30 16:27:00'),
(309,'App\\Models\\User',1,'authToken','2cf4a27d9da469bebcdcfcacfe1f795e3287f8724e04e29abf0843dae74eddea','[\"*\"]','2025-04-30 16:29:39',NULL,'2025-04-30 16:29:28','2025-04-30 16:29:39'),
(310,'App\\Models\\User',5,'authToken','444ebbcea78b3c4795d068ccfe4eb4d7b833ea90fe94e8eab6a16e39ca6e920b','[\"*\"]','2025-04-30 19:47:07',NULL,'2025-04-30 18:42:40','2025-04-30 19:47:07'),
(311,'App\\Models\\User',5,'authToken','3534620138319df20e8ac55cf8447a04c6cb0dd2d42dc1c3fcc181ff03717298','[\"*\"]','2025-04-30 20:09:10',NULL,'2025-04-30 20:08:45','2025-04-30 20:09:10'),
(312,'App\\Models\\User',4,'authToken','475da08072c2a6a74e08f3d18b7eb0082a7c6500de89ae75df160c42e4f59ecc','[\"*\"]','2025-04-30 20:15:40',NULL,'2025-04-30 20:15:08','2025-04-30 20:15:40'),
(313,'App\\Models\\User',4,'authToken','1cee4192010951f6e7bbcf931e8026def4dd154864013d903bffd7741d825ec5','[\"*\"]','2025-04-30 20:27:29',NULL,'2025-04-30 20:27:03','2025-04-30 20:27:29'),
(314,'App\\Models\\User',5,'authToken','9407582720130786706e45f8fe24706e768fe18aed6d5b420093c4889f2c9828','[\"*\"]','2025-04-30 20:45:49',NULL,'2025-04-30 20:45:18','2025-04-30 20:45:49'),
(315,'App\\Models\\User',1,'authToken','b0b01aa7037dc1cf84bf40797ff5aba13b932847b8b534a869bd9eb501e3efab','[\"*\"]','2025-05-01 09:14:35',NULL,'2025-05-01 09:14:26','2025-05-01 09:14:35'),
(316,'App\\Models\\User',5,'authToken','6fbc9e4276cdc47e66e2c15abbeb54448fb6f9d62345839876fb40ca4fa0dd97','[\"*\"]','2025-05-01 10:37:43',NULL,'2025-05-01 09:15:40','2025-05-01 10:37:43'),
(317,'App\\Models\\User',1,'authToken','5ca9f5983918bd7f71ce3a871a87ea4ef647f6aa51838337329c4618555051c4','[\"*\"]','2025-05-01 10:58:07',NULL,'2025-05-01 10:56:26','2025-05-01 10:58:07'),
(318,'App\\Models\\User',1,'authToken','f7dc209bf18e6ee28db181e3db994f50d6b3fd0de149ab5334c20ed6de559ece','[\"*\"]','2025-05-01 11:17:27',NULL,'2025-05-01 10:58:23','2025-05-01 11:17:27'),
(319,'App\\Models\\User',1,'authToken','76391e71811f12e2102525f43d3559399d3b129c81a9e43825e6ea7cdd754bcf','[\"*\"]','2025-05-01 14:22:10',NULL,'2025-05-01 13:58:07','2025-05-01 14:22:10'),
(320,'App\\Models\\User',1,'authToken','7d5d21805184b3b6da5089b578841ffa85942024f22b98548fed40a630daa053','[\"*\"]','2025-05-01 14:26:15',NULL,'2025-05-01 14:25:48','2025-05-01 14:26:15'),
(321,'App\\Models\\User',5,'authToken','68ea928d91df24df0ea1f68ff6b80b3b750331d51e8404746990f37b0c124f22','[\"*\"]','2025-05-01 23:01:41',NULL,'2025-05-01 23:00:52','2025-05-01 23:01:41'),
(322,'App\\Models\\User',1,'authToken','be8c1191798d302726455311cae2bffb0854c34b0f4f64a8347d2898b50d9827','[\"*\"]','2025-05-02 02:02:37',NULL,'2025-05-02 01:57:11','2025-05-02 02:02:37'),
(323,'App\\Models\\User',1,'authToken','2b098322011abf26803bc5ba05cfb4c0f06519b28b47113d82469cc76466613e','[\"*\"]','2025-05-02 02:14:09',NULL,'2025-05-02 02:13:34','2025-05-02 02:14:09'),
(324,'App\\Models\\User',1,'authToken','01d1075adad44c4744634e07e9d282bbb3d5b8b9db31e315fab9c30e0b59a9c4','[\"*\"]','2025-05-02 02:15:34',NULL,'2025-05-02 02:14:52','2025-05-02 02:15:34'),
(325,'App\\Models\\User',1,'authToken','764295d162fd21dfcaecc57c965a830cf456382fad0a7f33aa05ba0e88d9bd92','[\"*\"]','2025-05-02 02:32:01',NULL,'2025-05-02 02:26:35','2025-05-02 02:32:01'),
(326,'App\\Models\\User',1,'authToken','c958e70ed3da3c7c58b8e7be22a1913716c50b05ca73b8222a0a01d62655ca37','[\"*\"]','2025-05-02 02:32:54',NULL,'2025-05-02 02:32:45','2025-05-02 02:32:54'),
(327,'App\\Models\\User',1,'authToken','a68ed6aa793e029e011c94cc4d734cfe288600c0e3b9a3d2d567f60551c71918','[\"*\"]','2025-05-02 02:37:07',NULL,'2025-05-02 02:33:26','2025-05-02 02:37:07'),
(328,'App\\Models\\User',1,'authToken','5c0fea7f37bb77d41cebea99e42cd21272eb258a09779a6fb01c3d82edf3fb85','[\"*\"]','2025-05-02 02:40:40',NULL,'2025-05-02 02:37:46','2025-05-02 02:40:40'),
(329,'App\\Models\\User',1,'authToken','135895fed1bc9dc0d2a95acb0df3a2fa51d3ddf34dd55ba4ee6d6d7c8dae2a94','[\"*\"]','2025-05-02 02:58:47',NULL,'2025-05-02 02:41:29','2025-05-02 02:58:47'),
(330,'App\\Models\\User',1,'authToken','4add0f0fa5e5ca34530dd39ed451159a1f2e5e29157ff6528043b5d33b10c639','[\"*\"]','2025-05-02 02:59:21',NULL,'2025-05-02 02:48:28','2025-05-02 02:59:21'),
(331,'App\\Models\\User',1,'authToken','88a8d194dfd97f6a43fda009cc1b9c5c991943816b868e2fd31d1db6a10cc0f4','[\"*\"]','2025-05-02 02:59:11',NULL,'2025-05-02 02:59:02','2025-05-02 02:59:11'),
(332,'App\\Models\\User',1,'authToken','2d5386f7f121870ce12f92e3673e8c8816757b582b264a518af909cae586cddd','[\"*\"]','2025-05-02 03:01:42',NULL,'2025-05-02 03:01:27','2025-05-02 03:01:42'),
(333,'App\\Models\\User',1,'authToken','bc41662cbb6e524938cac44b75d13fa0cf8b548fabc6bdde7882966e7a9c414a','[\"*\"]','2025-05-02 03:09:18',NULL,'2025-05-02 03:09:12','2025-05-02 03:09:18'),
(334,'App\\Models\\User',1,'authToken','e6934a731a5e6136705e989f68275237b2415b36196f3a64fa5f8aa0e7c4f441','[\"*\"]','2025-05-02 03:18:37',NULL,'2025-05-02 03:18:15','2025-05-02 03:18:37'),
(335,'App\\Models\\User',1,'authToken','df2022f3222761b6c79c1877f18e740fd7eccbe854fd952013cc8e5dc9e74263','[\"*\"]','2025-05-02 04:32:17',NULL,'2025-05-02 04:30:35','2025-05-02 04:32:17'),
(336,'App\\Models\\User',1,'authToken','0bf9683f3e33f2ee21c24675539251a4d5b3badcf577df85ca0d63306a9b64df','[\"*\"]','2025-05-02 00:24:04',NULL,'2025-05-02 00:22:25','2025-05-02 00:24:04'),
(337,'App\\Models\\User',5,'authToken','d5ff3c93b545139767ad0f278500130056dc234c6e7edd995e95e05eb2ff1988','[\"*\"]','2025-05-02 12:59:48',NULL,'2025-05-02 12:38:14','2025-05-02 12:59:48'),
(338,'App\\Models\\User',5,'authToken','286a1795cc03a3d70292d7c811f62df9634c64b8cc216d1ac7e13b888e40e810','[\"*\"]','2025-05-02 13:29:58',NULL,'2025-05-02 13:00:12','2025-05-02 13:29:58'),
(339,'App\\Models\\User',5,'authToken','1e29aa00ac254be78132898c05a189f113fd117d9f2c393c799fe43752e15a81','[\"*\"]','2025-05-03 16:06:05',NULL,'2025-05-02 14:27:10','2025-05-03 16:06:05'),
(340,'App\\Models\\User',1,'authToken','2f02b254c297279e8de20cb7ca801393ab027150498ee99c28977074b118635e','[\"*\"]','2025-05-02 16:29:21',NULL,'2025-05-02 16:05:39','2025-05-02 16:29:21'),
(341,'App\\Models\\User',1,'authToken','0c9f0d3432f18d09ba1b9ba5f4ca9cb622be619c23aa08caf4f14b69a8894054','[\"*\"]','2025-05-03 02:55:15',NULL,'2025-05-03 02:36:37','2025-05-03 02:55:15'),
(342,'App\\Models\\User',5,'authToken','59f6af931afeea1500fef86a914cf779695088b05886d4a918dd977d1dd63cd9','[\"*\"]','2025-05-03 04:06:12',NULL,'2025-05-03 02:37:36','2025-05-03 04:06:12'),
(343,'App\\Models\\User',1,'authToken','4d0131fe81e829d46b33e4a31f1fb70e8c31fe295c938d2adf6e708d09a62979','[\"*\"]','2025-05-03 03:00:29',NULL,'2025-05-03 02:57:54','2025-05-03 03:00:29'),
(344,'App\\Models\\User',1,'authToken','248a4eb3f4809ba092f49978c36226a610b8a949e7b38146274ca0eb581e6c17','[\"*\"]','2025-05-03 03:13:54',NULL,'2025-05-03 03:08:50','2025-05-03 03:13:54'),
(345,'App\\Models\\User',1,'authToken','14bc7567605fed9069a66d76086f15170c162e11f0f7e5a6c47e27446e9efde4','[\"*\"]','2025-05-03 03:27:12',NULL,'2025-05-03 03:18:05','2025-05-03 03:27:12'),
(346,'App\\Models\\User',1,'authToken','25df5a9ea14bc86886533415b1c9f7749031bc23a397351f5d2302311532390e','[\"*\"]','2025-05-03 03:40:41',NULL,'2025-05-03 03:27:26','2025-05-03 03:40:41'),
(347,'App\\Models\\User',1,'authToken','1c2940818f8eb42fa17caac6237e13c3e0d25510c5b74a5087d1de0bc801b6f2','[\"*\"]','2025-05-03 03:43:03',NULL,'2025-05-03 03:41:06','2025-05-03 03:43:03'),
(348,'App\\Models\\User',1,'authToken','d58f834662c184894457267abecd5297836e2a5bb68b3e8046e0963b973b1e80','[\"*\"]','2025-05-03 03:47:42',NULL,'2025-05-03 03:45:25','2025-05-03 03:47:42'),
(349,'App\\Models\\User',1,'authToken','bdf354ebec07031c85644e512a89a9e5083aefbb633e864e167aff1dce89ecc1','[\"*\"]','2025-05-03 03:50:43',NULL,'2025-05-03 03:49:20','2025-05-03 03:50:43'),
(350,'App\\Models\\User',1,'authToken','c5802166b4a2fe7216fe4578fa9bddd930d8b9a906d38a777d26008c259a910c','[\"*\"]','2025-05-03 03:52:43',NULL,'2025-05-03 03:52:41','2025-05-03 03:52:43'),
(351,'App\\Models\\User',1,'authToken','f346e1aeed14c4fc18eaed9f4652fe101f699564807ee642d53090c76d8b306b','[\"*\"]','2025-05-03 03:56:57',NULL,'2025-05-03 03:56:02','2025-05-03 03:56:57'),
(352,'App\\Models\\User',1,'authToken','29d632d72945bea9e0ce8bf878abf9f300a23dbd8824e5c067a3c655cba66dd0','[\"*\"]','2025-05-03 03:57:27',NULL,'2025-05-03 03:57:24','2025-05-03 03:57:27'),
(353,'App\\Models\\User',1,'authToken','3cc829ab65ddc4d64ea6cc4d50ab1b7356b5454baee3e96df09c7b566cf296de','[\"*\"]','2025-05-03 03:58:06',NULL,'2025-05-03 03:58:04','2025-05-03 03:58:06'),
(354,'App\\Models\\User',1,'authToken','2734a268f8f727076a11cd7bc8d657b5e06fa82d751b2e59ba5d5ba05ac48b1a','[\"*\"]','2025-05-03 03:59:14',NULL,'2025-05-03 03:58:55','2025-05-03 03:59:14'),
(355,'App\\Models\\User',1,'authToken','041af4f98a13ca202d378d88ae0f2d62a1d79d1ec1ab1c87d7be3789d8610746','[\"*\"]','2025-05-03 04:00:21',NULL,'2025-05-03 04:00:18','2025-05-03 04:00:21'),
(356,'App\\Models\\User',1,'authToken','335ab40ca82a2f871909b366d32d156139bcdf6caa2c9db219c179bd7207aefd','[\"*\"]','2025-05-03 04:01:58',NULL,'2025-05-03 04:01:41','2025-05-03 04:01:58'),
(357,'App\\Models\\User',1,'authToken','cc0b9a8ec1f8529eca5be46f95c15232a88d0dc49f365d7070043da7dda56e45','[\"*\"]','2025-05-03 04:07:03',NULL,'2025-05-03 04:05:44','2025-05-03 04:07:03'),
(358,'App\\Models\\User',4,'authToken','a4975a3d1fdf9863c1823acdcb99774a7960a02e0a3e9ff25d9c23818a90182f','[\"*\"]','2025-05-03 04:09:47',NULL,'2025-05-03 04:07:19','2025-05-03 04:09:47'),
(359,'App\\Models\\User',1,'authToken','971f814eedb80c92ec4ee5d5982b09e185602f14d5626a1c2fc797ed26d7dcf2','[\"*\"]','2025-05-03 04:10:20',NULL,'2025-05-03 04:10:00','2025-05-03 04:10:20'),
(360,'App\\Models\\User',1,'authToken','1fb7c8be4c1cec83161ce60a0460d7b8d6dea1b4125fad09d51f091213615119','[\"*\"]','2025-05-03 04:25:01',NULL,'2025-05-03 04:11:21','2025-05-03 04:25:01'),
(361,'App\\Models\\User',5,'authToken','e9c3a7b869b5edcdc1ca3e870348fa16b107a104be4ea83d70c91ff0591f603a','[\"*\"]','2025-05-03 04:17:09',NULL,'2025-05-03 04:16:44','2025-05-03 04:17:09'),
(362,'App\\Models\\User',1,'authToken','5f52004eb9a6de534099dabf00a6555be426860e094281ac22ebae0df8ed9815','[\"*\"]','2025-05-03 04:41:36',NULL,'2025-05-03 04:41:25','2025-05-03 04:41:36'),
(363,'App\\Models\\User',4,'authToken','e0bf2d8559f3a15b03e3466aa2aa1d9e1ecfe854e37ba061d293394c46afbe67','[\"*\"]','2025-05-03 09:38:10',NULL,'2025-05-03 09:33:46','2025-05-03 09:38:10'),
(364,'App\\Models\\User',1,'authToken','892b280e488f5d875b3ea309bdcb20846b0520c79dfd72294d938d086c9e1daf','[\"*\"]','2025-05-03 09:42:45',NULL,'2025-05-03 09:41:59','2025-05-03 09:42:45'),
(365,'App\\Models\\User',1,'authToken','f38ce9374e0f76d6031cd6f35d5cee33bb6c771ab2179c9c98a1ceb462a07afa','[\"*\"]','2025-05-03 10:09:44',NULL,'2025-05-03 10:08:44','2025-05-03 10:09:44'),
(366,'App\\Models\\User',1,'authToken','6bffe80bb027450b06b9c671c62a8125cb7f14604d3ab61eacab478a35b0d8ba','[\"*\"]','2025-05-03 10:25:15',NULL,'2025-05-03 10:13:13','2025-05-03 10:25:15'),
(367,'App\\Models\\User',4,'authToken','58c319b8efc1198743804ef194bb1b3f2e88596e26b37f72c1f0da18f5534d80','[\"*\"]','2025-05-03 10:28:51',NULL,'2025-05-03 10:25:47','2025-05-03 10:28:51'),
(368,'App\\Models\\User',4,'authToken','aaa2ed517f390d13a3622a0b8f357e7f246a8121863f3939ce2139479798235d','[\"*\"]','2025-05-03 10:46:31',NULL,'2025-05-03 10:44:07','2025-05-03 10:46:31'),
(369,'App\\Models\\User',5,'authToken','cf21b034579766a1855bd3c8e5b7451af5599fc3c6de407302a512615dcf47bc','[\"*\"]','2025-05-03 15:39:57',NULL,'2025-05-03 15:14:49','2025-05-03 15:39:57'),
(370,'App\\Models\\User',5,'authToken','f72a8a93a1e538a28c847175b280cf02d8ea8c457d0325443a0cd21e710e0475','[\"*\"]','2025-05-03 15:25:02',NULL,'2025-05-03 15:19:06','2025-05-03 15:25:02'),
(371,'App\\Models\\User',4,'authToken','c1c1462b58cafe6accac09614ad6d4dfe3fbae34ccb342bc548e70f9a09f9b9b','[\"*\"]','2025-05-03 15:44:08',NULL,'2025-05-03 15:30:17','2025-05-03 15:44:08'),
(372,'App\\Models\\User',21,'authToken','9ddaa23b67a4068b5a1fbdb9b1ca8eb3b94e32c620db06d0b5a0d35db9b908c1','[\"*\"]',NULL,NULL,'2025-05-03 15:45:21','2025-05-03 15:45:21'),
(373,'App\\Models\\User',21,'authToken','cadaab96873f89eb529ea66a2f7b3f5d15d237ca851380fd2d59c10f53b3a895','[\"*\"]','2025-05-03 15:50:11',NULL,'2025-05-03 15:45:53','2025-05-03 15:50:11'),
(374,'App\\Models\\User',23,'authToken','d4d4c28d52d7bb488610323b5fb6567a8e3461578ee1cb54bb66e26aaa70aed8','[\"*\"]',NULL,NULL,'2025-05-03 15:54:19','2025-05-03 15:54:19'),
(375,'App\\Models\\User',23,'authToken','c0ae00788197b0e2b88192fe871a778780989e49b25b0b754710f2a33775ec10','[\"*\"]','2025-05-03 15:56:46',NULL,'2025-05-03 15:54:54','2025-05-03 15:56:46'),
(376,'App\\Models\\User',5,'authToken','1de48108871fef22d6c2668fc167890a5b495ee28568c192492f4d1e800710c6','[\"*\"]','2025-05-03 16:53:29',NULL,'2025-05-03 16:06:17','2025-05-03 16:53:29'),
(377,'App\\Models\\User',5,'authToken','ddc1a68db4985044f4ba9563f42950ed994a6ac45b1516806f5c3c21f4413ef9','[\"*\"]',NULL,NULL,'2025-05-03 16:41:32','2025-05-03 16:41:32'),
(378,'App\\Models\\User',5,'authToken','5eb00ad709025d652d3ad80282cc894ca846da4cd7da78b0d724c949dfb2f3a1','[\"*\"]','2025-05-03 17:41:16',NULL,'2025-05-03 17:28:41','2025-05-03 17:41:16'),
(379,'App\\Models\\User',5,'authToken','24846350860effce6e69c10a89e9f24b7d349f055a76d3d69c0fa92c8d059023','[\"*\"]','2025-05-03 23:45:59',NULL,'2025-05-03 23:38:39','2025-05-03 23:45:59'),
(380,'App\\Models\\User',5,'authToken','4cdbb50837fece5a222fb341da1518433497a3608c24466108c18fc36b4d401f','[\"*\"]','2025-05-03 23:48:29',NULL,'2025-05-03 23:47:04','2025-05-03 23:48:29'),
(381,'App\\Models\\User',5,'authToken','b9e07bed5eb3573ef567000b1e5cb028c5b5eff2e8043d64d94d5ad06cad7dbf','[\"*\"]','2025-05-04 00:09:47',NULL,'2025-05-03 23:58:03','2025-05-04 00:09:47'),
(382,'App\\Models\\User',5,'authToken','87ec482623dc8dd633aae5070d9356c9b3337f0b308bfbfd3e3df756c522dd73','[\"*\"]','2025-05-04 00:30:35',NULL,'2025-05-04 00:30:18','2025-05-04 00:30:35'),
(383,'App\\Models\\User',5,'authToken','12d852fb602e5a95389acc624b6f110120a0812028fd91307601f54dcdd358c2','[\"*\"]','2025-05-04 06:54:15',NULL,'2025-05-04 06:27:14','2025-05-04 06:54:15'),
(384,'App\\Models\\User',5,'authToken','cb7d25faf1c3aee72ce3dcc4d938a570c94ec33954f4a063288589071af67510','[\"*\"]','2025-05-04 06:55:36',NULL,'2025-05-04 06:54:31','2025-05-04 06:55:36'),
(385,'App\\Models\\User',25,'authToken','6c5afda6e513397c2bd0a42a0c4cb233ef5fbf226b8289fdba276111478630f0','[\"*\"]',NULL,NULL,'2025-05-04 13:16:59','2025-05-04 13:16:59'),
(386,'App\\Models\\User',1,'authToken','7f5c940baabc041b4a0d754023e6d4d54ecd82c062b547b076a9ed2d9e45d2d5','[\"*\"]',NULL,NULL,'2025-05-04 13:20:15','2025-05-04 13:20:15'),
(387,'App\\Models\\User',1,'authToken','6e57e8a62abf613022eb8df68ebea693cc4e31b43c149900fd3ad4765a763192','[\"*\"]',NULL,NULL,'2025-05-04 13:22:52','2025-05-04 13:22:52'),
(388,'App\\Models\\User',1,'authToken','2a89b00d7db41ef9bbaedb3cd976324973b065b83fdb0876537ed1e44969a6ef','[\"*\"]','2025-05-04 13:28:59',NULL,'2025-05-04 13:28:42','2025-05-04 13:28:59'),
(389,'App\\Models\\User',26,'authToken','e68801b500cdec7ac724207569770d9babc01e3f0464aad28016f6f47ad62527','[\"*\"]',NULL,NULL,'2025-05-04 13:30:15','2025-05-04 13:30:15'),
(390,'App\\Models\\User',1,'authToken','61cbde26bfc5deb8477cd603a3fb61af5d5ce892f66058ae45c903fc5bf54d37','[\"*\"]',NULL,NULL,'2025-05-04 13:47:55','2025-05-04 13:47:55'),
(391,'App\\Models\\User',1,'authToken','8237cc8e9e04722c439cf33cb70fc1cf7937e2d19341bd52b30389f1e3d13dd1','[\"*\"]',NULL,NULL,'2025-05-04 13:54:22','2025-05-04 13:54:22'),
(392,'App\\Models\\User',1,'authToken','d05e42c8c451a8f11046d654593fc40c2c4dda7a2ca6a884b6ed2e5f6dfd4f00','[\"*\"]',NULL,NULL,'2025-05-04 14:00:21','2025-05-04 14:00:21'),
(393,'App\\Models\\User',1,'authToken','fedd76fc4815d6b13e34c3c9b652b72e1e80957d3495162c1b2dee923ef13bde','[\"*\"]',NULL,NULL,'2025-05-04 14:01:43','2025-05-04 14:01:43'),
(394,'App\\Models\\User',1,'authToken','afdadb29d3bd314e03768976374fb11f74cab2e7f67165abc5baf1167d459b6c','[\"*\"]',NULL,NULL,'2025-05-04 14:02:00','2025-05-04 14:02:00'),
(395,'App\\Models\\User',1,'authToken','54059984f5b605e84b231e0461df0e2ba18e5f4f9c85fc402d054024145420e5','[\"*\"]',NULL,NULL,'2025-05-04 14:02:09','2025-05-04 14:02:09'),
(396,'App\\Models\\User',1,'authToken','f1ac4a0aa631e47e8c6bd4ca7393739ca51bab629bf2f3e830d23ab27ae3bc7e','[\"*\"]','2025-05-04 14:28:07',NULL,'2025-05-04 14:22:56','2025-05-04 14:28:07'),
(397,'App\\Models\\User',1,'authToken','253cb7d9758f87352aaef205f5b41256ea07671f4a63ac593dd4a7dea5055dfa','[\"*\"]',NULL,NULL,'2025-05-04 14:33:10','2025-05-04 14:33:10'),
(398,'App\\Models\\User',1,'authToken','93849397d45c55af9c9d289d661c4480491bd883e9e8f0ea62c4cafdbd192224','[\"*\"]','2025-05-04 14:39:15',NULL,'2025-05-04 14:38:54','2025-05-04 14:39:15'),
(399,'App\\Models\\User',1,'authToken','e63b19cdfe5e9bcac8328c71e45b9b974e26881143f4b6bdb63a6e26fa7704f4','[\"*\"]','2025-05-04 14:46:41',NULL,'2025-05-04 14:46:25','2025-05-04 14:46:41'),
(400,'App\\Models\\User',1,'authToken','fe6abf9cda5cc6633e9339d28b2e1a7a057b233fa26d13f06dfa6c519839def5','[\"*\"]','2025-05-04 14:54:21',NULL,'2025-05-04 14:54:12','2025-05-04 14:54:21'),
(401,'App\\Models\\User',1,'authToken','dcffb1fc9dd544ca42987ca619c37d5038a171ad33850308f907e7b741b3a009','[\"*\"]','2025-05-04 14:59:00',NULL,'2025-05-04 14:58:43','2025-05-04 14:59:00'),
(402,'App\\Models\\User',1,'authToken','3cdea8e4febd9210ebeaaf539a60ae5f653cc6c8dcef91c4a5f0f6cd1cc51c4a','[\"*\"]','2025-05-04 15:05:13',NULL,'2025-05-04 15:04:54','2025-05-04 15:05:13'),
(403,'App\\Models\\User',1,'authToken','0100abdbbb20d13ca93bed45b4307340bb1d4c8a885e0bc58aa27299cf9f81e0','[\"*\"]','2025-05-04 15:36:28',NULL,'2025-05-04 15:36:22','2025-05-04 15:36:28'),
(404,'App\\Models\\User',1,'authToken','e3ffa0466f112fae18db675cb0b8eb347348abc40073852641d2f80d535597b0','[\"*\"]','2025-05-04 15:47:29',NULL,'2025-05-04 15:43:49','2025-05-04 15:47:29'),
(405,'App\\Models\\User',1,'authToken','3fa165a953e8438141ae14b3c1c6c40f298ff8f991bd0b970997f57cecee4f58','[\"*\"]','2025-05-04 15:56:16',NULL,'2025-05-04 15:56:07','2025-05-04 15:56:16'),
(406,'App\\Models\\User',1,'authToken','784815ec77207fc3ec638be0af8f00d8e4fbc0c029d4f3e35e534199b57115df','[\"*\"]','2025-05-04 16:29:41',NULL,'2025-05-04 16:29:39','2025-05-04 16:29:41'),
(407,'App\\Models\\User',5,'authToken','5ce81bddacd1899a9b0ea3e30276e29c397b964095d7ed26e8681c6f2c0c9f0e','[\"*\"]','2025-05-05 03:10:45',NULL,'2025-05-05 03:08:11','2025-05-05 03:10:45'),
(408,'App\\Models\\User',1,'authToken','004e9cac5e75ac606d1875b417fa405c8dbc8649e559bb1054ae4c16f6e69d3c','[\"*\"]',NULL,NULL,'2025-05-05 03:12:17','2025-05-05 03:12:17'),
(409,'App\\Models\\User',1,'authToken','58540162b58f249bccf807ba3049cf8439bbfa56bbc1ab6d5564c7763fdc2ac3','[\"*\"]',NULL,NULL,'2025-05-05 03:21:12','2025-05-05 03:21:12'),
(410,'App\\Models\\User',4,'authToken','b688f72ebd04425580650eeb689fa853d505dc12f68e6e0d95600362d7154430','[\"*\"]','2025-05-05 03:32:20',NULL,'2025-05-05 03:31:50','2025-05-05 03:32:20'),
(411,'App\\Models\\User',4,'authToken','faa0f775183020c232b4d48f9318f0514e32e75db0519cd3a79f93a8726d742b','[\"*\"]',NULL,NULL,'2025-05-05 03:32:37','2025-05-05 03:32:37'),
(412,'App\\Models\\User',26,'authToken','770d66f963c166d3ac43653bd79dbfa0115558111551c04c99d0ce91043127b1','[\"*\"]',NULL,NULL,'2025-05-05 03:34:15','2025-05-05 03:34:15'),
(413,'App\\Models\\User',26,'authToken','97a8b640778ec5001a98f276efd6d00ce85181045cc7b265cd31f4cd30d770fa','[\"*\"]','2025-05-05 03:35:31',NULL,'2025-05-05 03:34:29','2025-05-05 03:35:31'),
(414,'App\\Models\\User',27,'authToken','253313965ec92ef9b85cb6cc4cdfa3c03a1a4dca4d55dddfc1bd1b81cffa5a39','[\"*\"]',NULL,NULL,'2025-05-05 03:36:01','2025-05-05 03:36:01'),
(415,'App\\Models\\User',28,'authToken','4a8e36b91237c1df6f6a222164680dbaf4c05eecd7c7ea2ecf1490d19c86c955','[\"*\"]',NULL,NULL,'2025-05-05 04:02:35','2025-05-05 04:02:35'),
(416,'App\\Models\\User',26,'authToken','a709865bc06bd6742bfafd10e5ebf9e0f20ea708c8014a91b780583abe1d081e','[\"*\"]','2025-05-05 04:16:39',NULL,'2025-05-05 04:16:27','2025-05-05 04:16:39'),
(417,'App\\Models\\User',5,'authToken','11b84f81a42cfbd6d02540730dfdbb405453b656cf509ad404897c141b90ef5f','[\"*\"]','2025-05-05 04:19:47',NULL,'2025-05-05 04:18:29','2025-05-05 04:19:47'),
(418,'App\\Models\\User',29,'authToken','7841ebfcbfd8f0d8d89868a9c8ff55ef47eb5133c4cf96cb9079b41eb1347ac5','[\"*\"]',NULL,NULL,'2025-05-05 04:22:40','2025-05-05 04:22:40'),
(419,'App\\Models\\User',29,'authToken','689e75183ecaa880c80658b79674e4c7253f0be56b1cf1637e6d1f88d5d2faad','[\"*\"]','2025-05-05 04:24:43',NULL,'2025-05-05 04:24:33','2025-05-05 04:24:43'),
(420,'App\\Models\\User',26,'authToken','4f5ad5ce2d0b7344c9e63ca66cd227ff5b01c4e07005884414c739137ce17b1d','[\"*\"]','2025-05-05 04:34:27',NULL,'2025-05-05 04:34:19','2025-05-05 04:34:27'),
(421,'App\\Models\\User',30,'authToken','a564143ae0d492a7a1231abf09091436dc7caddc3b7c755db811f2290ea02c6c','[\"*\"]',NULL,NULL,'2025-05-05 04:48:10','2025-05-05 04:48:10'),
(422,'App\\Models\\User',5,'authToken','578855450952f9fd672a5864170dcc604c0aaa3d22ee880ee0b0699ff8a94e00','[\"*\"]','2025-05-05 06:52:21',NULL,'2025-05-05 06:19:30','2025-05-05 06:52:21'),
(423,'App\\Models\\User',31,'authToken','c9af780bf3512342a36ac16ada4bac59939f383664327ff5e7525880308355ca','[\"*\"]',NULL,NULL,'2025-05-05 07:15:44','2025-05-05 07:15:44'),
(424,'App\\Models\\User',26,'authToken','b129dc11e056fa6790232f335e826124848da2eaf26453e580ee8cab6bc52b72','[\"*\"]','2025-05-05 07:24:46',NULL,'2025-05-05 07:24:40','2025-05-05 07:24:46'),
(425,'App\\Models\\User',5,'authToken','225d751978fa267d90ad5207c2d7e740952e7e7c4ab632cc76c6f75008caf555','[\"*\"]','2025-05-05 07:34:00',NULL,'2025-05-05 07:29:33','2025-05-05 07:34:00'),
(426,'App\\Models\\User',32,'authToken','e371d0d5b7af8206790dbc2e3bf7bd4520823912077a1789d0abef00b5262a2b','[\"*\"]',NULL,NULL,'2025-05-05 07:32:55','2025-05-05 07:32:55'),
(427,'App\\Models\\User',33,'authToken','d31ad8bd39c60e4c956c1b6c5a98cb8e7bc413943857946516a1cfe3b93339fb','[\"*\"]',NULL,NULL,'2025-05-05 07:35:05','2025-05-05 07:35:05'),
(428,'App\\Models\\User',33,'authToken','0a0f4311646d7c80ac74441d63ff47338f89c8fcdeb9343b0e44db4db8099918','[\"*\"]','2025-05-05 07:42:22',NULL,'2025-05-05 07:35:47','2025-05-05 07:42:22'),
(429,'App\\Models\\User',5,'authToken','c8968f74e514ecac95fbc0d149ebbe856e3218e6e0008503964b987503f5b473','[\"*\"]','2025-05-05 07:44:06',NULL,'2025-05-05 07:43:08','2025-05-05 07:44:06'),
(430,'App\\Models\\User',34,'authToken','a8f3d0baf5d2fc580ea4dcfd6fdea14d6260a1569ba4c05e83e57c208bb66859','[\"*\"]',NULL,NULL,'2025-05-05 07:44:29','2025-05-05 07:44:29'),
(431,'App\\Models\\User',33,'authToken','97ecac62cf8ef805a01ec52fc350b14014792a9ab0093354e9e2885c3a636e48','[\"*\"]','2025-05-05 07:46:06',NULL,'2025-05-05 07:45:58','2025-05-05 07:46:06'),
(432,'App\\Models\\User',35,'authToken','d1da31fe570b6ef5d47e329abf02f23cc85e7d6dcd663a4f6809851f6390d095','[\"*\"]',NULL,NULL,'2025-05-05 07:50:22','2025-05-05 07:50:22'),
(433,'App\\Models\\User',27,'authToken','9aceb285a54156440e0f8ae1b1dc63b5e458eb16003c9a4269268fdfc9e6a6c1','[\"*\"]','2025-05-05 08:27:15',NULL,'2025-05-05 08:27:01','2025-05-05 08:27:15'),
(434,'App\\Models\\User',36,'authToken','e743fc95ce7b5de6b91b82be6e0ff82d3fb0e751b47d86383872a4431646a7d5','[\"*\"]',NULL,NULL,'2025-05-05 08:49:49','2025-05-05 08:49:49'),
(435,'App\\Models\\User',36,'authToken','bde5ebe8bca0b8e10e403fe8cf30ef533818607493edf08d55614454f2f4a45c','[\"*\"]','2025-05-05 08:51:45',NULL,'2025-05-05 08:51:20','2025-05-05 08:51:45'),
(436,'App\\Models\\User',37,'authToken','aa9cd1a1597514645400ebff1d12659fe50fec9c674be449069d379dc329cebf','[\"*\"]',NULL,NULL,'2025-05-05 09:15:22','2025-05-05 09:15:22'),
(437,'App\\Models\\User',37,'authToken','c99cdf136842423a7386473b25a0244f67420f6e3965641b0fd2b310da3b26ee','[\"*\"]','2025-05-05 09:16:30',NULL,'2025-05-05 09:15:47','2025-05-05 09:16:30'),
(438,'App\\Models\\User',38,'authToken','b72b6a4e16d63ed5d825d163956776fb029c292faa7c0e600883a91dbe55658a','[\"*\"]',NULL,NULL,'2025-05-05 09:17:18','2025-05-05 09:17:18'),
(439,'App\\Models\\User',38,'authToken','6e8237d4526726f813c1ba46c65e360bb4089fe9504c33ba69a513e089dfdd37','[\"*\"]','2025-05-05 09:18:46',NULL,'2025-05-05 09:18:44','2025-05-05 09:18:46'),
(440,'App\\Models\\User',5,'authToken','8116f6def74f8fdc746d186645f478cf9ea630faa1932059225baba808afce84','[\"*\"]','2025-05-05 09:40:46',NULL,'2025-05-05 09:32:21','2025-05-05 09:40:46'),
(441,'App\\Models\\User',39,'authToken','220dc52451d9911165312b475cf8fcc04ac63d52e0a0ef5db81182f6e0c00c8f','[\"*\"]',NULL,NULL,'2025-05-05 09:33:34','2025-05-05 09:33:34'),
(442,'App\\Models\\User',40,'authToken','b4a36f722fe5cec5be43a4d689f219e2244f1585d8b4ff84353ff8e07b432770','[\"*\"]',NULL,NULL,'2025-05-05 09:35:12','2025-05-05 09:35:12'),
(443,'App\\Models\\User',40,'authToken','f8fefc3fdc4dd835357529f4682d894703282bf36b27eec8cb315eb3677d2069','[\"*\"]','2025-05-05 09:36:22',NULL,'2025-05-05 09:35:29','2025-05-05 09:36:22'),
(444,'App\\Models\\User',5,'authToken','e3179b35b798688454d5a133fd4af7030b2a07c5742aa795dfd4429bc9361bb0','[\"*\"]','2025-05-05 15:44:13',NULL,'2025-05-05 13:03:27','2025-05-05 15:44:13'),
(445,'App\\Models\\User',5,'authToken','6bbfa2547345b18d9b8f9e9e49471756f2ec6bc79cf14e43e0e1fc3f45b56174','[\"*\"]','2025-05-05 16:16:51',NULL,'2025-05-05 16:16:30','2025-05-05 16:16:51'),
(446,'App\\Models\\User',46,'authToken','c4bfb201fd407ae77dc680cd5b701bf616de75e96c226d09c662cfd73f109804','[\"*\"]',NULL,NULL,'2025-05-06 02:08:38','2025-05-06 02:08:38'),
(447,'App\\Models\\User',46,'authToken','2fbe816d4d332929a8c9a39ca527fdbb6ad7e9a5bebbea4eb93fb0feaa5fe269','[\"*\"]','2025-05-06 02:09:32',NULL,'2025-05-06 02:08:51','2025-05-06 02:09:32'),
(448,'App\\Models\\User',46,'authToken','07cc53d040a5c566caa292958359b6e9b3451c61acbe23beeeab2585aa478fda','[\"*\"]','2025-05-06 03:05:35',NULL,'2025-05-06 02:43:52','2025-05-06 03:05:35'),
(449,'App\\Models\\User',46,'authToken','e3ad89ad823010a195822e5931da0c32b576c1b9369efc502cdb78b572b8144b','[\"*\"]','2025-05-06 03:09:35',NULL,'2025-05-06 03:07:57','2025-05-06 03:09:35'),
(450,'App\\Models\\User',46,'authToken','7ba178bdc43d75f06f00fa31376f4d627594665b50070d892810465c131c51fe','[\"*\"]','2025-05-06 03:11:46',NULL,'2025-05-06 03:11:36','2025-05-06 03:11:46'),
(451,'App\\Models\\User',46,'authToken','bda7ad3f9473db25e171e70422d8b02a567cccacb189697f958b25275eae0615','[\"*\"]','2025-05-06 03:37:49',NULL,'2025-05-06 03:37:07','2025-05-06 03:37:49'),
(452,'App\\Models\\User',46,'authToken','20dce858af96e26f6bd0639df63a94910262aadb4dcd1309e8409e97656d1045','[\"*\"]','2025-05-06 03:44:02',NULL,'2025-05-06 03:43:56','2025-05-06 03:44:02'),
(453,'App\\Models\\User',46,'authToken','d8a5b480a9ebfbf637d0cbf78e1d2d9bcdccb2a99082a71f3b1701f5128ed99c','[\"*\"]','2025-05-06 04:01:24',NULL,'2025-05-06 03:47:17','2025-05-06 04:01:24'),
(454,'App\\Models\\User',5,'authToken','f74897f5201e5021019e16258413a2e9c176bc728e6e9a2781611994705ff683','[\"*\"]','2025-05-06 04:01:08',NULL,'2025-05-06 04:00:43','2025-05-06 04:01:08'),
(455,'App\\Models\\User',46,'authToken','65e655bab4c22c4bdf93c3ab4aa7050737391511e6647ead045c876b60de04f0','[\"*\"]','2025-05-06 04:07:13',NULL,'2025-05-06 04:06:22','2025-05-06 04:07:13'),
(456,'App\\Models\\User',46,'authToken','1affff78af646bae0ab6f6c5fcd51a4c4646f6021664444c68fff46f100e6208','[\"*\"]','2025-05-06 04:20:28',NULL,'2025-05-06 04:20:09','2025-05-06 04:20:28'),
(457,'App\\Models\\User',46,'authToken','c44733a482bfb7bdc534d0f2a398a1956c8389f4e066f029934ecf95e1187524','[\"*\"]','2025-05-06 04:22:23',NULL,'2025-05-06 04:22:13','2025-05-06 04:22:23'),
(458,'App\\Models\\User',46,'authToken','f5861a03917ffb5f9f45689d1dae572d68b1909104e8229469bf7ccb91959091','[\"*\"]','2025-05-06 04:29:16',NULL,'2025-05-06 04:27:56','2025-05-06 04:29:16'),
(459,'App\\Models\\User',1,'authToken','2c0038ac94de7ce18d2371143a0896a41f3500e6e6d4db23586a070f3a51c4d0','[\"*\"]','2025-05-06 04:30:01',NULL,'2025-05-06 04:29:31','2025-05-06 04:30:01'),
(460,'App\\Models\\User',1,'authToken','b06475a75eded126bfc288b0bfa8b59393cb094f39eae68b9fa0b37dd0463602','[\"*\"]','2025-05-06 04:34:33',NULL,'2025-05-06 04:33:02','2025-05-06 04:34:33'),
(461,'App\\Models\\User',5,'authToken','c4283af4716e3d6f8a2987543c36b9b13a3889d65f863a0d5f798b3b10a96c16','[\"*\"]','2025-05-06 04:37:13',NULL,'2025-05-06 04:36:48','2025-05-06 04:37:13'),
(462,'App\\Models\\User',46,'authToken','bf40399c58d455cc683f9155fa6756367608568aee202721af06b7dc8d1beb7e','[\"*\"]','2025-05-06 04:52:50',NULL,'2025-05-06 04:42:02','2025-05-06 04:52:50'),
(463,'App\\Models\\User',5,'authToken','43db9bb6d6434efffa0bf928b0e962a4b9bb3b7f70c5952af09f83a8d3972f94','[\"*\"]','2025-05-06 07:11:02',NULL,'2025-05-06 04:56:11','2025-05-06 07:11:02'),
(464,'App\\Models\\User',46,'authToken','8f1ca2974cde25042dd2fe01b29bdfe562a919f16b7d9799ad47ca7a700a4c2e','[\"*\"]','2025-05-06 06:57:34',NULL,'2025-05-06 06:28:03','2025-05-06 06:57:34'),
(465,'App\\Models\\User',46,'authToken','d17d341e4e68d9c270aaa8e5636e1006b5c25a0c086ac272b4f453bfc7480d3e','[\"*\"]','2025-05-06 07:22:52',NULL,'2025-05-06 06:43:04','2025-05-06 07:22:52'),
(466,'App\\Models\\User',5,'authToken','fef5220418a5c7a384502673f1cec05c539d9f3c8351babb0053970016235dc6','[\"*\"]','2025-05-06 07:33:21',NULL,'2025-05-06 07:14:50','2025-05-06 07:33:21'),
(467,'App\\Models\\User',46,'authToken','fe5b3e83b3217944028e994ee457685d0cb0b221d90b671468c127d4270574ec','[\"*\"]','2025-05-06 07:35:19',NULL,'2025-05-06 07:25:24','2025-05-06 07:35:19'),
(468,'App\\Models\\User',5,'authToken','e3212ead9eec15a5760fdf34eba623bfaf9bdb68715211ec7a6ee02cba8a8a85','[\"*\"]','2025-05-06 07:50:22',NULL,'2025-05-06 07:35:50','2025-05-06 07:50:22'),
(469,'App\\Models\\User',46,'authToken','de2b442ce3e45f814eee86fc76abf7aaa5b9feb2d462d00f8d6cf17537863fbf','[\"*\"]','2025-05-06 07:50:52',NULL,'2025-05-06 07:50:45','2025-05-06 07:50:52'),
(470,'App\\Models\\User',46,'authToken','51e25534494926edf7ccf6011591d4aa64c7eab39c7f840e46e50d42cf008047','[\"*\"]','2025-05-06 07:53:41',NULL,'2025-05-06 07:52:58','2025-05-06 07:53:41'),
(471,'App\\Models\\User',46,'authToken','879560bf6d9e4843fa916aa1da400a14070e69cd28173169c6206c87958687ef','[\"*\"]','2025-05-06 07:55:29',NULL,'2025-05-06 07:54:00','2025-05-06 07:55:29'),
(472,'App\\Models\\User',46,'authToken','5e66ca217181f3c302b12a00bb54ce3f424bb2bac2a39bdc7d248b7a143c8a65','[\"*\"]','2025-05-06 08:13:52',NULL,'2025-05-06 08:00:22','2025-05-06 08:13:52'),
(473,'App\\Models\\User',46,'authToken','d133b678291d3ce6d08e1d0ffca9f31ab1f2538798ac8c528550a0fa8cba6c67','[\"*\"]','2025-05-06 08:43:16',NULL,'2025-05-06 08:08:56','2025-05-06 08:43:16'),
(474,'App\\Models\\User',5,'authToken','a6d61ee84d10d839470a8dd6cefaef161057d80cdbcce74d2b369158f5d7ad79','[\"*\"]','2025-05-06 08:19:25',NULL,'2025-05-06 08:16:06','2025-05-06 08:19:25'),
(475,'App\\Models\\User',1,'authToken','51e128c78a6b01d3fafc2288bcb77767df57025608bd4b8d4a2953c54a003f92','[\"*\"]','2025-05-06 08:20:27',NULL,'2025-05-06 08:19:36','2025-05-06 08:20:27'),
(476,'App\\Models\\User',5,'authToken','5686c1c0563656581b32e7e33a850e9f05b835c730fea216d5a1232ef4a70807','[\"*\"]','2025-05-06 09:52:04',NULL,'2025-05-06 08:21:19','2025-05-06 09:52:04'),
(477,'App\\Models\\User',5,'authToken','d23ee5290d8b119e482d80f1e8cb84b5f1c99b0e622626446201e87db236c649','[\"*\"]','2025-05-06 09:40:01',NULL,'2025-05-06 09:27:23','2025-05-06 09:40:01'),
(478,'App\\Models\\User',5,'authToken','e2084f9651b3a5d34b94ab516ca9393447d2f86a4603461a7256ec3861d696a5','[\"*\"]','2025-05-06 09:42:49',NULL,'2025-05-06 09:41:15','2025-05-06 09:42:49'),
(479,'App\\Models\\User',5,'authToken','6d8c18705902d15a146606ada6e4d0df029257a4258d3f85eb5a7fb7b3cf039d','[\"*\"]','2025-05-06 13:17:30',NULL,'2025-05-06 13:13:55','2025-05-06 13:17:30'),
(480,'App\\Models\\User',46,'authToken','e8b2db87ee47a655193570c96f5ac44e29376998d76df955d7e1ace97d291e9a','[\"*\"]','2025-05-06 23:04:54',NULL,'2025-05-06 22:46:18','2025-05-06 23:04:54'),
(481,'App\\Models\\User',46,'authToken','7700393969f92e4c34767a2ee6284d3f007c2c21b086c9a0a86761bfbd0a3c8f','[\"*\"]','2025-05-07 01:01:51',NULL,'2025-05-07 00:58:32','2025-05-07 01:01:51'),
(482,'App\\Models\\User',5,'authToken','6d9cc53f5356034abb3a2f246bd44db22ccd9afcbb44a97ab69d0aefea4b59fb','[\"*\"]','2025-05-07 02:45:06',NULL,'2025-05-07 01:03:04','2025-05-07 02:45:06'),
(483,'App\\Models\\User',48,'authToken','800d4ef5a39a4a1b77a9379365d7075e04f4a6c6b8ff8928fd5902b4e1839114','[\"*\"]',NULL,NULL,'2025-05-07 01:16:57','2025-05-07 01:16:57'),
(484,'App\\Models\\User',48,'authToken','e81f5907f2205f2d0745227352d028b856677e64f3d0ea186907187eb77ec3c3','[\"*\"]','2025-05-07 01:18:38',NULL,'2025-05-07 01:18:11','2025-05-07 01:18:38'),
(485,'App\\Models\\User',46,'authToken','b99e3d93e0349eb2628ab675a62444edbb7bdcebb96a723e1d36b3bd41e312e3','[\"*\"]','2025-05-07 01:30:35',NULL,'2025-05-07 01:18:43','2025-05-07 01:30:35'),
(486,'App\\Models\\User',48,'authToken','1049cd6be5dca5f8b2b7bc80165b54a78c4a8676677f326694f2bd56d3bc276f','[\"*\"]','2025-05-07 01:30:15',NULL,'2025-05-07 01:29:13','2025-05-07 01:30:15'),
(487,'App\\Models\\User',48,'authToken','34ebc2c4e1955f21ecd3771f8012220815c798c1818d5509b49f0c7d7c73ec66','[\"*\"]','2025-05-07 01:39:00',NULL,'2025-05-07 01:38:34','2025-05-07 01:39:00'),
(488,'App\\Models\\User',49,'authToken','bda6918abc6c04ce869ad85ac3f286f89759aa3ad85bc9c7648bb7c89c5eb635','[\"*\"]',NULL,NULL,'2025-05-07 01:42:29','2025-05-07 01:42:29'),
(489,'App\\Models\\User',49,'authToken','85c7d5c2f5bc8c6c7ae007becc4eaa504d48398f6a137b64d072a73444b6d43c','[\"*\"]','2025-05-07 01:44:03',NULL,'2025-05-07 01:43:33','2025-05-07 01:44:03'),
(490,'App\\Models\\User',49,'authToken','533f601d410c8a691a2539d42c5755f0dcc125cbd1d950f38f2c478e54fa49f4','[\"*\"]','2025-05-07 01:57:21',NULL,'2025-05-07 01:44:29','2025-05-07 01:57:21'),
(491,'App\\Models\\User',5,'authToken','1112784283debc14b7c5996b16268fee3ab797074317e05597615b1ea4dfd215','[\"*\"]','2025-05-07 02:14:54',NULL,'2025-05-07 02:09:42','2025-05-07 02:14:54'),
(492,'App\\Models\\User',5,'authToken','5df255c677fd0068c835c135d4d825069577b3c8df9a295546c015a1e4ac7a6a','[\"*\"]','2025-05-07 02:42:46',NULL,'2025-05-07 02:17:28','2025-05-07 02:42:46'),
(493,'App\\Models\\User',5,'authToken','d50fff75e19260e1449aa16b0d7ea0f7ac7c9e20c12f963a7f9b7b12224a3fe5','[\"*\"]','2025-05-07 03:28:06',NULL,'2025-05-07 03:25:42','2025-05-07 03:28:06'),
(494,'App\\Models\\User',5,'authToken','6e182be742a2fcb84987c37c982b17cb3acd2245e5cbc1a1d0f30eebdf749b4a','[\"*\"]','2025-05-07 04:00:16',NULL,'2025-05-07 03:43:12','2025-05-07 04:00:16'),
(495,'App\\Models\\User',5,'authToken','976eb648f8e87cef1d96af13291d5233fb0dc14098af493d59c50f63f3ee5ee8','[\"*\"]','2025-05-07 04:25:56',NULL,'2025-05-07 04:11:39','2025-05-07 04:25:56'),
(496,'App\\Models\\User',5,'authToken','34b40b9025c5acad4f0a4517a2422ff0a94d64ceaea8ae0254ea9a8c934a6ef4','[\"*\"]','2025-05-07 04:51:43',NULL,'2025-05-07 04:29:06','2025-05-07 04:51:43'),
(497,'App\\Models\\User',5,'authToken','5800567db26e7080def31198c6b5829f1ce2a5fb35fcb30950ef4e5aadc97aad','[\"*\"]','2025-05-07 08:39:56',NULL,'2025-05-07 08:32:27','2025-05-07 08:39:56'),
(498,'App\\Models\\User',5,'authToken','ca4ef8841f76c9341334ca729b11cee761fd52c916c74219948efa09adaf1ead','[\"*\"]','2025-05-07 08:49:27',NULL,'2025-05-07 08:39:57','2025-05-07 08:49:27'),
(499,'App\\Models\\User',1,'authToken','01d8ee662264d3113e76a21798c2165bcc9528287f1092f351902a6bd7481aa1','[\"*\"]','2025-05-07 08:55:39',NULL,'2025-05-07 08:54:15','2025-05-07 08:55:39'),
(500,'App\\Models\\User',5,'authToken','dce0e3f346f6eaab048fa7ed27a1a39550ecd71ef51919b9947ab73a8a86474c','[\"*\"]','2025-05-07 08:58:15',NULL,'2025-05-07 08:55:58','2025-05-07 08:58:15'),
(501,'App\\Models\\User',5,'authToken','a7013b8b7a82f45bd4133030f6c6a013d1244717d8c2bae330b6e1dd74a657ad','[\"*\"]','2025-05-07 09:13:59',NULL,'2025-05-07 09:13:37','2025-05-07 09:13:59'),
(502,'App\\Models\\User',5,'authToken','786ff04ed359799b2c76c736d1190d92f4c51ab113d086f2f48337412e52a969','[\"*\"]','2025-05-07 09:49:21',NULL,'2025-05-07 09:29:28','2025-05-07 09:49:21'),
(503,'App\\Models\\User',5,'authToken','c6662d356a3ba7c55ad0956dc83518e649186e4a2137a47deaa48f707cae7fd0','[\"*\"]','2025-05-07 09:50:22',NULL,'2025-05-07 09:49:45','2025-05-07 09:50:22'),
(504,'App\\Models\\User',5,'authToken','4f1ce5b567f6a11f061e144b6eea3442d8aa0ac0a42d6823fce46cd55831b5ad','[\"*\"]','2025-05-07 10:51:51',NULL,'2025-05-07 09:58:50','2025-05-07 10:51:51'),
(505,'App\\Models\\User',5,'authToken','f311f0578edd17b07b52112a5cd274edeb1fa2d4f780612b20b842682f4e06e7','[\"*\"]','2025-05-07 10:34:15',NULL,'2025-05-07 10:34:00','2025-05-07 10:34:15'),
(506,'App\\Models\\User',5,'authToken','63151fc750a7bfa7574ef8d1b2353e96bc074d9f917d80d07d8b993282856272','[\"*\"]','2025-05-07 10:40:31',NULL,'2025-05-07 10:39:57','2025-05-07 10:40:31'),
(507,'App\\Models\\User',5,'authToken','5d4da90e8b4335dfd5da30ec6af7310a95cbcf21676c3f0b9635ff5ed98e7649','[\"*\"]','2025-05-07 10:47:51',NULL,'2025-05-07 10:47:33','2025-05-07 10:47:51'),
(508,'App\\Models\\User',5,'authToken','d57bda780d35f7d9fd538bd008b0bf0a73b09ad7a93488b4c703bfce9db540aa','[\"*\"]','2025-05-07 10:58:12',NULL,'2025-05-07 10:49:45','2025-05-07 10:58:12'),
(509,'App\\Models\\User',5,'authToken','8b39e02a251a6f6c696a40c20276cb679c247db630af6c2577c86ef9fdf1b194','[\"*\"]','2025-05-07 11:26:33',NULL,'2025-05-07 10:59:09','2025-05-07 11:26:33'),
(510,'App\\Models\\User',5,'authToken','bb36788d956ebb8bdf60c882fc3fcdcd910d802d069109addc1304a2697a2905','[\"*\"]','2025-05-07 11:22:36',NULL,'2025-05-07 10:59:35','2025-05-07 11:22:36'),
(511,'App\\Models\\User',5,'authToken','9f184213ce1787f7617ea603c37d576c54ef5fbf52659252156cc23ab76a8bc5','[\"*\"]','2025-05-07 11:24:27',NULL,'2025-05-07 11:23:47','2025-05-07 11:24:27'),
(512,'App\\Models\\User',5,'authToken','ebbbdc3528bff3ee2eb42e31961082e542ed688dd27bf528fe37d56566fc8f82','[\"*\"]','2025-05-07 11:32:06',NULL,'2025-05-07 11:27:40','2025-05-07 11:32:06'),
(513,'App\\Models\\User',5,'authToken','61ab991a341b234f9eddbd37598c02f102ca06bae0b0485c982f3ad617ccefd1','[\"*\"]','2025-05-07 11:35:50',NULL,'2025-05-07 11:34:18','2025-05-07 11:35:50'),
(514,'App\\Models\\User',5,'authToken','b3be4e5418882fc75cfd5ffe7aa17ca6de578444ccb669127cb88f5153d79909','[\"*\"]','2025-05-07 12:58:46',NULL,'2025-05-07 12:52:39','2025-05-07 12:58:46'),
(515,'App\\Models\\User',5,'authToken','9877f99f2110a049cf50e73a6c5b0d3172889c7c4fb1b0300de4747c1c94d8b9','[\"*\"]','2025-05-07 13:08:57',NULL,'2025-05-07 13:08:10','2025-05-07 13:08:57'),
(516,'App\\Models\\User',5,'authToken','f0c561f3666b2ef12e1d48ee6e83c1061ebb7b4090d04f0a07fe09a452c2136a','[\"*\"]','2025-05-07 13:50:31',NULL,'2025-05-07 13:18:44','2025-05-07 13:50:31'),
(517,'App\\Models\\User',5,'authToken','c1b908088fb642888c8cc45075035cd62552b33e5d5282742f14f5b14358f933','[\"*\"]','2025-05-07 16:44:19',NULL,'2025-05-07 13:37:36','2025-05-07 16:44:19'),
(518,'App\\Models\\User',5,'authToken','722894d415899f86d85c2d41692ec2e79a141f45557c0e3289e2d0ccfab5b423','[\"*\"]','2025-05-07 13:54:43',NULL,'2025-05-07 13:51:29','2025-05-07 13:54:43'),
(519,'App\\Models\\User',5,'authToken','0b19c1209cc411733392c98a6effb96b0e418706ca5f4af784f81e896617130e','[\"*\"]','2025-05-07 14:23:22',NULL,'2025-05-07 14:05:55','2025-05-07 14:23:22'),
(520,'App\\Models\\User',5,'authToken','4999a4f54ab8164b0c2fcf2706eb0d0a8a20cd33fc9f75af0c2d7432576a8b99','[\"*\"]','2025-05-07 16:10:17',NULL,'2025-05-07 16:07:20','2025-05-07 16:10:17'),
(521,'App\\Models\\User',5,'authToken','2ab12a198fd0c79ce771aaf62ed2744139ce505cf2c31609416cd8b155f79054','[\"*\"]','2025-05-07 16:20:48',NULL,'2025-05-07 16:19:17','2025-05-07 16:20:48'),
(522,'App\\Models\\User',5,'authToken','0fa193507bc420a5971856405ba79e0553d38a83c4ca54ee26255c35e173a996','[\"*\"]','2025-05-07 16:36:29',NULL,'2025-05-07 16:28:42','2025-05-07 16:36:29'),
(523,'App\\Models\\User',5,'authToken','22ae44859cd48dd3abfed6b3331a05bb0cd1a43a61f9b0e6462b629ed9dcfeaf','[\"*\"]','2025-05-07 16:55:33',NULL,'2025-05-07 16:49:23','2025-05-07 16:55:33'),
(524,'App\\Models\\User',5,'authToken','e6b812b74f626b1939c89c6f04c227d5c36d0d6d573e6ccc6821af3285048c1f','[\"*\"]','2025-05-07 18:00:00',NULL,'2025-05-07 17:14:42','2025-05-07 18:00:00'),
(525,'App\\Models\\User',5,'authToken','c8e19b6534310b98883ebb5994359970a75b0de30cc4f58c34277cb0e84108e2','[\"*\"]','2025-05-07 17:31:50',NULL,'2025-05-07 17:18:20','2025-05-07 17:31:50'),
(526,'App\\Models\\User',5,'authToken','50ed5f45ea4ac375f293ad628bc5c8ab028f415d1b358228f51f65194f5ec9fb','[\"*\"]','2025-05-07 17:51:24',NULL,'2025-05-07 17:44:45','2025-05-07 17:51:24'),
(527,'App\\Models\\User',5,'authToken','08af969d00dcf7aee36a1a662b38efbe8bca2aae6544316eae6987fba96a8eba','[\"*\"]','2025-05-07 18:50:45',NULL,'2025-05-07 18:34:23','2025-05-07 18:50:45'),
(528,'App\\Models\\User',5,'authToken','adab8f3aa5acebd93ba4070eeb53ed1b80be63f1259a8e5444ca6d3c23d83cd5','[\"*\"]','2025-05-07 20:40:09',NULL,'2025-05-07 20:01:51','2025-05-07 20:40:09'),
(529,'App\\Models\\User',5,'authToken','133d057b40e5d2f6bd8b726ec3ae713676e46d4acc55f9a246152f678dacab59','[\"*\"]','2025-05-07 20:41:49',NULL,'2025-05-07 20:41:33','2025-05-07 20:41:49'),
(530,'App\\Models\\User',5,'authToken','8939fdd242fe2f75afaa2b4778c967021eb8394efc6037c663f500f7f5a67dff','[\"*\"]','2025-05-07 23:29:59',NULL,'2025-05-07 20:53:50','2025-05-07 23:29:59'),
(531,'App\\Models\\User',5,'authToken','f7464937be0175921ecb8a9cb84bc99f1c94165b5c33da1f716cc55ce03efbca','[\"*\"]','2025-05-08 02:22:13',NULL,'2025-05-08 00:38:11','2025-05-08 02:22:13'),
(532,'App\\Models\\User',5,'authToken','2ffa86096599ed861ff6159875bff243b0ec44d1ef36acdd9397099b44155fae','[\"*\"]','2025-05-08 01:36:35',NULL,'2025-05-08 01:18:21','2025-05-08 01:36:35'),
(533,'App\\Models\\User',5,'authToken','ffe7f4d5262a4df6f8961da02c595b1e649d1f4843a1923fcb64345591ef9a79','[\"*\"]','2025-05-08 02:08:25',NULL,'2025-05-08 01:49:48','2025-05-08 02:08:25'),
(534,'App\\Models\\User',5,'authToken','d77179f8da651d5ac39c7f0b9529f9530010e9128444c7192ed3098ebabf89bf','[\"*\"]','2025-05-08 02:24:10',NULL,'2025-05-08 02:20:12','2025-05-08 02:24:10'),
(535,'App\\Models\\User',5,'authToken','95ef793ff10e1c94e21fd27b1368795f83fec097dbf4950213c276ad2b06862f','[\"*\"]','2025-05-08 02:27:12',NULL,'2025-05-08 02:25:13','2025-05-08 02:27:12'),
(536,'App\\Models\\User',5,'authToken','afca9b58bd5fda1714eb5a6e3edfb64fd3d647cd87e06c807ae782ee2b4cba0a','[\"*\"]','2025-05-08 02:43:02',NULL,'2025-05-08 02:31:17','2025-05-08 02:43:02'),
(537,'App\\Models\\User',5,'authToken','16552a65b2e55fc7428a02358351cb629a8fa294e9fcc3d1e9da0429618f7e6e','[\"*\"]','2025-05-08 02:42:54',NULL,'2025-05-08 02:40:08','2025-05-08 02:42:54'),
(538,'App\\Models\\User',5,'authToken','74ba7321f027ea16d4ad125179e49b52cb26e62d50d9293204630b1fecde4599','[\"*\"]','2025-05-08 02:47:38',NULL,'2025-05-08 02:46:54','2025-05-08 02:47:38'),
(539,'App\\Models\\User',5,'authToken','0d6cf776540b65673d5c8069b218dd349905c81c76c1c9715634b06b2c230689','[\"*\"]','2025-05-08 03:00:39',NULL,'2025-05-08 02:59:43','2025-05-08 03:00:39'),
(540,'App\\Models\\User',5,'authToken','ee85aef9d042b37189f9a4989642a34fc8617210af9e7603eaed9791c2aabc36','[\"*\"]','2025-05-08 03:24:08',NULL,'2025-05-08 03:08:22','2025-05-08 03:24:08'),
(541,'App\\Models\\User',5,'authToken','343b896bfe33f6c1a0c2c24eead7520192d70ef5d0bbbe137c42c958c5bb1542','[\"*\"]','2025-05-08 03:27:28',NULL,'2025-05-08 03:24:16','2025-05-08 03:27:28'),
(542,'App\\Models\\User',5,'authToken','fd62d6103aba574cfd758c3b576d90911306f2019f9e1ccbe91a0e319e3d3682','[\"*\"]','2025-05-08 04:38:50',NULL,'2025-05-08 03:29:38','2025-05-08 04:38:50'),
(543,'App\\Models\\User',5,'authToken','7b91ad6e25bf069550aaee5969125ba6dcdaf9ce8c82136f656095b13579287e','[\"*\"]','2025-05-08 04:03:47',NULL,'2025-05-08 03:42:15','2025-05-08 04:03:47'),
(544,'App\\Models\\User',5,'authToken','5b1ad52160f7573c362988d1e2c6b084468affd1da48c41b28eb64504ee800a8','[\"*\"]','2025-05-08 04:25:50',NULL,'2025-05-08 04:19:16','2025-05-08 04:25:50'),
(545,'App\\Models\\User',5,'authToken','a8fd255e26962e738f6a37d874fc08fc1462b3c9daf64e103e96e1153deab7a2','[\"*\"]','2025-05-08 06:04:54',NULL,'2025-05-08 06:04:38','2025-05-08 06:04:54'),
(546,'App\\Models\\User',5,'authToken','981d4fb41a6d96e206660fc881762cb718484e89cb615ed699f2d39ea8e989ad','[\"*\"]','2025-05-08 07:10:06',NULL,'2025-05-08 06:10:11','2025-05-08 07:10:06'),
(547,'App\\Models\\User',5,'authToken','ed9258c8973788f868f40b1766aafc4656acd58929215c525f2ee1990e076818','[\"*\"]','2025-05-08 06:51:20',NULL,'2025-05-08 06:39:13','2025-05-08 06:51:20'),
(548,'App\\Models\\User',46,'authToken','d4cd66e268e1ad1534ba59eced63145f6c21a30c6fb4b00c56a80604ccc4a6be','[\"*\"]','2025-05-08 08:36:34',NULL,'2025-05-08 07:10:36','2025-05-08 08:36:34'),
(549,'App\\Models\\User',5,'authToken','89f4d9b61913678a58c36dcb48a91e3ed6f9eb350a853e30d5fda129a2aac971','[\"*\"]','2025-05-08 07:11:42',NULL,'2025-05-08 07:11:06','2025-05-08 07:11:42'),
(550,'App\\Models\\User',5,'authToken','0f26e9c4f85bdd4b6eefbaaad0fb4e30a76c940d6e892ca0807113e59f768189','[\"*\"]','2025-05-08 09:27:35',NULL,'2025-05-08 07:21:19','2025-05-08 09:27:35'),
(551,'App\\Models\\User',5,'authToken','dde5b5af9ef9eab9c17a791e164b519af7080cd7fc38297fbd05a1d18e03cf68','[\"*\"]','2025-05-08 09:18:40',NULL,'2025-05-08 09:05:03','2025-05-08 09:18:40'),
(552,'App\\Models\\User',5,'authToken','bd0d2f1651b8782ebc241209422d756b979c6f47dc5ae34691b3c56e36d7cd2e','[\"*\"]','2025-05-08 09:32:10',NULL,'2025-05-08 09:31:23','2025-05-08 09:32:10'),
(553,'App\\Models\\User',5,'authToken','67cf08027c540f4ecb0bf7ad7a84d16ea84257e56bf3f52ed1f974caca9e8e37','[\"*\"]','2025-05-09 02:24:48',NULL,'2025-05-09 01:40:51','2025-05-09 02:24:48'),
(554,'App\\Models\\User',5,'authToken','226432528f6fa13cff85415bfc6a621f629410c05b84a4d008120efb564b76d2','[\"*\"]','2025-05-09 03:47:44',NULL,'2025-05-09 02:33:17','2025-05-09 03:47:44'),
(555,'App\\Models\\User',5,'authToken','80ce4516dc2fb1a1dc862b73c431c1118494766a578deb14a0d1a8be3893c7e6','[\"*\"]','2025-05-09 03:33:03',NULL,'2025-05-09 03:06:56','2025-05-09 03:33:03'),
(556,'App\\Models\\User',5,'authToken','73cf63e02d58a16c4b858b90914a880aafddddc5573dbf25c4f23b8fed83ae03','[\"*\"]','2025-05-09 04:01:52',NULL,'2025-05-09 03:34:51','2025-05-09 04:01:52'),
(557,'App\\Models\\User',1,'authToken','13e6c40053503a6cc081517fe65979ab854f92202e52e5e145884cd289cb21c5','[\"*\"]','2025-05-09 04:48:24',NULL,'2025-05-09 03:47:59','2025-05-09 04:48:24'),
(558,'App\\Models\\User',1,'authToken','4e7694a5b92cdfc6c8130fc6c179e04e5cf1daf1d187aa847f9d33b0d276cb24','[\"*\"]','2025-05-09 04:04:37',NULL,'2025-05-09 04:02:28','2025-05-09 04:04:37'),
(559,'App\\Models\\User',5,'authToken','827de49c07344c2278a728df3b9811a51eb0246ba66ba089c79c007f906acb25','[\"*\"]','2025-05-09 04:10:16',NULL,'2025-05-09 04:05:02','2025-05-09 04:10:16'),
(560,'App\\Models\\User',5,'authToken','fe3a43006b2e7fa8175ee5503c51b683a81d01035af966c3fbd6ed968d6ebd98','[\"*\"]','2025-05-09 04:38:47',NULL,'2025-05-09 04:11:47','2025-05-09 04:38:47'),
(561,'App\\Models\\User',1,'authToken','2013464ac531a7de96562edc709967060b8490bc2f4181e31314fa342dc5c920','[\"*\"]','2025-05-09 08:33:18',NULL,'2025-05-09 06:54:38','2025-05-09 08:33:18'),
(562,'App\\Models\\User',1,'authToken','05b3ad9286f3001712cbc67881dc1df8edc97a54edf16eb976d43cf8dfd9072d','[\"*\"]','2025-05-09 08:57:06',NULL,'2025-05-09 08:50:38','2025-05-09 08:57:06'),
(563,'App\\Models\\User',5,'authToken','8a1011500142b4c55e7a9b48c0edd86e96ce0ae464244cca825c6928ab66eb95','[\"*\"]','2025-05-09 08:56:13',NULL,'2025-05-09 08:55:42','2025-05-09 08:56:13'),
(564,'App\\Models\\User',1,'authToken','5f669eee1170b7724cfa486796cbf69c2b62184f0833dbe7757ff4d4b6dfb1d4','[\"*\"]','2025-05-09 09:02:26',NULL,'2025-05-09 09:02:09','2025-05-09 09:02:26'),
(565,'App\\Models\\User',5,'authToken','252d5e985d378ccbeb23c1387132aab61afeb4591bd7716e5683982a169b96c8','[\"*\"]','2025-05-09 10:51:16',NULL,'2025-05-09 09:05:36','2025-05-09 10:51:16'),
(566,'App\\Models\\User',1,'authToken','f021f451b1d5584045471feea43a7b54e921aa8545b05ccddd38a6224b5ead2f','[\"*\"]','2025-05-09 10:21:04',NULL,'2025-05-09 10:20:48','2025-05-09 10:21:04'),
(567,'App\\Models\\User',1,'authToken','1f8c1d28b45a643dc59938141c39c956c6e048099092f31a77fa9a5406bb1b14','[\"*\"]','2025-05-09 10:24:17',NULL,'2025-05-09 10:23:41','2025-05-09 10:24:17'),
(568,'App\\Models\\User',1,'authToken','fbf390fd5daa581427d8ec5bd31f65d54affed5cdba207e466a66d4cacfb125a','[\"*\"]','2025-05-09 10:30:18',NULL,'2025-05-09 10:28:17','2025-05-09 10:30:18'),
(569,'App\\Models\\User',5,'authToken','39238cf20af8947e26074a3f902b2e55deea9fcc161c9bcf31581352bfe174be','[\"*\"]','2025-05-09 10:32:49',NULL,'2025-05-09 10:30:42','2025-05-09 10:32:49'),
(570,'App\\Models\\User',5,'authToken','62d9bd4bd3b347927ab2aeb36dd1aa65e4cd037cffa6b58ef16cec2bd7087ca8','[\"*\"]','2025-05-09 11:09:55',NULL,'2025-05-09 10:52:14','2025-05-09 11:09:55'),
(571,'App\\Models\\User',5,'authToken','5fcb65d01291362c444719ca6a8a3d02af20fc68420db79acb369e83cfa792d6','[\"*\"]','2025-05-09 11:26:02',NULL,'2025-05-09 11:22:13','2025-05-09 11:26:02'),
(572,'App\\Models\\User',5,'authToken','22112b5459d2b4dc4699646b9f74a56012a82e787ce42bfb5c6b23ccd54da14d','[\"*\"]','2025-05-09 13:27:47',NULL,'2025-05-09 13:22:42','2025-05-09 13:27:47'),
(573,'App\\Models\\User',5,'authToken','351da9aca34bd00372ffa285a440766bb8b0f7663874750e4cb008807cb34d3f','[\"*\"]','2025-05-09 15:48:02',NULL,'2025-05-09 13:31:21','2025-05-09 15:48:02'),
(574,'App\\Models\\User',5,'authToken','d3cbf7d761cf18d8c2b15410613e4f2377d2e3815b1177d7711592e9c8b54b94','[\"*\"]',NULL,NULL,'2025-05-09 13:37:24','2025-05-09 13:37:24'),
(575,'App\\Models\\User',5,'authToken','cd9cc9930c14b9905c70a187f5036ab25485af9474ebc457dc87c12db02c1159','[\"*\"]','2025-05-09 14:05:41',NULL,'2025-05-09 13:47:49','2025-05-09 14:05:41'),
(576,'App\\Models\\User',5,'authToken','985708a8245a9b8ae8d70804bfe970eae6a8abbd4e7dce4b05f0bc63094b52f4','[\"*\"]','2025-05-09 14:23:03',NULL,'2025-05-09 14:15:54','2025-05-09 14:23:03'),
(577,'App\\Models\\User',5,'authToken','b441c57bfc153515e3de9971c4ab177e59f73a1b540c0a3a378b5abc05e86323','[\"*\"]','2025-05-09 14:40:47',NULL,'2025-05-09 14:30:23','2025-05-09 14:40:47'),
(578,'App\\Models\\User',5,'authToken','856247be3e12f7b133170fc1b205e9a2559de8a4c9079fb57770973d10a05262','[\"*\"]','2025-05-09 14:41:25',NULL,'2025-05-09 14:40:57','2025-05-09 14:41:25'),
(579,'App\\Models\\User',5,'authToken','18414ed796f23edc35f0cc6783a050ba0832ebc25b2b69e01c049c9111759eaa','[\"*\"]','2025-05-09 14:51:48',NULL,'2025-05-09 14:51:22','2025-05-09 14:51:48'),
(580,'App\\Models\\User',5,'authToken','17cd5aa22caa1e8828f5e46c4b9da6934385ca8e9627ab8d211b3b8804d4aba2','[\"*\"]','2025-05-09 14:57:29',NULL,'2025-05-09 14:55:20','2025-05-09 14:57:29'),
(581,'App\\Models\\User',5,'authToken','465c95f34fe34500283087e52378cbc059d4d4f49d24ee3ca0533ef8a8c22a08','[\"*\"]','2025-05-09 15:01:17',NULL,'2025-05-09 14:58:30','2025-05-09 15:01:17'),
(582,'App\\Models\\User',46,'authToken','6f2c05f3f6f9fa687eb2225462f13c265a4797b175dd4c2f7a2cc6ec7bfeb8ad','[\"*\"]','2025-05-09 15:55:54',NULL,'2025-05-09 15:10:01','2025-05-09 15:55:54'),
(583,'App\\Models\\User',5,'authToken','ea76cb55e6dc0e217efafe2af0ed92e259655f31410a71e62663793ca5058d4e','[\"*\"]','2025-05-09 16:14:12',NULL,'2025-05-09 16:05:36','2025-05-09 16:14:12'),
(584,'App\\Models\\User',5,'authToken','a1d0b5110b513f95efdc8bf0294d34b2d5e827c6f23c82659791ac0199edc954','[\"*\"]','2025-05-09 16:37:31',NULL,'2025-05-09 16:16:21','2025-05-09 16:37:31'),
(585,'App\\Models\\User',5,'authToken','4cc406f8cb59a103a2c999329edc28a8747bd79315420d0ac102777f39c43787','[\"*\"]','2025-05-09 17:39:30',NULL,'2025-05-09 17:11:08','2025-05-09 17:39:30'),
(586,'App\\Models\\User',5,'authToken','411644db3e713683d0a5746de252fb8ba29f5343c7728337d980bdce9bb41e8a','[\"*\"]','2025-05-09 17:44:18',NULL,'2025-05-09 17:37:37','2025-05-09 17:44:18'),
(587,'App\\Models\\User',46,'authToken','a0d03152d2ed6ee3137d12d75517099b34a836ae4aa7c4525dbb96258ae2237b','[\"*\"]','2025-05-09 17:49:28',NULL,'2025-05-09 17:44:41','2025-05-09 17:49:28'),
(588,'App\\Models\\User',5,'authToken','2121fc3a57fdf41d483533dd93473ae00476772ce0fa75fffbac63c00cba3dee','[\"*\"]','2025-05-09 17:49:24',NULL,'2025-05-09 17:47:51','2025-05-09 17:49:24'),
(589,'App\\Models\\User',1,'authToken','cd40cbf23d02f46b66dae3248e4b901d09fb2405be504c381a959d89d6e2d2b2','[\"*\"]','2025-05-09 17:50:27',NULL,'2025-05-09 17:50:18','2025-05-09 17:50:27'),
(590,'App\\Models\\User',5,'authToken','23fb32c5405aa245f7f6312634589b26cdcc2d596c782f1fbb8c15eb4e757bae','[\"*\"]','2025-05-09 18:30:36',NULL,'2025-05-09 17:52:25','2025-05-09 18:30:36'),
(591,'App\\Models\\User',5,'authToken','47009ae152848b37797dc3ad957f6101cc1f7d297b07e674a1a83a24583e7706','[\"*\"]','2025-05-09 20:30:38',NULL,'2025-05-09 18:35:38','2025-05-09 20:30:38'),
(592,'App\\Models\\User',5,'authToken','d3ca1d752250c78d90ffe7fe37ecc56ec5cef3756ff3f81bb81cf199537e5a1e','[\"*\"]','2025-05-10 02:21:42',NULL,'2025-05-10 02:10:15','2025-05-10 02:21:42'),
(593,'App\\Models\\User',5,'authToken','894c8afe56853e01ab72249223b48adb1cfc9f63d61bd526dcc6b7e30372d600','[\"*\"]','2025-05-10 04:05:33',NULL,'2025-05-10 02:24:50','2025-05-10 04:05:33'),
(594,'App\\Models\\User',46,'authToken','1266f3a7203fe026fe7366c83b910cf71bd2b83e7ae04e1e300146721ae57abd','[\"*\"]','2025-05-10 02:53:47',NULL,'2025-05-10 02:53:02','2025-05-10 02:53:47'),
(595,'App\\Models\\User',1,'authToken','a3acea9011e06a967048ffdc1e4daf9ff6759e91ac31d95a41aed102789be8c5','[\"*\"]','2025-05-10 03:30:51',NULL,'2025-05-10 03:24:26','2025-05-10 03:30:51'),
(596,'App\\Models\\User',1,'authToken','c604d755257e8400172942c81ad13c5f195a122612439291ae6f582577b893f1','[\"*\"]','2025-05-10 03:46:25',NULL,'2025-05-10 03:46:22','2025-05-10 03:46:25'),
(597,'App\\Models\\User',1,'authToken','d5e7616ba04f53e5b48be29a299078d55bac64db3f4f6e566f2978a975863049','[\"*\"]','2025-05-10 04:18:02',NULL,'2025-05-10 03:54:21','2025-05-10 04:18:02'),
(598,'App\\Models\\User',1,'authToken','b33d167e70632f94b4e82e7a7d7138e92f1957447a4f898ed46ea82472c4ca76','[\"*\"]','2025-05-10 09:27:23',NULL,'2025-05-10 09:21:54','2025-05-10 09:27:23'),
(599,'App\\Models\\User',46,'authToken','4fdfb144118a07e3012f6686d87b270a4451338046796eb160dc3ab0af1ab79f','[\"*\"]','2025-05-10 09:38:34',NULL,'2025-05-10 09:29:59','2025-05-10 09:38:34'),
(600,'App\\Models\\User',1,'authToken','fd3a824b0ae406c67e73bf139b2e2012baabbba734206903859946c85bbb985d','[\"*\"]','2025-05-10 09:42:23',NULL,'2025-05-10 09:38:54','2025-05-10 09:42:23'),
(601,'App\\Models\\User',5,'authToken','e0edaf7cdea1e250af37373fab943b503e6c8e646d4be28c55fb4ae26b1dc149','[\"*\"]','2025-05-10 10:04:08',NULL,'2025-05-10 09:55:37','2025-05-10 10:04:08'),
(602,'App\\Models\\User',5,'authToken','f6b3491ba099453d9b250091fd6a90208438f59f63dac638e233ca456824146a','[\"*\"]','2025-05-10 10:21:23',NULL,'2025-05-10 10:19:44','2025-05-10 10:21:23'),
(603,'App\\Models\\User',5,'authToken','ca2fde184bf9b29c2d24c3464763e81b93fde3d313533c7fe05f72891838e4e9','[\"*\"]','2025-05-10 10:58:34',NULL,'2025-05-10 10:25:14','2025-05-10 10:58:34'),
(604,'App\\Models\\User',1,'authToken','1c4cf8bd9a6b3bee2d073cb167b121500ef0fa9402d521e43c01dcc453d7d21b','[\"*\"]','2025-05-10 16:31:47',NULL,'2025-05-10 16:08:24','2025-05-10 16:31:47'),
(605,'App\\Models\\User',1,'authToken','e9d17b12c393105c9408ef24e26d3a67c2bbb171948419218dd5fd62b3a1de74','[\"*\"]','2025-05-10 17:01:53',NULL,'2025-05-10 16:47:27','2025-05-10 17:01:53'),
(606,'App\\Models\\User',5,'authToken','bf0be59f401853a17474655395e5e33c762a7db5464570b88410115840335717','[\"*\"]','2025-05-10 17:04:15',NULL,'2025-05-10 17:03:55','2025-05-10 17:04:15'),
(607,'App\\Models\\User',1,'authToken','6585912072775f916949f2d61201de6f315a4e0523c7cdb33d8dffda7d1a2123','[\"*\"]','2025-05-10 17:41:35',NULL,'2025-05-10 17:05:48','2025-05-10 17:41:35'),
(608,'App\\Models\\User',5,'authToken','ad557ab302457ab9a0d6cf1f677fe6cd0350aa6816cf3d8622d98fe6f4c32d24','[\"*\"]','2025-05-10 17:37:57',NULL,'2025-05-10 17:15:06','2025-05-10 17:37:57'),
(609,'App\\Models\\User',1,'authToken','5bf938009c6704dde5d84c7c35c04bb6d3c2f59098c55b26511c83ff07f547e6','[\"*\"]','2025-05-10 17:43:32',NULL,'2025-05-10 17:43:18','2025-05-10 17:43:32'),
(610,'App\\Models\\User',1,'authToken','6e59bb9015eda651834cee6ef45baf56288b1831215d038a5093061594ed1af8','[\"*\"]','2025-05-10 17:44:10',NULL,'2025-05-10 17:43:55','2025-05-10 17:44:10'),
(611,'App\\Models\\User',1,'authToken','1244d463ac3510cbd6aa3f65aa9d55f3ea88e6e2dd1f21e950e799d97cfafb7b','[\"*\"]','2025-05-10 17:44:42',NULL,'2025-05-10 17:44:30','2025-05-10 17:44:42'),
(612,'App\\Models\\User',1,'authToken','174bfe40824cad84fcb92d9b6bd442945fa9bf91cdfb98ef0b87b4bb9db103c3','[\"*\"]','2025-05-10 17:46:12',NULL,'2025-05-10 17:45:02','2025-05-10 17:46:12'),
(613,'App\\Models\\User',1,'authToken','02a7468f61e899a0fb14b28be4a8fc6c0ee821d4c78d9167011dddd30af214f3','[\"*\"]','2025-05-10 17:50:12',NULL,'2025-05-10 17:46:53','2025-05-10 17:50:12'),
(614,'App\\Models\\User',5,'authToken','4d0bc180243a8d52b8de668834e0498f8e74211c16ee1ae6c8f45e85e638c26f','[\"*\"]','2025-05-10 23:40:30',NULL,'2025-05-10 23:19:06','2025-05-10 23:40:30'),
(615,'App\\Models\\User',1,'authToken','2b9c71264fab517ade72d3412c2f3441fde8e66a6e299ee2af907e86830f439c','[\"*\"]','2025-05-10 23:48:05',NULL,'2025-05-10 23:41:25','2025-05-10 23:48:05'),
(616,'App\\Models\\User',5,'authToken','1d3078d56add1866728caabbe367e254e7ad14466166639523ccc0ca3c10ccb2','[\"*\"]','2025-05-11 00:10:53',NULL,'2025-05-10 23:50:59','2025-05-11 00:10:53'),
(617,'App\\Models\\User',4,'authToken','37af1a335f0d988bcf021aad8c89081e601d319888e57b56df93a1a5bc71dce8','[\"*\"]','2025-05-11 00:27:02',NULL,'2025-05-11 00:11:34','2025-05-11 00:27:02'),
(618,'App\\Models\\User',1,'authToken','66a2745acef88d76a359ea943c5244cfa7ae4e38f92db8bcf73c406c37dca68a','[\"*\"]','2025-05-11 02:09:57',NULL,'2025-05-11 02:02:21','2025-05-11 02:09:57'),
(619,'App\\Models\\User',46,'authToken','e5811b0c9691974e10f30fcc5b665dd8232672cdc34d575137df378a126d36c6','[\"*\"]','2025-05-11 02:13:26',NULL,'2025-05-11 02:10:11','2025-05-11 02:13:26'),
(620,'App\\Models\\User',5,'authToken','34a4373cf7d83633119c2ad06ca7bbbfe45efd997e18a0ae97e80fdbd7ec244f','[\"*\"]','2025-05-11 07:50:36',NULL,'2025-05-11 07:01:47','2025-05-11 07:50:36'),
(621,'App\\Models\\User',50,'authToken','fb6eb96e103c851f0a4c0aac33e867e2b3c90175b72036efeadbc0b4a8422b18','[\"*\"]',NULL,NULL,'2025-05-11 07:07:19','2025-05-11 07:07:19'),
(622,'App\\Models\\User',50,'authToken','f8f3ac3971bc50bbd1b975893f6a1fd6f2ca143542c9e786805725c7259fcea4','[\"*\"]','2025-05-11 07:14:03',NULL,'2025-05-11 07:14:01','2025-05-11 07:14:03'),
(623,'App\\Models\\User',50,'authToken','c5125d4ed61a7882828dfb59ef75443afdfda9c7f87c824005edf770041f0ecc','[\"*\"]','2025-05-11 07:23:03',NULL,'2025-05-11 07:14:48','2025-05-11 07:23:03'),
(624,'App\\Models\\User',50,'authToken','2fe6048b0fbac419a971eb659cb819ce28505b2b977b8bc2dd0cb2aa11613ea9','[\"*\"]','2025-05-11 07:27:00',NULL,'2025-05-11 07:23:42','2025-05-11 07:27:00'),
(625,'App\\Models\\User',50,'authToken','ddf9473c592d7bbe0564a14192944eb40adf03882113f119844687cc8fa28012','[\"*\"]','2025-05-11 07:56:04',NULL,'2025-05-11 07:27:23','2025-05-11 07:56:04'),
(626,'App\\Models\\User',5,'authToken','eaf03833deab6bbb7a677a101efa0345293a7ce475da38402ec648228b532786','[\"*\"]','2025-05-13 07:22:48',NULL,'2025-05-11 07:41:43','2025-05-13 07:22:48'),
(627,'App\\Models\\User',1,'authToken','623951a9db386f55afd4b34492293bb9c6894cc4a7db833b7654472bcc89f996','[\"*\"]','2025-05-11 08:04:30',NULL,'2025-05-11 07:56:21','2025-05-11 08:04:30'),
(628,'App\\Models\\User',5,'authToken','48f84b361b82e5e6ae6232aaf2ed0ea1275a92fc9caa0b9eba5ed265a3d65fb9','[\"*\"]','2025-05-11 08:03:28',NULL,'2025-05-11 07:57:15','2025-05-11 08:03:28'),
(629,'App\\Models\\User',5,'authToken','f21e91aa0f1a1895aa7439c4b1874aebd337993114ed52a980e3e480b53edd95','[\"*\"]','2025-05-11 08:05:52',NULL,'2025-05-11 08:05:08','2025-05-11 08:05:52'),
(630,'App\\Models\\User',46,'authToken','aed272784d0538e538ab43019f272c2aa179096fea21e27d4a0523c252b57509','[\"*\"]','2025-05-11 08:17:26',NULL,'2025-05-11 08:10:35','2025-05-11 08:17:26'),
(631,'App\\Models\\User',1,'authToken','84e7099a88a723f2af9b07bac8f6769011274d5f66eed754bb0778c5387abb6b','[\"*\"]','2025-05-11 08:20:46',NULL,'2025-05-11 08:17:45','2025-05-11 08:20:46'),
(632,'App\\Models\\User',50,'authToken','eda84c28354de2423719548acaec7e6b18319164f2d9dbda654325f0b98f5875','[\"*\"]','2025-05-11 08:22:03',NULL,'2025-05-11 08:21:08','2025-05-11 08:22:03'),
(633,'App\\Models\\User',1,'authToken','f075d47632def12e91fd2ef332f50a2eb90664757e76b2867dc3451ddc7b769c','[\"*\"]','2025-05-11 08:22:50',NULL,'2025-05-11 08:22:37','2025-05-11 08:22:50'),
(634,'App\\Models\\User',1,'authToken','1bd58dd747dbcc53ddd6b5e759685d9ed2c4d6ab0f5387ba369a15e44dcc5a21','[\"*\"]','2025-05-11 08:26:43',NULL,'2025-05-11 08:23:36','2025-05-11 08:26:43'),
(635,'App\\Models\\User',5,'authToken','22cc307cc6009846f77ed0d340931fcf82409cec6f02c7c3c235d8637450748f','[\"*\"]','2025-05-11 08:27:25',NULL,'2025-05-11 08:27:11','2025-05-11 08:27:25'),
(636,'App\\Models\\User',5,'authToken','b0f8617c4992b1787cf1f2f5fe6622f875043203b0d9c3058bd655d7db82c0df','[\"*\"]','2025-05-11 09:59:08',NULL,'2025-05-11 08:58:14','2025-05-11 09:59:08'),
(637,'App\\Models\\User',5,'authToken','d9a3875be4d1bc9bbd367d2c2e5bf5c8cea75fe5e9534fb8fe93f47d35b4207c','[\"*\"]','2025-05-11 10:09:08',NULL,'2025-05-11 10:04:19','2025-05-11 10:09:08'),
(638,'App\\Models\\User',5,'authToken','d0e0510c77970ace68b1a8888c60d34d4d2d2b1b2341b0cc65c3c90700131a1f','[\"*\"]','2025-05-11 10:38:16',NULL,'2025-05-11 10:10:18','2025-05-11 10:38:16'),
(639,'App\\Models\\User',46,'authToken','c430915abe4db3cc27993344aae8ca481f72ec181ed8869c389edd488d479a48','[\"*\"]','2025-05-11 10:15:47',NULL,'2025-05-11 10:15:27','2025-05-11 10:15:47'),
(640,'App\\Models\\User',5,'authToken','0370a5bf39976a05e0622a14c1edb6f6af6039895a6729316b20165e25abd787','[\"*\"]','2025-05-11 10:38:15',NULL,'2025-05-11 10:36:47','2025-05-11 10:38:15'),
(641,'App\\Models\\User',5,'authToken','ddeeb65c4500aa38ba8160ffa7a81ee457cc0898ff7a42d3e4b5384d2b385efd','[\"*\"]','2025-05-11 10:48:33',NULL,'2025-05-11 10:41:02','2025-05-11 10:48:33'),
(642,'App\\Models\\User',5,'authToken','5007c0e09ce700c54d072c914cf579ad22ade8edaa18bd3cf25deee5985d6974','[\"*\"]','2025-05-11 10:56:36',NULL,'2025-05-11 10:50:24','2025-05-11 10:56:36'),
(643,'App\\Models\\User',5,'authToken','6593675a3dab1b58ff0e2b18424417e185aaa003346b1c5008a9a94c75ac8429','[\"*\"]','2025-05-11 11:17:11',NULL,'2025-05-11 10:51:56','2025-05-11 11:17:11'),
(644,'App\\Models\\User',5,'authToken','388c48b85dcf6268344b0421dac2170f692064bbed6b566da03fe1d0a5857971','[\"*\"]','2025-05-11 13:21:52',NULL,'2025-05-11 13:00:17','2025-05-11 13:21:52'),
(645,'App\\Models\\User',5,'authToken','9b9491273dd6f584a19327be1e8ae4b6c3de7d8ff5eb5750b5d7ede3de5c58fa','[\"*\"]','2025-05-11 13:24:12',NULL,'2025-05-11 13:11:03','2025-05-11 13:24:12'),
(646,'App\\Models\\User',1,'authToken','1d43c0cd621fe66a2e5dd9ccd5df7e41115ee6ccfad84ebbbf40a97740e11ab1','[\"*\"]','2025-05-11 13:25:50',NULL,'2025-05-11 13:22:10','2025-05-11 13:25:50'),
(647,'App\\Models\\User',5,'authToken','185a12169c3ec03076c19b062b348a1c4861c4badbdd456664c22df1f4f4b991','[\"*\"]','2025-05-11 15:05:14',NULL,'2025-05-11 14:23:05','2025-05-11 15:05:14'),
(648,'App\\Models\\User',5,'authToken','18eb52f6186283ed921af714dfb35717f4bff89faa5a30c48127720335bd0586','[\"*\"]','2025-05-11 15:32:30',NULL,'2025-05-11 15:22:54','2025-05-11 15:32:30'),
(649,'App\\Models\\User',5,'authToken','4607954f879eb4b40a23b640576db8b58386a03a4753c20f3f84be73f92c34e1','[\"*\"]','2025-05-11 15:44:38',NULL,'2025-05-11 15:34:57','2025-05-11 15:44:38'),
(650,'App\\Models\\User',5,'authToken','cc5dd1adececcaa3523f1c6399564d7ea10ea9dca3e9e477601bee9aab87fb45','[\"*\"]','2025-05-11 15:55:50',NULL,'2025-05-11 15:50:10','2025-05-11 15:55:50'),
(651,'App\\Models\\User',5,'authToken','1045617ad5492ad78dd0491cfd053fb5381d4d6a3786aeb38d0f64ae33c86735','[\"*\"]','2025-05-11 16:56:11',NULL,'2025-05-11 16:50:29','2025-05-11 16:56:11'),
(652,'App\\Models\\User',4,'authToken','47254df20632dc8ddc42115dcce65dac762aae585125ccd099d282feff6538b4','[\"*\"]','2025-05-11 17:00:34',NULL,'2025-05-11 16:59:25','2025-05-11 17:00:34'),
(653,'App\\Models\\User',5,'authToken','c55fed82cb5a71b5dea202ea7efe7314f78dfff835df43184516b5c6ade1628e','[\"*\"]','2025-05-11 17:44:50',NULL,'2025-05-11 17:04:12','2025-05-11 17:44:50'),
(654,'App\\Models\\User',5,'authToken','49d965ca9e2ec47fdb53a03b69afb11a08fae7592029ae0bd9a84ce557d30192','[\"*\"]','2025-05-11 17:37:31',NULL,'2025-05-11 17:28:35','2025-05-11 17:37:31'),
(655,'App\\Models\\User',5,'authToken','e7ed2ac4b140e98f5d78a352273ab3ec5c7b9b89327bdb3a0d33686182dc64c1','[\"*\"]','2025-05-11 17:54:06',NULL,'2025-05-11 17:46:29','2025-05-11 17:54:06'),
(656,'App\\Models\\User',5,'authToken','82fac79757dd3dcfb5492eb4b19a9ad84d6ced3758aaccf31809fc877314237b','[\"*\"]','2025-05-11 20:55:45',NULL,'2025-05-11 20:55:28','2025-05-11 20:55:45'),
(657,'App\\Models\\User',5,'authToken','4ea79dc74d686529054db571e8d7066a960ccb7b7995ddb9104e0d3b38b16b96','[\"*\"]','2025-05-11 23:27:49',NULL,'2025-05-11 23:14:15','2025-05-11 23:27:49'),
(658,'App\\Models\\User',5,'authToken','1df940a14e9bfe846b1378f93b62b0cc142d547659be199bd2eeb95a159da3ae','[\"*\"]','2025-05-11 23:34:00',NULL,'2025-05-11 23:25:47','2025-05-11 23:34:00'),
(659,'App\\Models\\User',5,'authToken','0c6ab60a808f85f1e084f45f0e3b6aae94b722e27b52942f937784451a0e1a02','[\"*\"]','2025-05-12 02:26:50',NULL,'2025-05-11 23:35:18','2025-05-12 02:26:50'),
(660,'App\\Models\\User',5,'authToken','204327d4b518de9fe9708bb504790ad01e914a75912f3902297823db7b3d1167','[\"*\"]','2025-05-12 00:10:51',NULL,'2025-05-11 23:49:06','2025-05-12 00:10:51'),
(661,'App\\Models\\User',5,'authToken','73c0797158d96f41e4594e4c1a3fe864c7ff03a7c8a3edc57858eaf269dfc588','[\"*\"]','2025-05-12 00:39:08',NULL,'2025-05-12 00:37:05','2025-05-12 00:39:08'),
(662,'App\\Models\\User',46,'authToken','7a15836e488df7c3876f6c74ca9146988e3694221a43038de1bca3b384a807f9','[\"*\"]','2025-05-12 02:27:56',NULL,'2025-05-12 00:39:26','2025-05-12 02:27:56'),
(663,'App\\Models\\User',5,'authToken','554990b6014cc172b5aecaaa2d9b1005c0231296a316f804279edc98d54ff6aa','[\"*\"]','2025-05-12 03:02:32',NULL,'2025-05-12 03:00:29','2025-05-12 03:02:32'),
(664,'App\\Models\\User',1,'authToken','dff3fe95c980ad109d5677acd1c7335461465dc25fe7d8d8bab248769dcc1d78','[\"*\"]','2025-05-12 03:04:42',NULL,'2025-05-12 03:03:01','2025-05-12 03:04:42'),
(665,'App\\Models\\User',1,'authToken','fa5e5ca7431d8c57a73220df3f05e454ba03264345c41c09ceabe10463aa1a8c','[\"*\"]','2025-05-12 03:05:33',NULL,'2025-05-12 03:04:53','2025-05-12 03:05:33'),
(666,'App\\Models\\User',5,'authToken','bd10bb4537bd01e3e1b91721ac669bde027448430ba2c8c60e44e02b6c37dfeb','[\"*\"]','2025-05-12 07:29:40',NULL,'2025-05-12 06:41:04','2025-05-12 07:29:40'),
(667,'App\\Models\\User',5,'authToken','87a9543e239796c3b101b85bb92ca0dfc8c87d84d3ab44d2e4098e419021f341','[\"*\"]','2025-05-12 07:39:17',NULL,'2025-05-12 07:37:21','2025-05-12 07:39:17'),
(668,'App\\Models\\User',5,'authToken','4024d79881fb11976569fffb2dce9e66b6cf16e871f1b46ddc861e84d35ed89d','[\"*\"]','2025-05-12 12:33:40',NULL,'2025-05-12 12:20:12','2025-05-12 12:33:40'),
(669,'App\\Models\\User',1,'authToken','b7b7ec99ac259fb3c024f3724e5fd5b7f1019abd4476f03b925d224ed0a8fc2e','[\"*\"]','2025-05-12 12:25:58',NULL,'2025-05-12 12:24:57','2025-05-12 12:25:58'),
(670,'App\\Models\\User',46,'authToken','82af169d70a9a93e30eb293ff1d82e0fc78081b722226abfa8ec1032d077b7ec','[\"*\"]','2025-05-12 12:59:58',NULL,'2025-05-12 12:26:17','2025-05-12 12:59:58'),
(671,'App\\Models\\User',1,'authToken','c1b041bc24a6c684479efd2a3335cd6a7bb32358053ae73fae1b779aa7ba2e56','[\"*\"]','2025-05-12 12:35:26',NULL,'2025-05-12 12:34:10','2025-05-12 12:35:26'),
(672,'App\\Models\\User',1,'authToken','2b1311849e9a6e47a183aa4433c2588735ec9b911730ad5ee3ff4a3ba6dcc3ce','[\"*\"]','2025-05-12 12:40:20',NULL,'2025-05-12 12:36:19','2025-05-12 12:40:20'),
(673,'App\\Models\\User',5,'authToken','2a0c5389e9ebc54a2445187c5246b14083a95bb136e027aa4594fc34f2b0a694','[\"*\"]','2025-05-12 12:47:41',NULL,'2025-05-12 12:41:03','2025-05-12 12:47:41'),
(674,'App\\Models\\User',5,'authToken','91dc10a1b668c81b3bb6a8a7aa55dcce275749b68bbb6ba9a74f1b0865b68ba0','[\"*\"]','2025-05-12 13:59:55',NULL,'2025-05-12 12:51:38','2025-05-12 13:59:55'),
(675,'App\\Models\\User',5,'authToken','11db4091a1ea53bb3f256c47655ec067e2d2665e9cf40acde39f1ae456539cb2','[\"*\"]','2025-05-12 13:34:48',NULL,'2025-05-12 13:03:39','2025-05-12 13:34:48'),
(676,'App\\Models\\User',5,'authToken','3c1d5ce71903249ec3d0f776f6b9d1de05da5f9fb1bbf66f06b238f01e030268','[\"*\"]','2025-05-12 13:25:59',NULL,'2025-05-12 13:24:04','2025-05-12 13:25:59'),
(677,'App\\Models\\User',1,'authToken','e743bde7f8439014f4a20b03f34dae547d8d65769a3a3c4198e6d64bc1cf8b27','[\"*\"]','2025-05-12 13:38:37',NULL,'2025-05-12 13:35:14','2025-05-12 13:38:37'),
(678,'App\\Models\\User',5,'authToken','5e46b80502b87474edcf16f691cd9b5aa451b08f98f6565e5ab010483a84529f','[\"*\"]','2025-05-12 14:06:37',NULL,'2025-05-12 13:39:00','2025-05-12 14:06:37'),
(679,'App\\Models\\User',5,'authToken','af78282263be257bcd0fede4c6bcc0d70f399a672a4379639bc43426bbb8ec4d','[\"*\"]','2025-05-12 15:17:26',NULL,'2025-05-12 14:07:09','2025-05-12 15:17:26'),
(680,'App\\Models\\User',54,'authToken','3b2d71d7f4dba4001d50f1086bac683b91257542e9d17bfc823cb4723baa0e38','[\"*\"]',NULL,NULL,'2025-05-12 14:08:12','2025-05-12 14:08:12'),
(681,'App\\Models\\User',1,'authToken','13b8f5338498392bdd9a964190dba04aa0bdc9204bbfe32afb50ad34d752de3d','[\"*\"]','2025-05-12 14:14:51',NULL,'2025-05-12 14:14:25','2025-05-12 14:14:51'),
(682,'App\\Models\\User',5,'authToken','00744095cdb6f01f5fba3fc14bbd476c0f1cd8720969528b4464688153e2be4c','[\"*\"]','2025-05-12 15:00:03',NULL,'2025-05-12 14:14:24','2025-05-12 15:00:03'),
(683,'App\\Models\\User',5,'authToken','70c31965049594d12cd51ba044f260d3e4c7ea0ca3db4c5bc91c9a029d9aa678','[\"*\"]','2025-05-12 14:48:09',NULL,'2025-05-12 14:40:12','2025-05-12 14:48:09'),
(684,'App\\Models\\User',1,'authToken','9c76e865fa32d0c79dcb0858cd0106676b36f0ec40cf5b737161020aea1cd7b0','[\"*\"]',NULL,NULL,'2025-05-13 01:18:50','2025-05-13 01:18:50'),
(685,'App\\Models\\User',1,'authToken','39d1f0aae5be91337d83b0ca83406e2bdffbc17d71d1541b069731ef0e1ca8de','[\"*\"]',NULL,NULL,'2025-05-13 01:19:28','2025-05-13 01:19:28'),
(686,'App\\Models\\User',1,'authToken','3890f6139a256fb237457ec00b320067a42d0471f9c6b7e1fa8e9957d7fb0692','[\"*\"]',NULL,NULL,'2025-05-13 01:21:12','2025-05-13 01:21:12'),
(687,'App\\Models\\User',1,'authToken','5c16e1ab5e049cfe99b4f7f8e5433a0e8b6af8318b949f7fbf51f6e7e096afdf','[\"*\"]',NULL,NULL,'2025-05-13 01:26:28','2025-05-13 01:26:28'),
(688,'App\\Models\\User',5,'authToken','3e3c3b1ad953647286d624487c730d159f190e7c370499c78b5dbaf640587b2a','[\"*\"]','2025-05-13 02:17:03',NULL,'2025-05-13 01:35:14','2025-05-13 02:17:03'),
(689,'App\\Models\\User',5,'authToken','1c8160ca9843292c445958387e46ed355b7a14418764923762b1e3fa88f67d6f','[\"*\"]','2025-05-13 01:42:32',NULL,'2025-05-13 01:35:59','2025-05-13 01:42:32'),
(690,'App\\Models\\User',1,'authToken','f5fc83866acacec20aa53faf8a6fdf80e707db08190f58b9c94ecb28c04a5eed','[\"*\"]','2025-05-13 02:01:35',NULL,'2025-05-13 01:59:27','2025-05-13 02:01:35'),
(691,'App\\Models\\User',1,'authToken','c1eace46c2fc6dfd1a498889e7c80fb7a748e2039a61c690d7341995f0f8e298','[\"*\"]','2025-05-13 02:05:13',NULL,'2025-05-13 02:02:28','2025-05-13 02:05:13'),
(692,'App\\Models\\User',1,'authToken','28ed57bbd92e940dc376137d4b4f291dc29fc50c90b1bcff2e3095173f9970f6','[\"*\"]','2025-05-13 02:09:18',NULL,'2025-05-13 02:08:57','2025-05-13 02:09:18'),
(693,'App\\Models\\User',1,'authToken','1ba5c2fd29f2fed530a0321c6eb7f67b6a6284b70b15cd94b2db3ecf07e78151','[\"*\"]','2025-05-13 02:17:59',NULL,'2025-05-13 02:11:53','2025-05-13 02:17:59'),
(694,'App\\Models\\User',5,'authToken','026fa469d6cde81820563f58ba3e1d5136890276abbdc03cbe360ec58307041d','[\"*\"]','2025-05-13 02:39:46',NULL,'2025-05-13 02:37:28','2025-05-13 02:39:46'),
(695,'App\\Models\\User',1,'authToken','b2127c54ee69f6c9af84e2dd4c9e07fe30eca340d62aeceb6cccd5af285c9cb7','[\"*\"]','2025-05-13 02:41:46',NULL,'2025-05-13 02:40:00','2025-05-13 02:41:46'),
(696,'App\\Models\\User',46,'authToken','d75849e97cf4b1ac2d9a0735c03a641009a9675bb7daf0739f0b683cb1b576b2','[\"*\"]','2025-05-13 04:43:20',NULL,'2025-05-13 02:42:22','2025-05-13 04:43:20'),
(697,'App\\Models\\User',1,'authToken','97935d93fe1695a5e79784afc6529b48631f0f2b236837ed01662967859a261f','[\"*\"]','2025-05-13 03:00:08',NULL,'2025-05-13 02:49:28','2025-05-13 03:00:08'),
(698,'App\\Models\\User',1,'authToken','ef7079cc4d2594e03ab3e25f75e09b8cee782115c264427d25a15cd18eabe390','[\"*\"]','2025-05-13 03:22:41',NULL,'2025-05-13 03:12:24','2025-05-13 03:22:41'),
(699,'App\\Models\\User',1,'authToken','8ff6c9958f2f4ee4c5c24e14be59f183b4fd7b594c94ce732942e5a92be060c8','[\"*\"]','2025-05-13 03:36:30',NULL,'2025-05-13 03:36:24','2025-05-13 03:36:30'),
(700,'App\\Models\\User',1,'authToken','0087077e1a16cd103686ecd3fa87f603715f34ad2e35fff4e3329e1b5d1f92f7','[\"*\"]','2025-05-13 03:54:52',NULL,'2025-05-13 03:50:55','2025-05-13 03:54:52'),
(701,'App\\Models\\User',5,'authToken','a908c1731fb3017ad9d907a2426e2e429130b54945d6da7181689c9d23dd6408','[\"*\"]','2025-05-13 04:37:06',NULL,'2025-05-13 03:53:38','2025-05-13 04:37:06'),
(702,'App\\Models\\User',1,'authToken','ff9f747db2c1b8d4b66ba99d3b53b44116b18b09f17c6e18d518d5e701b86171','[\"*\"]','2025-05-13 03:58:01',NULL,'2025-05-13 03:57:54','2025-05-13 03:58:01'),
(703,'App\\Models\\User',46,'authToken','9100e0d5a267280a35be4a4d0019b2bb6f23af43b46c38b9f5d34bd1db14cd59','[\"*\"]','2025-05-13 04:01:27',NULL,'2025-05-13 04:00:25','2025-05-13 04:01:27'),
(704,'App\\Models\\User',1,'authToken','1eade9bfb2ca1e63cfc63a7b227bee782968ee0835ef56a9392c322253fa65f2','[\"*\"]','2025-05-13 04:02:01',NULL,'2025-05-13 04:01:35','2025-05-13 04:02:01'),
(705,'App\\Models\\User',1,'authToken','5440ebf31a1ebc9f6bea8aaaa3fb0c6cd24c05cf6a181013b29bcc7e0e30030c','[\"*\"]','2025-05-13 04:02:51',NULL,'2025-05-13 04:02:45','2025-05-13 04:02:51'),
(706,'App\\Models\\User',1,'authToken','00f33a599015522fbe4c93c0efc9db0ace8eb098e9d8045368b69f4006a9dc5b','[\"*\"]','2025-05-13 04:21:07',NULL,'2025-05-13 04:04:21','2025-05-13 04:21:07'),
(707,'App\\Models\\User',46,'authToken','f59bb6b452abbed3a209578ec4cc95cd80cfabf7ab472a3319b26cb493de2aba','[\"*\"]','2025-05-13 04:53:00',NULL,'2025-05-13 04:14:53','2025-05-13 04:53:00'),
(708,'App\\Models\\User',1,'authToken','336254c0e1b452741e293b922c6b77aa713352848f9a93070e5a877305662805','[\"*\"]','2025-05-13 04:23:47',NULL,'2025-05-13 04:21:52','2025-05-13 04:23:47'),
(709,'App\\Models\\User',1,'authToken','367777ef0dd60fce22327eb023714ca042e0e21e2764a0be96cb196f5abc0f89','[\"*\"]','2025-05-13 04:34:09',NULL,'2025-05-13 04:30:08','2025-05-13 04:34:09'),
(710,'App\\Models\\User',1,'authToken','1116c34d1583c6da862d2c3197b5a4cf634d4e52af66e760736b419ac557d716','[\"*\"]','2025-05-13 04:38:45',NULL,'2025-05-13 04:35:21','2025-05-13 04:38:45'),
(711,'App\\Models\\User',46,'authToken','0044119fc56dfa4fc4260a88b19537296cf15ead8b44b0edefcdd9f2b6757d4e','[\"*\"]','2025-05-13 04:57:03',NULL,'2025-05-13 04:48:32','2025-05-13 04:57:03'),
(712,'App\\Models\\User',46,'authToken','c2eb582c380172c2a763f19d341888bb09b82a06d945f2d8c6803d48a0d8efc3','[\"*\"]','2025-05-13 04:57:10',NULL,'2025-05-13 04:56:32','2025-05-13 04:57:10'),
(713,'App\\Models\\User',46,'authToken','3a2e6e467161434650e5b85e2630689bcc36015fc40416e72774516fe27406bb','[\"*\"]','2025-05-13 08:22:29',NULL,'2025-05-13 06:14:52','2025-05-13 08:22:29'),
(714,'App\\Models\\User',46,'authToken','84c822aa9c7e864086cc750705a877245ff46c4c573059ab54826257ed7ce8e3','[\"*\"]','2025-05-13 06:55:56',NULL,'2025-05-13 06:24:03','2025-05-13 06:55:56'),
(715,'App\\Models\\User',1,'authToken','5aebf17774b3fe807a40df3e8dee447dea500cf706e17e93c07c44d0b1e70848','[\"*\"]','2025-05-13 06:35:11',NULL,'2025-05-13 06:32:33','2025-05-13 06:35:11'),
(716,'App\\Models\\User',1,'authToken','cce6537d097c8593c78f1f0d75e553fbe0977e592bc3e11eb568b3d7684717dd','[\"*\"]','2025-05-13 06:48:44',NULL,'2025-05-13 06:37:24','2025-05-13 06:48:44'),
(717,'App\\Models\\User',1,'authToken','d693cd74b12346dfaa733558c3ddb357feede6cc9dfe85ffc797a729a295cfe6','[\"*\"]','2025-05-13 06:49:15',NULL,'2025-05-13 06:40:45','2025-05-13 06:49:15'),
(718,'App\\Models\\User',5,'authToken','6ab199c4a58c5bfedb416fbb46c877234e146ea9a62bda3b3e61ed8f4a6a3294','[\"*\"]',NULL,NULL,'2025-05-13 06:45:08','2025-05-13 06:45:08'),
(719,'App\\Models\\User',5,'authToken','fe475e1d6a9a834bfe8753e0b40eb0b0c70cad42ca21e39fe5e45fccf54737a4','[\"*\"]','2025-05-13 07:35:07',NULL,'2025-05-13 06:46:05','2025-05-13 07:35:07'),
(720,'App\\Models\\User',1,'authToken','c1e50b50e24c36c3728dabbbe1b7bcda8f627179b3b8de25e68fa7d5d66731d2','[\"*\"]','2025-05-13 07:09:36',NULL,'2025-05-13 06:49:53','2025-05-13 07:09:36'),
(721,'App\\Models\\User',46,'authToken','0dada0cedc82c0db3daaef86c9f3b11784b59ff77391f5c53694940e6b421f75','[\"*\"]','2025-05-13 07:07:40',NULL,'2025-05-13 06:57:32','2025-05-13 07:07:40'),
(722,'App\\Models\\User',1,'authToken','f91648ff1d15058b1b283c132cf771d3e357ac2c67485912c485022ce5dbdb86','[\"*\"]','2025-05-13 07:12:43',NULL,'2025-05-13 07:10:59','2025-05-13 07:12:43'),
(723,'App\\Models\\User',1,'authToken','2be5d264e9949e86e706dadd474298e294a5acc9507b22d70ebd2de6e55db969','[\"*\"]','2025-05-13 07:19:08',NULL,'2025-05-13 07:13:54','2025-05-13 07:19:08'),
(724,'App\\Models\\User',1,'authToken','0b8b724b60356df4a008f3d377447a4a991a701e7fb8d1f8cbfde1c9b8003998','[\"*\"]','2025-05-13 07:26:14',NULL,'2025-05-13 07:15:19','2025-05-13 07:26:14'),
(725,'App\\Models\\User',1,'authToken','df35fc8bb3efb1ac488f225cc2cb97044e737847c3c2c83a407fa12f004184a6','[\"*\"]','2025-05-13 07:24:46',NULL,'2025-05-13 07:24:26','2025-05-13 07:24:46'),
(726,'App\\Models\\User',5,'authToken','6f4604e6e608b804ce20e2a36a7b46ec20245be194d13090a2061b70000335ec','[\"*\"]','2025-05-13 07:34:20',NULL,'2025-05-13 07:25:13','2025-05-13 07:34:20'),
(727,'App\\Models\\User',1,'authToken','b29423b511db360930a35da5b17b7c7628800c7e02c88662f4362486204badbe','[\"*\"]','2025-05-13 07:30:39',NULL,'2025-05-13 07:26:46','2025-05-13 07:30:39'),
(728,'App\\Models\\User',1,'authToken','267a64d05de4aee23c65623566a3ec1cef96474fc359a7af10dc3b7018a02220','[\"*\"]','2025-05-13 07:31:08',NULL,'2025-05-13 07:31:03','2025-05-13 07:31:08'),
(729,'App\\Models\\User',1,'authToken','e80e132da2a48c9361981d938f0ebb24fbe382c380124dd18f6d3010b096fed9','[\"*\"]','2025-05-13 08:17:22',NULL,'2025-05-13 07:37:01','2025-05-13 08:17:22'),
(730,'App\\Models\\User',5,'authToken','fe516352256941212b9f28c3dd768fed17dc0b7bad83b664ed08f3dba93fef9f','[\"*\"]','2025-05-13 08:12:14',NULL,'2025-05-13 07:37:42','2025-05-13 08:12:14'),
(731,'App\\Models\\User',1,'authToken','ce3dbaacb75461fa01fbb64f23d6c6e2ebb6b9b4e1d18ef62830cb2e9761da46','[\"*\"]','2025-05-13 07:39:13',NULL,'2025-05-13 07:38:45','2025-05-13 07:39:13'),
(732,'App\\Models\\User',1,'authToken','4692da931ebcd273141fe3d2eb3195e9e46270f76ebfa9daa957f8ea29ed3d0c','[\"*\"]','2025-05-13 07:44:41',NULL,'2025-05-13 07:40:02','2025-05-13 07:44:41'),
(733,'App\\Models\\User',1,'authToken','ec6ef6f7d3c50189798eac37e669f19de34f4e4228e29bf0bc5ca79178b60e7b','[\"*\"]','2025-05-13 08:00:36',NULL,'2025-05-13 07:55:29','2025-05-13 08:00:36'),
(734,'App\\Models\\User',1,'authToken','bc51a0e4e7d2628fac740448f01dc04c99492868734af1cbeb2f8cbe0c47f828','[\"*\"]','2025-05-13 08:20:41',NULL,'2025-05-13 08:14:42','2025-05-13 08:20:41'),
(735,'App\\Models\\User',5,'authToken','12d29b21373d4ddde560a4bece3e760cb387a3c34ba83d80a23c2a60fd8064a6','[\"*\"]','2025-05-13 08:16:33',NULL,'2025-05-13 08:15:11','2025-05-13 08:16:33'),
(736,'App\\Models\\User',5,'authToken','51e0e2eec9bdeae3371db139f2c538b9b49daa5c92c2ffc6ec2eca34817c3280','[\"*\"]','2025-05-13 08:18:30',NULL,'2025-05-13 08:17:35','2025-05-13 08:18:30'),
(737,'App\\Models\\User',5,'authToken','15d627ee0355a4383aac891bb38e9d8ebdd55228d4f92c634c05abf5a286fa16','[\"*\"]','2025-05-13 09:43:39',NULL,'2025-05-13 08:19:08','2025-05-13 09:43:39'),
(738,'App\\Models\\User',1,'authToken','d6377c5d30997f5764cfe615893678499c35752c11509e7c27c404d088760ecc','[\"*\"]','2025-05-13 08:30:50',NULL,'2025-05-13 08:21:21','2025-05-13 08:30:50'),
(739,'App\\Models\\User',1,'authToken','889a072db1e7f0b6b839f0eef666c9bf48ead3d81aae6f15bb3b22fe0ad6c1bc','[\"*\"]','2025-05-13 08:49:07',NULL,'2025-05-13 08:22:14','2025-05-13 08:49:07'),
(740,'App\\Models\\User',1,'authToken','10e948ff5bc4dc42f3a1da8115cb32cd2b85572562fbaaafe4d96dd4a341c136','[\"*\"]','2025-05-13 08:33:22',NULL,'2025-05-13 08:31:18','2025-05-13 08:33:22'),
(741,'App\\Models\\User',1,'authToken','72aecbcf3a086825829dc5fd8e19267d1416365c0cd4586165944bf26663accb','[\"*\"]','2025-05-13 08:50:47',NULL,'2025-05-13 08:33:40','2025-05-13 08:50:47'),
(742,'App\\Models\\User',5,'authToken','e415fe2bc014d26a5b0df1c2511b5c758194dbe9bfc3b341f06eaca257a40aa4','[\"*\"]','2025-05-13 08:49:41',NULL,'2025-05-13 08:49:29','2025-05-13 08:49:41'),
(743,'App\\Models\\User',1,'authToken','a06f0a5d9ee76ec17df88e858fc1fccc84ed5fe81cda5deab78208b40b54c2e3','[\"*\"]','2025-05-13 09:25:49',NULL,'2025-05-13 09:03:24','2025-05-13 09:25:49'),
(744,'App\\Models\\User',1,'authToken','d9e6ce5f6f6d5f5c300b391b1a55b8613641cbd3db74147c9d5dd51512416ea7','[\"*\"]','2025-05-13 09:43:50',NULL,'2025-05-13 09:30:54','2025-05-13 09:43:50'),
(745,'App\\Models\\User',5,'authToken','b51a17acfcb4d35c5fd3dd81ccd6b54e45aa0fd3c1f5197c94534518bfe3c903','[\"*\"]','2025-05-13 09:55:02',NULL,'2025-05-13 09:44:07','2025-05-13 09:55:02'),
(746,'App\\Models\\User',1,'authToken','7aa615afc8b7cde9c5e1834527d34e30c7fcb9e66032b866d3a4b4cee8e01a0d','[\"*\"]','2025-05-13 09:48:07',NULL,'2025-05-13 09:45:02','2025-05-13 09:48:07'),
(747,'App\\Models\\User',1,'authToken','4acaf012c949d6ab8eb25081a283900e7e6574f3a62a24c8db2aef4776f2b5c9','[\"*\"]','2025-05-13 09:48:39',NULL,'2025-05-13 09:48:34','2025-05-13 09:48:39'),
(748,'App\\Models\\User',1,'authToken','98335b7e5ff0a109e9f9ab6218f9293fdb1654798c1360c7ffc587bcdfe23d0a','[\"*\"]','2025-05-13 09:55:59',NULL,'2025-05-13 09:48:50','2025-05-13 09:55:59'),
(749,'App\\Models\\User',5,'authToken','0c58e4af4f6fd092eb0f4098e0a6373304a56d17d08a95f9813549af67863df0','[\"*\"]','2025-05-13 10:02:26',NULL,'2025-05-13 09:55:20','2025-05-13 10:02:26'),
(750,'App\\Models\\User',1,'authToken','044fcf56776341c85d2e1baa3b1019f9cbcfdf2d30468fc41a6220eb99991fc9','[\"*\"]','2025-05-13 09:59:21',NULL,'2025-05-13 09:58:55','2025-05-13 09:59:21'),
(751,'App\\Models\\User',1,'authToken','5e3de3d5ffa34613d7ba860b295a5dc239a116ab7f2fdbffa2ccc55dd7d0a38e','[\"*\"]','2025-05-13 10:00:26',NULL,'2025-05-13 10:00:11','2025-05-13 10:00:26'),
(752,'App\\Models\\User',1,'authToken','8eb075d4ce18f7d2ad64678d92df2e04c1e243b7541fbbd02fee8a6bc2596916','[\"*\"]','2025-05-13 10:37:44',NULL,'2025-05-13 10:37:05','2025-05-13 10:37:44'),
(753,'App\\Models\\User',1,'authToken','451b31b6aea09229b14344c3e2945fda3f61312173500495b7b24902ecbd2904','[\"*\"]','2025-05-13 10:56:43',NULL,'2025-05-13 10:56:33','2025-05-13 10:56:43'),
(754,'App\\Models\\User',1,'authToken','128d2508c60d977eca2749267255f676e43c4b045499e6c99174c0a5ba02abe6','[\"*\"]','2025-05-13 11:13:20',NULL,'2025-05-13 10:57:15','2025-05-13 11:13:20'),
(755,'App\\Models\\User',1,'authToken','ab74b7746a30958266ad88027a4c1a28a1aaaf4a6b4d5bb1f6a27b635b5fa29b','[\"*\"]','2025-05-13 10:58:48',NULL,'2025-05-13 10:58:18','2025-05-13 10:58:48'),
(756,'App\\Models\\User',1,'authToken','9e29c8ca885fb5de9a586f45e33562b02c3b23e119ed85a2beca3cbb91a718df','[\"*\"]','2025-05-13 11:05:30',NULL,'2025-05-13 11:00:04','2025-05-13 11:05:30'),
(757,'App\\Models\\User',1,'authToken','9531616023c8b566e42b7bfdc8ba43a6b5f93213e554b22ee6ef4e11f0d3b7a7','[\"*\"]','2025-05-13 11:07:14',NULL,'2025-05-13 11:06:52','2025-05-13 11:07:14'),
(758,'App\\Models\\User',1,'authToken','00004ebad50b8fd52837f8b0580792c91db0078900ce0460afcc5f85190984ea','[\"*\"]','2025-05-13 11:09:06',NULL,'2025-05-13 11:08:34','2025-05-13 11:09:06'),
(759,'App\\Models\\User',1,'authToken','3d46e3b774952d145b19f2030ffe68e5a01a5f337fcac28518f2a9aa7498203f','[\"*\"]','2025-05-13 11:27:10',NULL,'2025-05-13 11:26:54','2025-05-13 11:27:10'),
(760,'App\\Models\\User',1,'authToken','a824cb3144e8cb9300243ed039d17fc4c1dca66194e3404eb39dff332007fdc8','[\"*\"]','2025-05-13 11:27:57',NULL,'2025-05-13 11:27:41','2025-05-13 11:27:57'),
(761,'App\\Models\\User',1,'authToken','25d8b4f9388e483f118a1ff32c7ce6b8de950e60b938dd3dd059d62916b0c5a3','[\"*\"]','2025-05-13 11:28:37',NULL,'2025-05-13 11:28:20','2025-05-13 11:28:37'),
(762,'App\\Models\\User',1,'authToken','bb0efaf7a1725840e22c4db2756be5f58deae1e4d86321d804c49a01707ef975','[\"*\"]','2025-05-13 11:33:21',NULL,'2025-05-13 11:33:02','2025-05-13 11:33:21'),
(763,'App\\Models\\User',1,'authToken','f34df0452e9745ab459cff68bf408eeb7413408606fd28d5799be5215beef689','[\"*\"]','2025-05-13 11:36:26',NULL,'2025-05-13 11:34:20','2025-05-13 11:36:26'),
(764,'App\\Models\\User',1,'authToken','d75cfb55d5376290d9f77569d4f2a6fdbf83c16961ea61b8da9d5c90f15c182b','[\"*\"]','2025-05-13 11:54:25',NULL,'2025-05-13 11:39:01','2025-05-13 11:54:25'),
(765,'App\\Models\\User',1,'authToken','2d8d90021a83e2ae05df9fb46e72f274f8b40f5e19afa8dbe17171d7d7503f4b','[\"*\"]','2025-05-13 11:47:52',NULL,'2025-05-13 11:39:36','2025-05-13 11:47:52'),
(766,'App\\Models\\User',1,'authToken','e008de5b4cb0ba415e477bb05e9bbd222e9087ae5fc3638fb880ce96a47240d2','[\"*\"]','2025-05-13 12:10:57',NULL,'2025-05-13 12:09:58','2025-05-13 12:10:57'),
(767,'App\\Models\\User',1,'authToken','8b98888281c64f6daf75ae84ca6d0580bd08f2a7f879ccb89058b26ff8198458','[\"*\"]','2025-05-13 12:12:57',NULL,'2025-05-13 12:12:34','2025-05-13 12:12:57'),
(768,'App\\Models\\User',1,'authToken','0e891b4f882db144e4e0907fde7d345fa1becb6cdba46fbf988fc33807f3d7c1','[\"*\"]','2025-05-13 12:17:41',NULL,'2025-05-13 12:17:35','2025-05-13 12:17:41'),
(769,'App\\Models\\User',1,'authToken','5ad06fbfd0b71d8d0082f4feaaf1aef8064bb4ad6efa95c93e39d8d756f9f51c','[\"*\"]','2025-05-13 12:43:18',NULL,'2025-05-13 12:18:13','2025-05-13 12:43:18'),
(770,'App\\Models\\User',1,'authToken','a85a0baa99d39a79943d65e8b7e26d4850a0ecfb8f4233f218c3c470f17bee68','[\"*\"]','2025-05-13 12:35:45',NULL,'2025-05-13 12:35:30','2025-05-13 12:35:45'),
(771,'App\\Models\\User',1,'authToken','0cd77c41454a8bc4c9f58d3872974b7db386e03e2c344a2014afc81fd5897929','[\"*\"]','2025-05-13 12:50:39',NULL,'2025-05-13 12:44:15','2025-05-13 12:50:39'),
(772,'App\\Models\\User',1,'authToken','fc7ee6d30c3a5ea1e8942f0470426f1dcb717802bbdb4d9e933e4ee7cbcfa577','[\"*\"]','2025-05-13 12:57:13',NULL,'2025-05-13 12:53:03','2025-05-13 12:57:13'),
(773,'App\\Models\\User',1,'authToken','0fd19c1a95d8f5c961dad132c1cdf9ccaecc49846166061dbcf1ff45e3f8fe99','[\"*\"]','2025-05-13 14:20:48',NULL,'2025-05-13 14:20:06','2025-05-13 14:20:48'),
(774,'App\\Models\\User',1,'authToken','5d3f9dd533f402d5c74024a8da3030012ca62b2c7561720422a7294e9e36f49c','[\"*\"]','2025-05-13 14:25:34',NULL,'2025-05-13 14:23:01','2025-05-13 14:25:34'),
(775,'App\\Models\\User',1,'authToken','ddc66994d3bde5f6d322dd3de61ec8615d53d5bafb998bd31c237c1d06cd6330','[\"*\"]','2025-05-13 14:35:30',NULL,'2025-05-13 14:26:00','2025-05-13 14:35:30'),
(776,'App\\Models\\User',1,'authToken','5fc5f916a95bb1f010c3bd525175d02c64d1f0f90f0551b8727390f6ea2ae8e6','[\"*\"]','2025-05-13 14:50:28',NULL,'2025-05-13 14:42:10','2025-05-13 14:50:28'),
(777,'App\\Models\\User',5,'authToken','9224e185f803cc5ed745a0d2ceaaaa5d137efe037f98384248783d1a7951a63d','[\"*\"]','2025-05-14 01:27:08',NULL,'2025-05-14 01:18:28','2025-05-14 01:27:08'),
(778,'App\\Models\\User',1,'authToken','f9e05e73aa174130bcff33cd2c6d1b074fe8e7cba42e9cab108a785b0bdc601e','[\"*\"]',NULL,NULL,'2025-05-13 23:48:22','2025-05-13 23:48:22'),
(779,'App\\Models\\User',1,'authToken','1d231f8ed177a999c770775331f0b05b4706bd9d265e5c00a22f915c7fdd7a80','[\"*\"]','2025-05-13 23:50:46',NULL,'2025-05-13 23:48:26','2025-05-13 23:50:46'),
(780,'App\\Models\\User',1,'authToken','28d12b46281fd482715e28722a59dd74b053ba9f5360a0d4b7c75d16fa8069fc','[\"*\"]','2025-05-13 23:52:44',NULL,'2025-05-13 23:50:50','2025-05-13 23:52:44'),
(781,'App\\Models\\User',1,'authToken','57dff1176cdfa5542ba8e14a6534ebd3290c23701365983e7426dba2ed2b265f','[\"*\"]','2025-05-14 00:02:12',NULL,'2025-05-14 00:00:47','2025-05-14 00:02:12'),
(782,'App\\Models\\User',1,'authToken','a341f346f087e417146ba450094e605287d03ee9596140c193528a759aef2434','[\"*\"]','2025-05-14 00:03:39',NULL,'2025-05-14 00:02:57','2025-05-14 00:03:39'),
(783,'App\\Models\\User',1,'authToken','c3d2addd3776e384f368a66d00cf4f71dda1e185ea105f6374cbdb28d4ea6f06','[\"*\"]','2025-05-14 00:05:52',NULL,'2025-05-14 00:04:39','2025-05-14 00:05:52'),
(784,'App\\Models\\User',1,'authToken','6214e7d60cf4ea6369e8f2a60b6ee67b6985aa45f89385f4581708fbea2f6ee7','[\"*\"]','2025-05-14 00:13:20',NULL,'2025-05-14 00:12:08','2025-05-14 00:13:20'),
(785,'App\\Models\\User',5,'authToken','936663fd9b227a6343b189856eb1e8d7c3326e989cccf8d172cf470ccdbcc399','[\"*\"]','2025-05-14 02:52:25',NULL,'2025-05-14 01:49:04','2025-05-14 02:52:25'),
(786,'App\\Models\\User',46,'authToken','524f0847f88df48471c0e5ed55adeba007d2e7349dfeb8b61ca130153aaf0cca','[\"*\"]','2025-05-14 01:57:46',NULL,'2025-05-14 01:49:07','2025-05-14 01:57:46'),
(787,'App\\Models\\User',1,'authToken','56f6cdd7205d5c057c85740a745bb87d63b64b8bf2d4ea109052cba2deef5504','[\"*\"]','2025-05-14 00:20:44',NULL,'2025-05-14 00:16:43','2025-05-14 00:20:44'),
(788,'App\\Models\\User',1,'authToken','c485c125ee2906e7f70d1cba12f609408008914fdf57506a2b51d6704c39f0a4','[\"*\"]','2025-05-14 00:22:55',NULL,'2025-05-14 00:22:42','2025-05-14 00:22:55'),
(789,'App\\Models\\User',46,'authToken','baea11beaf11d4131e32da059f9c7b221b6e25839364c19f3fe229f4aed74790','[\"*\"]','2025-05-14 02:31:57',NULL,'2025-05-14 02:31:16','2025-05-14 02:31:57'),
(790,'App\\Models\\User',1,'authToken','40c748e6f2c0f13f6a23182ef7ca71e8b9ce63e0809df9aaf61425ffaf8d04e1','[\"*\"]','2025-05-14 02:43:21',NULL,'2025-05-14 02:38:25','2025-05-14 02:43:21'),
(791,'App\\Models\\User',46,'authToken','3bdcd98023ae8573c113641d31b7eba5e2900ee8c43f5d47a25a3308b316c14e','[\"*\"]','2025-05-14 02:54:29',NULL,'2025-05-14 02:39:05','2025-05-14 02:54:29'),
(792,'App\\Models\\User',1,'authToken','fda913b823675dd170193f820f90abb09cda9403df3f519d93fc413891c3e5d7','[\"*\"]','2025-05-14 02:56:00',NULL,'2025-05-14 02:55:16','2025-05-14 02:56:00'),
(793,'App\\Models\\User',1,'authToken','4e2e024e5828cdd64e1865cd1608067c6d8fcf7c08f408ebf0178b44b8724654','[\"*\"]','2025-05-14 03:20:17',NULL,'2025-05-14 03:15:05','2025-05-14 03:20:17'),
(794,'App\\Models\\User',46,'authToken','59f4316484886d942ae16532f23067cbd8259cd1fbadd8abfae743b9f62703bd','[\"*\"]','2025-05-14 03:28:26',NULL,'2025-05-14 03:20:39','2025-05-14 03:28:26'),
(795,'App\\Models\\User',1,'authToken','c9d88f6be9ccdc502fd0f7bbb32278202efc423cc05b88ac1f13acdc1dfbecbe','[\"*\"]','2025-05-14 03:34:31',NULL,'2025-05-14 03:20:47','2025-05-14 03:34:31'),
(796,'App\\Models\\User',46,'authToken','b5d170eb8365f5b153496f511beb62947ff4cf088e5b673a0f1dee43208b8ed9','[\"*\"]','2025-05-14 03:38:50',NULL,'2025-05-14 03:21:38','2025-05-14 03:38:50'),
(797,'App\\Models\\User',46,'authToken','5121ac8a19e11e1450368c73126eb6ea9ae8a31ffefbed68b5df7b5abd0493ff','[\"*\"]',NULL,NULL,'2025-05-14 03:23:22','2025-05-14 03:23:22'),
(798,'App\\Models\\User',5,'authToken','9098ff963974f72cfe8e2cfd1a8a565115adb53183c2370da9faf3c35eb47728','[\"*\"]','2025-05-14 03:41:17',NULL,'2025-05-14 03:29:31','2025-05-14 03:41:17'),
(799,'App\\Models\\User',1,'authToken','fa42b336766df2bebdd14e46731b2779d1697778f9557bc6ceca55c2e52fe17d','[\"*\"]','2025-05-14 03:35:49',NULL,'2025-05-14 03:35:26','2025-05-14 03:35:49'),
(800,'App\\Models\\User',1,'authToken','0f57939cedffac1800e0e7d77ce5293cee02c44104b0644a988e1d2b81d30a56','[\"*\"]','2025-05-14 04:07:46',NULL,'2025-05-14 03:35:41','2025-05-14 04:07:46'),
(801,'App\\Models\\User',5,'authToken','0b6bd1fd09e4c339823b846f1ffecc61727fcc539618cfb2f6869790b5270237','[\"*\"]','2025-05-14 03:41:02',NULL,'2025-05-14 03:40:35','2025-05-14 03:41:02'),
(802,'App\\Models\\User',58,'authToken','438223fc3d91c32f23312c1024ede8635998aade4332638397b3a92b24b89a94','[\"*\"]',NULL,NULL,'2025-05-14 03:42:33','2025-05-14 03:42:33'),
(803,'App\\Models\\User',58,'authToken','08adc243c7047c0909b5e0ee3dbd8fca8083689ce083770863715f041904c7a7','[\"*\"]','2025-05-14 03:43:48',NULL,'2025-05-14 03:42:53','2025-05-14 03:43:48'),
(804,'App\\Models\\User',60,'authToken','219e65c0dfa55e67cc9150e71c6461d97eeb16d54528f7db3afd3694ca7bba83','[\"*\"]',NULL,NULL,'2025-05-14 03:43:08','2025-05-14 03:43:08'),
(805,'App\\Models\\User',5,'authToken','17000867305f820e8a836f3804ef4ead9e7d923d12a3c12b7798a24293054cd5','[\"*\"]','2025-05-14 03:50:30',NULL,'2025-05-14 03:44:18','2025-05-14 03:50:30'),
(806,'App\\Models\\User',61,'authToken','154d4230ee7ae909b079234f56b930bf36fb270f7bc34e6c4e78d5e9913b91a3','[\"*\"]',NULL,NULL,'2025-05-14 03:47:33','2025-05-14 03:47:33'),
(807,'App\\Models\\User',61,'authToken','ffac23f6d262241f35e583cd2f4b3c9eb264b668a113b5e58250aa4c0ff8e8f2','[\"*\"]','2025-05-14 03:51:01',NULL,'2025-05-14 03:49:40','2025-05-14 03:51:01'),
(808,'App\\Models\\User',1,'authToken','51246c3c8fbcdaf0029134f2aced04d74930115e7132e15ca8843597865a8e99','[\"*\"]','2025-05-14 03:51:29',NULL,'2025-05-14 03:51:01','2025-05-14 03:51:29'),
(809,'App\\Models\\User',5,'authToken','a4bebb9e7cc384da9313cb655f598b1688e24426e50a429f38eb8440bac1a70e','[\"*\"]','2025-05-14 04:17:10',NULL,'2025-05-14 03:51:52','2025-05-14 04:17:10'),
(810,'App\\Models\\User',1,'authToken','6a31e02bd11de14c60bb29640e8784a86f1754958c658c4de3a52735d348f4f8','[\"*\"]','2025-05-14 03:59:20',NULL,'2025-05-14 03:56:51','2025-05-14 03:59:20'),
(811,'App\\Models\\User',1,'authToken','52b7b20826f8c3b84d019c7adb6b463172a858cc3fb3214d16952d3be7563c3e','[\"*\"]','2025-05-14 04:19:44',NULL,'2025-05-14 04:18:56','2025-05-14 04:19:44'),
(812,'App\\Models\\User',1,'authToken','421de908795542ae89c581eb8e322d67c8bf05bb3dba7a937fbe50970a85ffaa','[\"*\"]','2025-05-14 04:24:06',NULL,'2025-05-14 04:23:55','2025-05-14 04:24:06'),
(813,'App\\Models\\User',5,'authToken','fdf3fadcbf4a855c996ca7a3c229fefa9449699640bd639a2ee8d0780415e9e9','[\"*\"]','2025-05-14 04:24:20',NULL,'2025-05-14 04:23:56','2025-05-14 04:24:20'),
(814,'App\\Models\\User',1,'authToken','5256f60801615241c3d993c40dbeabdb2af7f132f912787d0b0676ab4e8e1358','[\"*\"]','2025-05-14 04:28:17',NULL,'2025-05-14 04:25:20','2025-05-14 04:28:17'),
(815,'App\\Models\\User',1,'authToken','99bd4bfaa6d1b9c406a5efef8fcb7faea8c3e88335930fd240726e1b550a5e42','[\"*\"]','2025-05-14 04:27:33',NULL,'2025-05-14 04:26:48','2025-05-14 04:27:33'),
(816,'App\\Models\\User',5,'authToken','090081db815df8f53ac8c1c538c758c8c636f5a505eceba7b22b864d4e4f7781','[\"*\"]','2025-05-14 04:35:51',NULL,'2025-05-14 04:29:27','2025-05-14 04:35:51'),
(817,'App\\Models\\User',1,'authToken','981f98ec6735fb742a9974bc200cdaffce3af6b8bc7b5b68744f572e90f49265','[\"*\"]','2025-05-14 06:21:32',NULL,'2025-05-14 06:17:47','2025-05-14 06:21:32'),
(818,'App\\Models\\User',5,'authToken','63d313c2af44042df791c6a4220e542e3223e33ee90d17732b0074bd614e29d8','[\"*\"]','2025-05-14 07:53:52',NULL,'2025-05-14 06:23:25','2025-05-14 07:53:52'),
(819,'App\\Models\\User',5,'authToken','a0c5897bb99e7f8b3740b45bcb272b409839c7e4e4de5f724f44616ec879584d','[\"*\"]','2025-05-14 07:11:46',NULL,'2025-05-14 06:32:06','2025-05-14 07:11:46'),
(820,'App\\Models\\User',1,'authToken','68f30d3d11a92fac556abe772dcd875cc370e379fad9a776545fb1a1aaa45659','[\"*\"]','2025-05-14 06:55:01',NULL,'2025-05-14 06:42:46','2025-05-14 06:55:01'),
(821,'App\\Models\\User',1,'authToken','7f5b43be643979f457d5f6c8cc89e76e17c4b0cc8e73bba1da6f6fbf1a6aa300','[\"*\"]','2025-05-14 07:32:34',NULL,'2025-05-14 07:08:14','2025-05-14 07:32:34'),
(822,'App\\Models\\User',5,'authToken','3ba247a773fd76f864fbe3f0da61bdf09897481f2155ef8fb96bc25590bcbc3e','[\"*\"]','2025-05-14 07:55:04',NULL,'2025-05-14 07:17:21','2025-05-14 07:55:04'),
(823,'App\\Models\\User',1,'authToken','0b04933694b86d0641447cf331e5d7d9546614139eeda12beb5e6afe0882e18d','[\"*\"]','2025-05-14 07:33:44',NULL,'2025-05-14 07:26:48','2025-05-14 07:33:44'),
(824,'App\\Models\\User',1,'authToken','aebf1c717961e1f8ffdecb556ba18b715b85a098efddbc93236f7605ef437177','[\"*\"]','2025-05-14 08:33:54',NULL,'2025-05-14 07:54:04','2025-05-14 08:33:54'),
(825,'App\\Models\\User',46,'authToken','308a2c97c4634297bf02af88736550ff198f2e0e71e4e5062d775f1c7e20cdfa','[\"*\"]','2025-05-14 08:21:23',NULL,'2025-05-14 07:55:18','2025-05-14 08:21:23'),
(826,'App\\Models\\User',5,'authToken','4bbbc94b9f1e4580fbc3de6edb13f3dcb283dcc64a3bdab5c7d8825c5d0e663a','[\"*\"]','2025-05-14 08:38:43',NULL,'2025-05-14 07:57:46','2025-05-14 08:38:43'),
(827,'App\\Models\\User',1,'authToken','f2a0897d50575fffbcc8693e9f7d7ee92f1ac8328b8fbb0f75bdffaf9ccedf94','[\"*\"]','2025-05-14 08:33:57',NULL,'2025-05-14 08:13:44','2025-05-14 08:33:57'),
(828,'App\\Models\\User',1,'authToken','87ebd3779166b7c51105c8b5d5f19adcd0fd0a01116167c5c594e88a6cb866b8','[\"*\"]','2025-05-14 08:55:50',NULL,'2025-05-14 08:21:40','2025-05-14 08:55:50'),
(829,'App\\Models\\User',1,'authToken','1d29869bbb20924a47034f26999fafac568e2f5da5af9fe2d5f19984ca6356cb','[\"*\"]','2025-05-14 08:34:17',NULL,'2025-05-14 08:34:13','2025-05-14 08:34:17'),
(830,'App\\Models\\User',5,'authToken','0fde7074deb6b06af89e687cc6dcca9f5ce12b3bb4148f885fdb05a07cf8bcf5','[\"*\"]','2025-05-14 09:11:18',NULL,'2025-05-14 08:41:11','2025-05-14 09:11:18'),
(831,'App\\Models\\User',1,'authToken','b3e81caa3871453b8d1c5db15e687cbe305be8417ecd1729c3a3fb4fa90076fc','[\"*\"]','2025-05-14 09:02:35',NULL,'2025-05-14 08:53:23','2025-05-14 09:02:35'),
(832,'App\\Models\\User',1,'authToken','a1630f6974a2ab345cf84dc388c9f5a7863610a36618bda608963e360e50b5fe','[\"*\"]','2025-05-14 09:10:20',NULL,'2025-05-14 08:56:18','2025-05-14 09:10:20'),
(833,'App\\Models\\User',1,'authToken','d146efbc1f1d9d3ea626c99e66beb3f2dfb3961c5e08e981c69e67fa01a87f33','[\"*\"]','2025-05-14 09:03:29',NULL,'2025-05-14 08:56:42','2025-05-14 09:03:29'),
(834,'App\\Models\\User',3,'authToken','7526354679579545609738eeb2b55f174117d5c25c726687324ca7148bffbeed','[\"*\"]','2025-05-14 09:11:31',NULL,'2025-05-14 09:10:00','2025-05-14 09:11:31'),
(835,'App\\Models\\User',46,'authToken','157ca61e2fe7f6e8b776a68e9c724f3c76bb416d65d00642b4dd4922b20b2a35','[\"*\"]','2025-05-14 09:13:33',NULL,'2025-05-14 09:10:48','2025-05-14 09:13:33'),
(836,'App\\Models\\User',1,'authToken','9b171af4f627e366375e886577e8b4e58abbc8a61a765f5bbd83b0f649c1040b','[\"*\"]','2025-05-14 09:14:47',NULL,'2025-05-14 09:13:14','2025-05-14 09:14:47'),
(837,'App\\Models\\User',5,'authToken','5c1c19ba3eaad5b26e7625bd72a96afdb5ef3230b65d41a5359344588c21c61e','[\"*\"]','2025-05-14 09:25:01',NULL,'2025-05-14 09:13:20','2025-05-14 09:25:01'),
(838,'App\\Models\\User',1,'authToken','34539706ba6a9096e2451b2deaa835326b09d4e983b50ed056de6cc23406b8f2','[\"*\"]','2025-05-14 09:29:20',NULL,'2025-05-14 09:13:58','2025-05-14 09:29:20'),
(839,'App\\Models\\User',5,'authToken','e01e1ac0e6837d97a3ce5452c0dd8ddc11d13eceb4e9923ed6faa229af8eca89','[\"*\"]','2025-05-14 09:29:09',NULL,'2025-05-14 09:25:23','2025-05-14 09:29:09'),
(840,'App\\Models\\User',5,'authToken','756136016b0e6fb25853c323ac930ff95234e07a15bfda10d6ab1439d69150e8','[\"*\"]','2025-05-14 09:37:56',NULL,'2025-05-14 09:29:43','2025-05-14 09:37:56'),
(841,'App\\Models\\User',5,'authToken','57fe89fd3559c03def6a3145f1af6e508b425395560b75d3b291eace0fe7fffa','[\"*\"]','2025-05-14 15:06:49',NULL,'2025-05-14 12:53:20','2025-05-14 15:06:49'),
(842,'App\\Models\\User',5,'authToken','956c7ff1b3d7128d344a3f99d8f289bf8fe0c7e394179ce3fbdcd9548d14f60b','[\"*\"]','2025-05-14 14:02:24',NULL,'2025-05-14 14:00:01','2025-05-14 14:02:24'),
(843,'App\\Models\\User',5,'authToken','106373b522b3991edaee56f48511c4880efb91819becb15bc614611635d73761','[\"*\"]','2025-05-14 15:19:56',NULL,'2025-05-14 14:48:05','2025-05-14 15:19:56'),
(844,'App\\Models\\User',5,'authToken','8503dc833ee3b383c692f7b57342ecd4f6f9149a215021c7a40f5e20c53559c5','[\"*\"]','2025-05-15 03:20:23',NULL,'2025-05-14 15:13:34','2025-05-15 03:20:23'),
(845,'App\\Models\\User',5,'authToken','f63a7df00400f469257b2297b72657a2924b17df65d31296dcd70cfd792b23c0','[\"*\"]','2025-05-14 16:27:26',NULL,'2025-05-14 15:30:53','2025-05-14 16:27:26'),
(846,'App\\Models\\User',5,'authToken','3a46278edaa0d394ab8f0c1202bb3f3248e5d92d58b545983f59a491f408e2e4','[\"*\"]','2025-05-14 15:49:39',NULL,'2025-05-14 15:47:26','2025-05-14 15:49:39'),
(847,'App\\Models\\User',5,'authToken','1618acc414518d885ab390937bf0163b3cfe41e2ea7bc28b10678af374061451','[\"*\"]','2025-05-14 15:50:13',NULL,'2025-05-14 15:50:06','2025-05-14 15:50:13'),
(848,'App\\Models\\User',5,'authToken','645596468ba775bee6282a63b6ecd5b6f7b6539c802e11f5d9641a97a84089af','[\"*\"]','2025-05-14 16:37:29',NULL,'2025-05-14 16:07:11','2025-05-14 16:37:29'),
(849,'App\\Models\\User',5,'authToken','eda96c7e4104be80b5d942acbaa71373e82d62cb3628abfee03f06785998061e','[\"*\"]','2025-05-14 16:36:02',NULL,'2025-05-14 16:31:21','2025-05-14 16:36:02'),
(850,'App\\Models\\User',1,'authToken','8dbceb5b892b9df741650d17d25d7580c7fc31bc3a5da337abe8bf4b222922b3','[\"*\"]','2025-05-15 01:09:35',NULL,'2025-05-15 01:05:06','2025-05-15 01:09:35'),
(851,'App\\Models\\User',5,'authToken','1b642f6124eba8eef320d79abe66955dc16703ce018b7b1aeb69f8755b6d3826','[\"*\"]','2025-05-15 01:22:59',NULL,'2025-05-15 01:05:42','2025-05-15 01:22:59'),
(852,'App\\Models\\User',1,'authToken','f6d61d6aa516d8cbaf058b97493d2898ec8862d891030dc079c7b7e5f5b49ece','[\"*\"]','2025-05-15 01:19:15',NULL,'2025-05-15 01:06:17','2025-05-15 01:19:15'),
(853,'App\\Models\\User',1,'authToken','eefe57b69fa5a65613618d907f20a12b411e5a3953821a4901b1dcb872eb5fd4','[\"*\"]','2025-05-15 01:14:55',NULL,'2025-05-15 01:14:34','2025-05-15 01:14:55'),
(854,'App\\Models\\User',1,'authToken','628073ae91ecec69b9ea367b1e277681ba1f37ecc6b1be582b7c9f7a42a99c02','[\"*\"]','2025-05-15 02:11:56',NULL,'2025-05-15 01:17:33','2025-05-15 02:11:56'),
(855,'App\\Models\\User',1,'authToken','db21e9359c4a2487e2186217a1cb668ac907246f0dfa3ac4988a538284bed79e','[\"*\"]','2025-05-15 01:34:56',NULL,'2025-05-15 01:20:00','2025-05-15 01:34:56'),
(856,'App\\Models\\User',5,'authToken','65e14ea2a9774b9a79f890949e6ae1d5d518f03d815e993fe8c063fd8eed7e64','[\"*\"]','2025-05-15 01:59:38',NULL,'2025-05-15 01:25:25','2025-05-15 01:59:38'),
(857,'App\\Models\\User',46,'authToken','7229b2a52a40eb0540d07d4228e6a746ab27a5dfccc3106e461d68cf1d9e50a4','[\"*\"]','2025-05-15 02:30:26',NULL,'2025-05-15 02:01:21','2025-05-15 02:30:26'),
(858,'App\\Models\\User',1,'authToken','abbabb4fbc4a399fda875a2125192a41888c3b24b3d90679e0f74bf2ac58e8b0','[\"*\"]','2025-05-15 02:10:35',NULL,'2025-05-15 02:03:54','2025-05-15 02:10:35'),
(859,'App\\Models\\User',5,'authToken','9e0199365c0147cc9d9e9d0087ff994f88c1889cca6fda52b2e55c19aa3bcb54','[\"*\"]','2025-05-15 02:07:27',NULL,'2025-05-15 02:04:07','2025-05-15 02:07:27'),
(860,'App\\Models\\User',1,'authToken','e43ae2b1f506108ab57e6b998e6dfb0d1301b20ef89a956ff3eda3a2c9b95ae4','[\"*\"]','2025-05-15 02:09:42',NULL,'2025-05-15 02:07:53','2025-05-15 02:09:42'),
(861,'App\\Models\\User',1,'authToken','da332fedfb897aeff3cb6b80d0e417fa57025e764895739e82a6b9474f2a6745','[\"*\"]','2025-05-15 02:42:11',NULL,'2025-05-15 02:21:51','2025-05-15 02:42:11'),
(862,'App\\Models\\User',5,'authToken','4f66e0b388fd5ee6146776f2c237c3012242360019f1ca72c1f2d5ee1b3eed48','[\"*\"]','2025-05-15 02:47:55',NULL,'2025-05-15 02:42:46','2025-05-15 02:47:55'),
(863,'App\\Models\\User',46,'authToken','525a1a496704c4b83ce49b71e19391857d6a34a11ea1f0ef1275bfb091978f44','[\"*\"]','2025-05-15 03:08:08',NULL,'2025-05-15 03:04:37','2025-05-15 03:08:08'),
(864,'App\\Models\\User',1,'authToken','547f1d292befdf2721a7f7d01c3acc1308995fcb7b6cb8d2d7109b3a69998a51','[\"*\"]','2025-05-15 03:23:56',NULL,'2025-05-15 03:20:40','2025-05-15 03:23:56'),
(865,'App\\Models\\User',5,'authToken','09a05ca84a98e19f194424cbb2d279b623c8e00e4e9504394c0b1a91fa96673c','[\"*\"]','2025-05-15 03:50:58',NULL,'2025-05-15 03:46:34','2025-05-15 03:50:58'),
(866,'App\\Models\\User',5,'authToken','7fbd9d30e58bb7a8356f3ffc36e9cfe1002e263e697b8e47f33113a6aaf8355b','[\"*\"]','2025-05-15 04:53:47',NULL,'2025-05-15 03:56:36','2025-05-15 04:53:47'),
(867,'App\\Models\\User',5,'authToken','b901bd68dfe3c38c180d31d0542de0ad61912a1261cada2d6aadc0a852bc87bc','[\"*\"]','2025-05-15 07:56:28',NULL,'2025-05-15 04:44:42','2025-05-15 07:56:28'),
(868,'App\\Models\\User',46,'authToken','4e2cfaab1c9d1a526b249454e562f802f4e670e4e62ce328b43afcd454b7b680','[\"*\"]','2025-05-15 07:11:19',NULL,'2025-05-15 06:31:18','2025-05-15 07:11:19'),
(869,'App\\Models\\User',5,'authToken','ee82ffae55d6f1712c9ba80a2b374f1429682b3622b4e11cc4f3cea44904d17d','[\"*\"]','2025-05-15 08:23:00',NULL,'2025-05-15 07:45:57','2025-05-15 08:23:00'),
(870,'App\\Models\\User',5,'authToken','47d841d229579102d057251dacd5a13b20628fa791caa3f0347a33b2e41a1f7f','[\"*\"]','2025-05-15 08:25:41',NULL,'2025-05-15 07:59:02','2025-05-15 08:25:41'),
(871,'App\\Models\\User',5,'authToken','287e4a6702ca069c7485a43f8a064413b33d7d87d9e0cf4a75574954e2f1809b','[\"*\"]','2025-05-15 09:27:43',NULL,'2025-05-15 08:35:52','2025-05-15 09:27:43'),
(872,'App\\Models\\User',5,'authToken','4b5cbfc88d9dbdd6343e398be6bf977f042291c796fcffbf79ff55c410013112','[\"*\"]','2025-05-15 09:33:33',NULL,'2025-05-15 08:43:26','2025-05-15 09:33:33'),
(873,'App\\Models\\User',1,'authToken','88b6d18beeb9b0f62a9b4e32acd803f9c278d2174bb027eea03225343d79aaf6','[\"*\"]','2025-05-15 09:01:23',NULL,'2025-05-15 08:58:05','2025-05-15 09:01:23');

/*Table structure for table `properties` */

DROP TABLE IF EXISTS `properties`;

CREATE TABLE `properties` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `province_id` BIGINT UNSIGNED NOT NULL,
  `city_id` BIGINT UNSIGNED NOT NULL,
  `district_id` BIGINT UNSIGNED NOT NULL,
  `subdistrict_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `isDeleted` TINYINT(1) NOT NULL DEFAULT '0',
  `price` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `image` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `property_type_id` BIGINT UNSIGNED NOT NULL,
  `capacity` INT DEFAULT '1',
  `available_rooms` INT NOT NULL DEFAULT '1',
  `rules` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `address` TEXT COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` DECIMAL(10,8) NOT NULL,
  `longitude` DECIMAL(11,8) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `properties_user_id_foreign` (`user_id`),
  KEY `properties_subdistrict_id_foreign` (`subdistrict_id`),
  KEY `properties_district_id_foreign` (`district_id`),
  KEY `properties_city_id_foreign` (`city_id`),
  KEY `properties_province_id_foreign` (`province_id`),
  KEY `properties_property_type_id_foreign` (`property_type_id`),
  CONSTRAINT `properties_city_id_foreign` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`) ON DELETE CASCADE,
  CONSTRAINT `properties_district_id_foreign` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `properties_property_type_id_foreign` FOREIGN KEY (`property_type_id`) REFERENCES `property_types` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `properties_province_id_foreign` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`) ON DELETE CASCADE,
  CONSTRAINT `properties_subdistrict_id_foreign` FOREIGN KEY (`subdistrict_id`) REFERENCES `subdistricts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `properties_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `properties` */

INSERT  INTO `properties`(`id`,`name`,`description`,`user_id`,`province_id`,`city_id`,`district_id`,`subdistrict_id`,`created_at`,`updated_at`,`isDeleted`,`price`,`image`,`property_type_id`,`capacity`,`available_rooms`,`rules`,`address`,`latitude`,`longitude`) VALUES 
(1,'Dangbel Kost','Menyala Simangulampe',1,2,5,2,5,'2025-04-14 14:03:05','2025-04-17 13:57:37',1,1500000.00,'property_images/6EGzTfNZbwA0bYnyYu312GexxSlGKDQyAFfIVpjw.png',1,45,5,'tidak bisa bawa pacar','dangbel jov lov',-2.54994412,118.00483858),
(2,'Kost Tony','test ja',1,2,5,2,6,'2025-04-17 02:30:21','2025-04-17 02:30:21',0,700000.00,'properties/R9fiAqHPh4lGy1E2hCsmCmoAiUlENREUm9f9CPHh.png',1,5,2,'ihfu','simangulampe',-2.54890000,118.01490000),
(3,'Homestay Gun','test aja',1,2,5,9,2,'2025-04-17 06:53:35','2025-04-17 06:53:35',0,800000.00,'properties/mblk0TCeDDT9Sn7cJl5tIovbCWSLaXHNzzV8MP8a.png',1,10,6,'jas slebew','simangulampe',-2.54890000,118.01490000),
(4,'Tony','test aja',1,2,5,9,1,'2025-04-17 07:50:16','2025-04-17 07:50:16',0,5000000.00,'properties/orppenL79ozDwLWsG1AVUp45W7TFpKj9lEH71C00.png',1,10,5,'yah','simangulampe',-2.54890000,118.01490000),
(5,'Ionc','dwd',1,2,5,9,3,'2025-04-17 08:01:52','2025-04-17 08:01:52',0,2000000.00,'properties/wJMVY6kCr8wMnMsmDb7QniuFHxteGebVdHO1lSMC.png',1,10,3,'dw','Desa Aek Raja',-2.54890000,118.01490000),
(8,'bambang','knflq',1,2,5,2,5,'2025-04-17 08:51:07','2025-04-17 08:51:07',0,900000.00,'properties/QN4ns4Ntdg9G54OX7UxUoECycAQ8RvkVXHBjprcm.png',1,1,2,'frfe','simangulampe',-2.54890000,118.01490000),
(10,'Anisetus Manalu','test',1,2,5,2,6,'2025-04-17 09:15:11','2025-04-17 09:15:11',0,1000000.00,'properties/cUAhwEsK08mY7eUUvAHQiyHf3RZyltCNAcbfivAh.png',2,10,0,'tw','Desa Aek Raja',-2.54890000,118.01490000),
(11,'Anisetus Manalu','test aja',1,2,5,2,5,'2025-04-18 01:24:00','2025-04-18 01:24:00',0,2000000.00,'properties/eURVB3opFianw9EUh1gsj0txxnXjmXI0jSqVbeyF.jpg',1,50,6,'dialarang bawa pacar','Soposurung jl.Sibrandus Van Rossum',2.89490000,98.76040000),
(12,'Kost Gabe','test aja bang',10,2,5,9,3,'2025-04-21 03:37:30','2025-04-21 03:37:30',0,800000.00,'properties/0W2xWVPDyuDmuOT6gimvEJOFEk5g4p67ST8CZ3ME.jpg',1,2,10,'nanti aja','Sitoluama',-2.54994412,98.67220000),
(13,'Kost Tony','ygdais',1,2,5,9,3,'2025-04-23 08:58:57','2025-04-23 08:58:57',0,700000.00,NULL,1,50,6,'test aja','sitoluama',2.33349510,99.06676210),
(14,'danbel','ghfd',1,2,5,2,5,'2025-04-25 01:09:30','2025-04-25 01:09:30',0,234.00,NULL,1,2,23,'dfbgngfd','ngfhfdgdgd',23.00000000,23.00000000),
(15,'danbel','ghfd',1,2,5,2,5,'2025-04-25 01:09:44','2025-04-25 01:09:44',0,234.00,NULL,1,2,23,'dfbgngfd','ngfhfdgdgd',23.00000000,23.00000000),
(16,'daniiii','cghvmb,',1,2,5,2,5,'2025-04-25 01:36:58','2025-04-25 01:36:58',0,5643324.00,NULL,1,123,34,'rtdyughijlk','sdfgsd',12.00000000,12.00000000),
(17,'jdjdk','jdjsk',1,2,5,2,6,'2025-04-25 02:30:37','2025-04-25 02:30:37',0,500000.00,'properties/WYg8KhbYJJ8j4CmMCFTWsZN2MtvRqQSYswbhmT5D.jpg',1,20,3,'ej','sjsj',2.33370000,2.65998300),
(18,'sdfghj','hgfertyjh',1,2,5,2,6,'2025-04-25 02:48:34','2025-04-25 02:48:34',0,234567.00,'properties/j9lEuGB0Jj3f81jZcjYwLAX29Ut6MSCX1gaTQjDm.png',1,23,23,'ertgyhjhg','sdfvcx',34.00000000,234.00000000),
(19,'Kost Razes','Test',1,2,5,2,6,'2025-04-25 09:08:20','2025-04-25 09:08:20',0,500.00,'properties/6HY6h8NA3UaNgWAZijwHZCs57p5GWUHK8ylURO0e.png',1,25,10,'Test','Jln. Balige Sumatera Utara',1.00000000,1.00000000),
(24,'Kost Tony1','doqn',1,2,5,2,6,'2025-04-27 14:35:41','2025-04-27 14:35:41',0,500.00,'properties/DKIbDANhmYTlY6D92dEd6hzuh2jGHSiTqVk8QmiP.jpg',1,20,2,'jonwf','simangulampe',-2.54890000,118.01490000),
(25,'sudahbisagalery','wale',1,2,5,2,6,'2025-04-27 14:48:10','2025-04-28 04:30:08',0,500.00,'properties/9hqvOvtCEgxG2VzPGnWIhhqFUPjTDW4uxXYIrrYV.jpg',1,10,2,'fo','simi',-2.54890000,118.01490000),
(26,'yahh','jef',1,2,5,2,6,'2025-04-28 11:33:05','2025-04-28 11:33:05',0,500.00,'properties/QlhAS8ZeW2QaxSCmfemrUKps4FEYae6yMkL9AAEA.jpg',1,1,2,'deib','lol',2.31919894,98.81630710),
(33,'dw','das',1,2,5,2,5,'2025-04-29 02:35:16','2025-04-29 02:35:43',1,500000.00,'properties/cGGtvXkOjsG7eUEkdOiZimvszbwTuDB9AYgdU33S.png',1,10,2,'cacs','Desa Aek Raja',-2.54890000,118.01490000),
(34,'qwertyui','asdfghjgfds',1,2,5,2,5,'2025-04-29 09:35:33','2025-04-29 09:35:33',0,12345.00,'properties/uSrfsm69hv068nCw4F6fzaJZZmEVjF7ZwFbz3Ycx.png',1,12,12,'qwerty','sdfghjgf',12.00000000,43.00000000),
(35,'Homestay','cobahomestay',1,2,5,2,6,'2025-04-30 16:30:19','2025-05-10 16:09:45',0,500000.00,'properties/7Xs34IuF116JX4mZOKCzeBiOYRRlRYW2zgAa9MLU.jpg',2,33,0,'hgjgfd','jln gfkjdg',23.00000000,43.00000000),
(36,'kskbk','ejej',1,2,5,2,5,'2025-05-02 02:31:37','2025-05-10 16:10:06',0,500000.00,'properties/180xlVN70zcNAibQW21k875BdFzbQmBjIqk3X6rW.jpg',1,46,20,'shwj','whsjj',1.65659900,40.65956000),
(37,'togud','kost',1,2,5,9,1,'2025-05-02 02:55:18','2025-05-09 07:19:42',0,20000.00,'properties/nKPUHCx4squ167rIy8DO5ucXc4FGy4a12YZJq1jS.jpg',1,4,2,'bebasss','sitol',-6.20876300,106.84559900),
(38,'Amba kost','y',1,2,5,2,5,'2025-05-08 01:43:20','2025-05-09 07:06:11',0,100000.00,'properties/YAW5z187BNJW6UmAKV9REILlskH4zwtUtnn9Q5nc.jpg',1,2,1,'y','sitol bagian dalam',48.85840000,2.29450000),
(39,'Pope Francis','yolo',1,2,5,2,6,'2025-05-09 04:13:31','2025-05-09 09:10:40',0,2000000.00,'properties/Te2IkBeUFjk91mHqzJCYVhhH6WL6J9q0tauAS1oc.jpg',1,20,5,'rajin doa','Jl.roma',2.38643980,99.14686820),
(40,'Homestay Manalu','wdefrghgjdhg',1,2,5,2,6,'2025-05-10 23:47:22','2025-05-12 13:38:26',0,200000.00,'properties/9vuA2sHW2djaNrTgS71CCoS9zYfYttTkRWr3k1jU.jpg',2,10,0,'sdfdbrhgtyet','qwertyuikth',2.34564500,3.45675600),
(41,'Kost Tony','Kost aman dan nyaman',1,2,5,9,3,'2025-05-12 13:25:02','2025-05-12 13:25:02',0,500000.00,'properties/Bh2qRWsch8gkSyTuualIq8TCrv6tNiGoCgyn2osZ.jpg',1,1,5,'tidak bisa bawa pacar ke kamar','Sitoluama, Laguboti',2.38208203,99.15040794),
(42,'Kost Razes','tempat nyaman dan nyaman',1,2,5,9,3,'2025-05-12 13:29:42','2025-05-13 08:39:31',0,800000.00,'properties/BJlaGLLXs6LxLdfHJpytUZKTSLRiYuUCCHASsJ1N.jpg',1,NULL,5,'bole saja','Sitoluama, Laguboti',2.38341464,99.15003672),
(43,'Homestay Bahagia Bulbul','nyaman dan bersih',1,2,5,2,6,'2025-05-12 13:32:02','2025-05-13 15:32:35',0,2000000.00,'properties/KI4WbtGLZthNpf35rrZCCSLnSyPYPetQu9RUIALh.png',2,30,0,'tertib ya','Bulbul, balige',2.38341464,99.15003672);

/*Table structure for table `property_availability` */

DROP TABLE IF EXISTS `property_availability`;

CREATE TABLE `property_availability` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `property_id` BIGINT UNSIGNED NOT NULL,
  `date` DATE NOT NULL COMMENT 'Tanggal ketersediaan',
  `status` ENUM('available','booked','maintenance') NOT NULL DEFAULT 'available',
  `booking_id` BIGINT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `property_availability_property_id_date_unique` (`property_id`,`date`),
  KEY `property_availability_booking_id_foreign` (`booking_id`),
  CONSTRAINT `property_availability_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `property_availability_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `property_availability` */

INSERT  INTO `property_availability`(`id`,`property_id`,`date`,`status`,`booking_id`,`created_at`,`updated_at`) VALUES 
(1,35,'2025-05-01','booked',3,'2025-04-30 19:41:53','2025-04-30 19:43:01'),
(2,35,'2025-05-02','booked',3,'2025-04-30 19:41:54','2025-04-30 19:43:02'),
(3,35,'2025-05-03','booked',3,'2025-04-30 19:41:54','2025-04-30 19:43:02'),
(4,35,'2025-05-04','booked',3,'2025-04-30 19:41:54','2025-04-30 19:43:03'),
(5,35,'2025-05-05','booked',3,'2025-04-30 19:41:55','2025-04-30 19:43:03'),
(6,34,'2025-05-01','booked',4,'2025-04-30 19:47:09','2025-04-30 19:47:09'),
(7,34,'2025-05-02','booked',4,'2025-04-30 19:47:09','2025-04-30 19:47:09'),
(8,34,'2025-05-03','booked',4,'2025-04-30 19:47:10','2025-04-30 19:47:10'),
(9,34,'2025-05-04','booked',4,'2025-04-30 19:47:10','2025-04-30 19:47:10'),
(10,34,'2025-05-05','booked',4,'2025-04-30 19:47:10','2025-04-30 19:47:10'),
(11,37,'2025-05-06','booked',13,'2025-05-06 09:40:39','2025-05-06 09:45:18'),
(12,37,'2025-05-07','booked',13,'2025-05-06 09:40:40','2025-05-06 09:45:18'),
(13,37,'2025-05-08','booked',14,'2025-05-06 09:40:40','2025-05-08 06:42:42'),
(14,37,'2025-05-09','booked',14,'2025-05-06 09:40:41','2025-05-08 06:42:43'),
(15,37,'2025-05-10','booked',13,'2025-05-06 09:40:41','2025-05-06 09:45:19'),
(16,37,'2025-05-11','booked',13,'2025-05-06 09:40:42','2025-05-06 09:45:20'),
(17,37,'2025-05-12','booked',13,'2025-05-06 09:40:42','2025-05-06 09:45:20'),
(18,37,'2025-05-13','booked',13,'2025-05-06 09:40:42','2025-05-06 09:45:21'),
(19,37,'2025-05-14','booked',13,'2025-05-06 09:40:43','2025-05-06 09:45:21'),
(20,37,'2025-05-15','booked',13,'2025-05-06 09:40:44','2025-05-06 09:45:21'),
(21,37,'2025-05-16','booked',13,'2025-05-06 09:40:44','2025-05-06 09:45:22'),
(22,37,'2025-05-17','booked',13,'2025-05-06 09:40:45','2025-05-06 09:45:22'),
(23,37,'2025-05-18','booked',13,'2025-05-06 09:40:45','2025-05-06 09:45:23'),
(24,37,'2025-05-19','booked',13,'2025-05-06 09:40:46','2025-05-06 09:45:23'),
(25,37,'2025-05-20','booked',13,'2025-05-06 09:40:46','2025-05-06 09:45:23'),
(26,37,'2025-05-21','booked',13,'2025-05-06 09:40:46','2025-05-06 09:45:24'),
(27,37,'2025-05-22','booked',13,'2025-05-06 09:40:47','2025-05-06 09:45:24'),
(28,37,'2025-05-23','booked',13,'2025-05-06 09:40:47','2025-05-06 09:45:24'),
(29,37,'2025-05-24','booked',13,'2025-05-06 09:40:47','2025-05-06 09:45:25'),
(30,37,'2025-05-25','booked',13,'2025-05-06 09:40:48','2025-05-06 09:45:25'),
(31,37,'2025-05-26','booked',13,'2025-05-06 09:40:49','2025-05-06 09:45:26'),
(32,37,'2025-05-27','booked',13,'2025-05-06 09:40:49','2025-05-06 09:45:26'),
(33,37,'2025-05-28','booked',13,'2025-05-06 09:40:51','2025-05-06 09:45:26'),
(34,37,'2025-05-29','booked',13,'2025-05-06 09:40:51','2025-05-06 09:45:27'),
(35,37,'2025-05-30','booked',13,'2025-05-06 09:40:52','2025-05-06 09:45:27'),
(36,37,'2025-05-31','booked',13,'2025-05-06 09:40:52','2025-05-06 09:45:27'),
(37,37,'2025-06-01','booked',13,'2025-05-06 09:40:53','2025-05-06 09:45:28'),
(38,37,'2025-06-02','booked',13,'2025-05-06 09:40:53','2025-05-06 09:45:28'),
(39,37,'2025-06-03','booked',13,'2025-05-06 09:40:53','2025-05-06 09:45:28'),
(40,37,'2025-06-04','booked',13,'2025-05-06 09:40:54','2025-05-06 09:45:29'),
(41,37,'2025-06-05','booked',13,'2025-05-06 09:40:55','2025-05-06 09:45:29'),
(42,38,'2025-05-09','booked',15,'2025-05-09 11:09:41','2025-05-09 11:09:41'),
(43,38,'2025-05-10','booked',43,'2025-05-09 11:09:42','2025-05-10 03:52:39'),
(44,39,'2025-05-12','available',NULL,'2025-05-09 15:33:44','2025-05-12 00:49:39'),
(45,39,'2025-05-13','booked',44,'2025-05-09 15:33:45','2025-05-10 09:31:19'),
(46,39,'2025-05-14','booked',56,'2025-05-09 15:33:45','2025-05-14 08:06:02'),
(47,39,'2025-05-15','booked',56,'2025-05-09 15:33:45','2025-05-14 08:06:02'),
(48,26,'2025-05-10','available',NULL,'2025-05-09 15:48:03','2025-05-10 02:32:00'),
(49,26,'2025-05-11','available',NULL,'2025-05-09 15:48:04','2025-05-10 02:32:00'),
(50,26,'2025-05-12','booked',23,'2025-05-09 15:48:04','2025-05-09 16:14:13'),
(51,26,'2025-05-13','booked',23,'2025-05-09 15:48:04','2025-05-09 16:14:14'),
(52,26,'2025-05-09','booked',22,'2025-05-09 16:06:52','2025-05-09 16:06:52'),
(53,26,'2025-05-14','booked',23,'2025-05-09 16:14:14','2025-05-09 16:14:14'),
(54,26,'2025-05-15','booked',23,'2025-05-09 16:14:14','2025-05-09 16:14:14'),
(55,26,'2025-05-16','booked',23,'2025-05-09 16:14:15','2025-05-09 16:14:15'),
(56,26,'2025-05-17','booked',23,'2025-05-09 16:14:15','2025-05-09 16:14:15'),
(57,26,'2025-05-18','booked',23,'2025-05-09 16:14:15','2025-05-09 16:14:15'),
(58,26,'2025-05-19','booked',23,'2025-05-09 16:14:16','2025-05-09 16:14:16'),
(59,26,'2025-05-20','booked',23,'2025-05-09 16:14:16','2025-05-09 16:14:16'),
(60,26,'2025-05-21','booked',23,'2025-05-09 16:14:16','2025-05-09 16:14:16'),
(61,26,'2025-05-22','booked',23,'2025-05-09 16:14:17','2025-05-09 16:14:17'),
(62,26,'2025-05-23','booked',23,'2025-05-09 16:14:17','2025-05-09 16:14:17'),
(63,26,'2025-05-24','booked',23,'2025-05-09 16:14:17','2025-05-09 16:14:17'),
(64,26,'2025-05-25','booked',23,'2025-05-09 16:14:18','2025-05-09 16:14:18'),
(65,26,'2025-05-26','booked',23,'2025-05-09 16:14:18','2025-05-09 16:14:18'),
(66,26,'2025-05-27','booked',23,'2025-05-09 16:14:19','2025-05-09 16:14:19'),
(67,26,'2025-05-28','booked',23,'2025-05-09 16:14:19','2025-05-09 16:14:19'),
(68,26,'2025-05-29','booked',23,'2025-05-09 16:14:19','2025-05-09 16:14:19'),
(69,26,'2025-05-30','booked',23,'2025-05-09 16:14:20','2025-05-09 16:14:20'),
(70,26,'2025-05-31','booked',23,'2025-05-09 16:14:20','2025-05-09 16:14:20'),
(71,26,'2025-06-01','booked',23,'2025-05-09 16:14:21','2025-05-09 16:14:21'),
(72,26,'2025-06-02','booked',23,'2025-05-09 16:14:21','2025-05-09 16:14:21'),
(73,26,'2025-06-03','booked',23,'2025-05-09 16:14:21','2025-05-09 16:14:21'),
(74,2,'2025-05-10','available',NULL,'2025-05-09 17:43:13','2025-05-12 12:20:41'),
(75,2,'2025-05-11','available',NULL,'2025-05-09 17:43:13','2025-05-12 12:20:41'),
(76,38,'2025-05-11','booked',43,'2025-05-09 17:58:45','2025-05-10 03:52:39'),
(77,38,'2025-05-12','available',NULL,'2025-05-09 17:58:45','2025-05-12 02:26:44'),
(78,38,'2025-05-13','available',NULL,'2025-05-09 17:58:46','2025-05-12 02:26:44'),
(79,38,'2025-05-14','available',NULL,'2025-05-09 18:23:32','2025-05-10 02:25:41'),
(80,38,'2025-05-15','available',NULL,'2025-05-09 18:23:32','2025-05-10 02:25:41'),
(81,38,'2025-05-16','available',NULL,'2025-05-09 18:23:33','2025-05-10 02:25:41'),
(82,38,'2025-05-17','available',NULL,'2025-05-09 18:23:33','2025-05-10 02:25:41'),
(83,38,'2025-05-18','available',NULL,'2025-05-09 18:23:33','2025-05-10 02:25:41'),
(84,38,'2025-05-19','available',NULL,'2025-05-09 18:23:34','2025-05-10 02:25:41'),
(85,38,'2025-05-20','available',NULL,'2025-05-09 18:23:34','2025-05-10 02:25:41'),
(86,38,'2025-05-21','available',NULL,'2025-05-09 20:30:43','2025-05-10 02:25:41'),
(87,38,'2025-05-22','available',NULL,'2025-05-09 20:30:43','2025-05-10 02:25:41'),
(88,38,'2025-05-23','available',NULL,'2025-05-09 20:30:44','2025-05-10 02:25:41'),
(89,38,'2025-05-24','available',NULL,'2025-05-09 20:30:44','2025-05-10 02:25:41'),
(90,38,'2025-05-25','available',NULL,'2025-05-09 20:30:44','2025-05-10 02:25:41'),
(91,38,'2025-05-26','available',NULL,'2025-05-09 20:30:45','2025-05-10 02:25:41'),
(92,38,'2025-05-27','available',NULL,'2025-05-09 20:30:45','2025-05-10 02:25:41'),
(93,38,'2025-05-28','available',NULL,'2025-05-09 20:30:45','2025-05-10 02:25:41'),
(94,38,'2025-05-29','available',NULL,'2025-05-09 20:30:45','2025-05-10 02:25:41'),
(95,38,'2025-05-30','available',NULL,'2025-05-09 20:30:46','2025-05-10 02:25:41'),
(96,38,'2025-05-31','available',NULL,'2025-05-09 20:30:46','2025-05-10 02:25:41'),
(97,38,'2025-06-01','available',NULL,'2025-05-09 20:30:47','2025-05-10 02:25:41'),
(98,38,'2025-06-02','available',NULL,'2025-05-09 20:30:47','2025-05-10 02:25:41'),
(99,38,'2025-06-03','available',NULL,'2025-05-09 20:30:47','2025-05-10 02:25:41'),
(100,38,'2025-06-04','available',NULL,'2025-05-09 20:30:48','2025-05-10 02:25:41'),
(101,38,'2025-06-05','available',NULL,'2025-05-09 20:30:48','2025-05-10 02:25:41'),
(102,38,'2025-06-06','available',NULL,'2025-05-09 20:30:49','2025-05-10 02:25:41'),
(103,38,'2025-06-07','available',NULL,'2025-05-09 20:30:49','2025-05-10 02:25:41'),
(104,38,'2025-06-08','available',NULL,'2025-05-09 20:30:49','2025-05-10 02:25:41'),
(105,38,'2025-06-09','available',NULL,'2025-05-09 20:30:50','2025-05-10 02:25:41'),
(106,38,'2025-06-10','available',NULL,'2025-05-09 20:30:50','2025-05-10 02:25:41'),
(107,38,'2025-06-11','available',NULL,'2025-05-09 20:30:51','2025-05-10 02:25:41'),
(108,38,'2025-06-12','available',NULL,'2025-05-09 20:30:51','2025-05-10 02:25:41'),
(109,10,'2025-05-10','available',NULL,'2025-05-10 02:46:19','2025-05-12 07:38:14'),
(110,10,'2025-05-11','available',NULL,'2025-05-10 02:46:19','2025-05-12 07:38:14'),
(111,10,'2025-05-12','available',NULL,'2025-05-10 02:46:19','2025-05-12 07:38:14'),
(112,10,'2025-05-13','available',NULL,'2025-05-10 02:46:20','2025-05-12 07:38:14'),
(113,10,'2025-05-14','available',NULL,'2025-05-10 02:46:20','2025-05-12 07:38:14'),
(114,10,'2025-05-15','available',NULL,'2025-05-10 02:46:20','2025-05-12 07:38:14'),
(115,10,'2025-05-16','available',NULL,'2025-05-10 02:46:21','2025-05-12 07:38:14'),
(116,10,'2025-05-17','available',NULL,'2025-05-10 02:46:21','2025-05-12 07:38:14'),
(117,10,'2025-05-18','available',NULL,'2025-05-10 02:46:21','2025-05-12 07:38:14'),
(118,10,'2025-05-19','available',NULL,'2025-05-10 02:46:22','2025-05-12 07:38:14'),
(119,10,'2025-05-20','available',NULL,'2025-05-10 02:46:22','2025-05-12 07:38:14'),
(120,10,'2025-05-21','available',NULL,'2025-05-10 02:46:22','2025-05-12 07:38:14'),
(121,10,'2025-05-22','available',NULL,'2025-05-10 02:46:22','2025-05-12 07:38:14'),
(122,10,'2025-05-23','available',NULL,'2025-05-10 02:46:23','2025-05-12 07:38:14'),
(123,10,'2025-05-24','available',NULL,'2025-05-10 02:46:23','2025-05-12 07:38:14'),
(124,10,'2025-05-25','available',NULL,'2025-05-10 02:46:23','2025-05-12 07:38:14'),
(125,10,'2025-05-26','available',NULL,'2025-05-10 02:46:24','2025-05-12 07:38:14'),
(126,10,'2025-05-27','available',NULL,'2025-05-10 02:46:24','2025-05-12 07:38:14'),
(127,10,'2025-05-28','available',NULL,'2025-05-10 02:46:24','2025-05-12 07:38:14'),
(128,10,'2025-05-29','available',NULL,'2025-05-10 02:46:25','2025-05-12 07:38:14'),
(129,10,'2025-05-30','available',NULL,'2025-05-10 02:46:25','2025-05-12 07:38:14'),
(130,10,'2025-05-31','available',NULL,'2025-05-10 02:46:26','2025-05-12 07:38:14'),
(131,10,'2025-06-01','available',NULL,'2025-05-10 02:46:26','2025-05-12 07:38:14'),
(132,10,'2025-06-02','available',NULL,'2025-05-10 02:46:26','2025-05-12 07:38:14'),
(133,10,'2025-06-03','available',NULL,'2025-05-10 02:46:27','2025-05-12 07:38:14'),
(134,10,'2025-06-04','available',NULL,'2025-05-10 02:46:27','2025-05-12 07:38:14'),
(135,10,'2025-06-05','available',NULL,'2025-05-10 02:46:28','2025-05-12 07:38:14'),
(136,10,'2025-06-06','available',NULL,'2025-05-10 02:46:28','2025-05-12 07:38:14'),
(137,10,'2025-06-07','available',NULL,'2025-05-10 02:46:28','2025-05-12 07:38:14'),
(138,10,'2025-06-08','available',NULL,'2025-05-10 02:46:29','2025-05-12 07:38:14'),
(139,39,'2025-05-16','booked',44,'2025-05-10 09:31:20','2025-05-10 09:31:20'),
(140,39,'2025-05-17','booked',44,'2025-05-10 09:31:21','2025-05-10 09:31:21'),
(141,40,'2025-05-11','booked',NULL,'2025-05-11 00:08:45','2025-05-11 00:08:45'),
(142,40,'2025-05-12','booked',NULL,'2025-05-11 00:08:45','2025-05-11 17:52:27'),
(143,40,'2025-05-13','booked',NULL,'2025-05-11 00:08:46','2025-05-11 17:52:28'),
(144,40,'2025-05-14','booked',NULL,'2025-05-11 00:08:46','2025-05-11 00:08:46'),
(145,40,'2025-05-15','booked',NULL,'2025-05-11 00:08:46','2025-05-11 00:08:46'),
(146,40,'2025-05-16','booked',NULL,'2025-05-11 00:08:47','2025-05-11 00:08:47'),
(147,40,'2025-05-17','booked',NULL,'2025-05-11 00:08:47','2025-05-11 00:08:47'),
(148,40,'2025-05-18','booked',NULL,'2025-05-11 00:08:47','2025-05-11 00:08:47'),
(149,40,'2025-05-19','booked',NULL,'2025-05-11 00:08:48','2025-05-11 00:08:48'),
(150,40,'2025-05-20','booked',NULL,'2025-05-11 00:08:48','2025-05-11 00:08:48'),
(151,40,'2025-05-21','booked',NULL,'2025-05-11 00:08:48','2025-05-11 00:08:48'),
(152,40,'2025-05-22','booked',NULL,'2025-05-11 00:08:49','2025-05-11 00:08:49'),
(153,40,'2025-05-23','booked',NULL,'2025-05-11 00:08:49','2025-05-11 00:08:49'),
(154,40,'2025-05-24','booked',NULL,'2025-05-11 00:08:49','2025-05-11 00:08:49'),
(155,40,'2025-05-25','booked',NULL,'2025-05-11 00:08:50','2025-05-11 00:08:50'),
(156,40,'2025-05-26','booked',NULL,'2025-05-11 00:08:50','2025-05-11 00:08:50'),
(157,40,'2025-05-27','booked',NULL,'2025-05-11 00:08:51','2025-05-11 00:08:51'),
(158,40,'2025-05-28','booked',NULL,'2025-05-11 00:08:51','2025-05-11 00:08:51'),
(159,40,'2025-05-29','booked',NULL,'2025-05-11 00:08:51','2025-05-11 00:08:51'),
(160,40,'2025-05-30','booked',NULL,'2025-05-11 00:08:51','2025-05-11 00:08:51'),
(161,40,'2025-05-31','booked',NULL,'2025-05-11 00:08:52','2025-05-11 00:08:52'),
(162,40,'2025-06-01','booked',NULL,'2025-05-11 00:08:52','2025-05-11 00:08:52'),
(163,40,'2025-06-02','booked',NULL,'2025-05-11 00:08:52','2025-05-11 00:08:52'),
(164,40,'2025-06-03','booked',NULL,'2025-05-11 00:08:53','2025-05-11 00:08:53'),
(165,40,'2025-06-04','booked',NULL,'2025-05-11 00:08:53','2025-05-11 00:08:53'),
(166,40,'2025-06-05','booked',NULL,'2025-05-11 00:08:53','2025-05-11 00:08:53'),
(167,40,'2025-06-06','booked',NULL,'2025-05-11 00:08:54','2025-05-11 00:08:54'),
(168,40,'2025-06-07','booked',NULL,'2025-05-11 00:08:54','2025-05-11 00:08:54'),
(169,40,'2025-06-08','booked',NULL,'2025-05-11 00:08:55','2025-05-11 00:08:55'),
(170,40,'2025-06-09','booked',NULL,'2025-05-11 00:08:55','2025-05-11 00:08:55'),
(171,39,'2025-05-11','available',NULL,'2025-05-11 02:13:04','2025-05-12 00:49:39'),
(172,43,'2025-05-15','booked',57,'2025-05-15 03:19:12','2025-05-15 03:19:12'),
(173,43,'2025-05-16','booked',57,'2025-05-15 03:19:13','2025-05-15 03:19:13'),
(174,43,'2025-05-17','booked',57,'2025-05-15 03:19:13','2025-05-15 03:19:13'),
(175,43,'2025-05-18','booked',57,'2025-05-15 03:19:13','2025-05-15 03:19:13'),
(176,43,'2025-05-19','booked',57,'2025-05-15 03:19:14','2025-05-15 03:19:14'),
(177,43,'2025-05-20','booked',57,'2025-05-15 03:19:14','2025-05-15 03:19:14');

/*Table structure for table `property_facility` */

DROP TABLE IF EXISTS `property_facility`;

CREATE TABLE `property_facility` (
  `property_id` BIGINT UNSIGNED NOT NULL,
  `facility_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`property_id`,`facility_id`),
  CONSTRAINT `property_facility_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `property_facility` */

/*Table structure for table `property_images` */

DROP TABLE IF EXISTS `property_images`;

CREATE TABLE `property_images` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `property_id` BIGINT UNSIGNED NOT NULL,
  `url` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `property_images_property_id_foreign` (`property_id`),
  CONSTRAINT `property_images_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `property_images` */

INSERT  INTO `property_images`(`id`,`property_id`,`url`,`created_at`,`updated_at`) VALUES 
(4,1,'property_images/pkBRZq4xuYNQnn5kRngOIL50XyEejh9XLBCWFpPo.png','2025-04-14 14:03:13','2025-04-14 14:03:13'),
(5,1,'property_images/AgMhSbLEUe8sHKZ9UA9YFkdUdQsLKvUCfYVi7bHG.png','2025-04-14 14:03:14','2025-04-14 14:03:14'),
(6,1,'property_images/oqEkK3L5QCKMfQW9iXvGDzrfGKIFWDKMF9xRcZ24.png','2025-04-14 14:03:15','2025-04-14 14:03:15'),
(7,1,'property_images/gyXk5oBDB91UWTyQVovCllKtM1jkD1mdLJ7XsjuS.png','2025-04-14 14:03:16','2025-04-14 14:03:16'),
(8,1,'property_images/BB71617MSklS1dr3qIkntZyZlKeUUslyXSU69iWE.png','2025-04-14 14:03:17','2025-04-14 14:03:17'),
(9,24,'property_images/cMXt9jspg6H4KHnlEGECqsFG5BBuqy47BBqpVPPP.png','2025-04-27 14:35:43','2025-04-27 14:35:43'),
(10,24,'property_images/YFP30iLcc8spM9XidJASkSF4B31B78mmIp6eqEa0.jpg','2025-04-27 14:35:43','2025-04-27 14:35:43'),
(11,25,'property_images/T4mVqPLjxcfWwjv2NdZAL0aYvwasKSFYX4pEsLH5.jpg','2025-04-27 14:48:12','2025-04-27 14:48:12'),
(12,25,'property_images/zEET8HkG117bZCok5aSL8PLXgctXHRNOsTlar0Eg.jpg','2025-04-27 14:48:12','2025-04-27 14:48:12'),
(13,25,'property_images/ij73VpjoxSLY6TrnqB3Xv6Mr1Nkl2pUWx0p4ElhM.jpg','2025-04-27 14:48:13','2025-04-27 14:48:13');

/*Table structure for table `property_prices` */

DROP TABLE IF EXISTS `property_prices`;

CREATE TABLE `property_prices` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `property_id` BIGINT UNSIGNED NOT NULL,
  `price` DECIMAL(12,2) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `property_prices_property_id_foreign` (`property_id`),
  CONSTRAINT `property_prices_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `property_prices` */

/*Table structure for table `property_types` */

DROP TABLE IF EXISTS `property_types`;

CREATE TABLE `property_types` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `property_types` */

INSERT  INTO `property_types`(`id`,`name`,`description`,`created_at`,`updated_at`) VALUES 
(1,'Kos','Tempat tinggal sewa per kamar yang cocok untuk mahasiswa atau pekerja.','2025-04-09 10:42:00','2025-04-09 10:42:00'),
(2,'Homestay','Penginapan sementara seperti rumah tinggal, cocok untuk wisatawan atau keluarga.','2025-04-09 10:42:00','2025-04-09 10:42:00');

/*Table structure for table `provinces` */

DROP TABLE IF EXISTS `provinces`;

CREATE TABLE `provinces` (
  `id` BIGINT UNSIGNED NOT NULL,
  `prov_name` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `locationid` INT DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT '1',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `provinces` */

INSERT  INTO `provinces`(`id`,`prov_name`,`locationid`,`status`,`created_at`,`updated_at`) VALUES 
(1,'Aceh',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(2,'Sumatera Utara',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(3,'Sumatera Barat',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(4,'Riau',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(5,'Jambi',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(6,'Sumatera Selatan',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(7,'Bengkulu',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(8,'Lampung',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(9,'Kepulauan Bangka Belitung',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(10,'Kepulauan Riau',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(11,'DKI Jakarta',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(12,'Jawa Barat',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(13,'Jawa Tengah',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(14,'DI Yogyakarta',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(15,'Jawa Timur',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(16,'Banten',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(17,'Bali',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(18,'Nusa Tenggara Barat',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(19,'Nusa Tenggara Timur',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(20,'Kalimantan Barat',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(21,'Kalimantan Tengah',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(22,'Kalimantan Selatan',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(23,'Kalimantan Timur',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(24,'Kalimantan Utara',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(25,'Sulawesi Utara',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(26,'Sulawesi Tengah',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(27,'Sulawesi Selatan',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(28,'Sulawesi Tenggara',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(29,'Gorontalo',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(30,'Sulawesi Barat',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(31,'Maluku',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(32,'Maluku Utara',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(33,'Papua',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(34,'Papua Barat',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(35,'Papua Tengah',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(36,'Papua Pegunungan',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(37,'Papua Selatan',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05'),
(38,'Papua Barat Daya',NULL,1,'2025-04-10 02:33:05','2025-04-10 02:33:05');

/*Table structure for table `recent_searches` */

DROP TABLE IF EXISTS `recent_searches`;

CREATE TABLE `recent_searches` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED DEFAULT NULL,
  `keyword` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `recent_searches` */

INSERT  INTO `recent_searches`(`id`,`user_id`,`keyword`,`created_at`,`updated_at`) VALUES 
(1,NULL,'sitoluama','2025-05-02 14:23:54','2025-05-02 14:23:54'),
(2,NULL,'sitoluama','2025-05-02 14:25:19','2025-05-02 14:25:19'),
(3,NULL,'homestay','2025-05-02 14:26:06','2025-05-02 14:26:06'),
(4,NULL,'homestay','2025-05-02 14:27:50','2025-05-02 14:27:50'),
(5,5,'homestay','2025-05-02 14:30:13','2025-05-02 14:30:13'),
(6,5,'homestay','2025-05-03 03:30:36','2025-05-03 03:30:36'),
(7,5,'homestay','2025-05-03 04:07:00','2025-05-03 04:07:00'),
(8,5,'homestay','2025-05-03 04:08:02','2025-05-03 04:08:02'),
(9,5,'homestay','2025-05-03 04:09:16','2025-05-03 04:09:16'),
(10,5,'homestay','2025-05-03 04:10:59','2025-05-03 04:10:59'),
(11,5,'homestay','2025-05-03 04:21:37','2025-05-03 04:21:37'),
(12,5,'togud','2025-05-03 16:53:29','2025-05-03 16:53:29'),
(13,5,'homestay','2025-05-03 17:29:15','2025-05-03 17:29:15'),
(14,5,'homestay','2025-05-03 17:41:17','2025-05-03 17:41:17'),
(15,5,'baren','2025-05-03 23:45:46','2025-05-03 23:45:46'),
(16,5,'balige','2025-05-03 23:45:59','2025-05-03 23:45:59'),
(17,5,'togud','2025-05-04 00:09:32','2025-05-04 00:09:32'),
(18,5,'kost','2025-05-05 06:20:24','2025-05-05 06:20:24'),
(19,5,'togud','2025-05-05 06:24:32','2025-05-05 06:24:32'),
(20,5,'kos','2025-05-05 06:43:45','2025-05-05 06:43:45'),
(21,5,'cari','2025-05-05 09:32:49','2025-05-05 09:32:49'),
(22,5,'kost','2025-05-05 09:39:58','2025-05-05 09:39:58'),
(23,46,'kost','2025-05-06 08:10:33','2025-05-06 08:10:33'),
(24,5,'togud','2025-05-06 08:16:33','2025-05-06 08:16:33'),
(25,46,'kost','2025-05-06 08:29:53','2025-05-06 08:29:53'),
(26,46,'kost','2025-05-06 08:31:07','2025-05-06 08:31:07'),
(27,46,'kos','2025-05-06 08:31:55','2025-05-06 08:31:55'),
(28,46,'t','2025-05-06 08:32:37','2025-05-06 08:32:37'),
(29,46,'togud','2025-05-06 08:43:16','2025-05-06 08:43:16'),
(30,5,'kos','2025-05-06 09:27:49','2025-05-06 09:27:49'),
(31,5,'kos','2025-05-06 09:40:02','2025-05-06 09:40:02'),
(32,5,'tog','2025-05-06 09:42:05','2025-05-06 09:42:05'),
(33,5,'t','2025-05-06 09:42:18','2025-05-06 09:42:18'),
(34,5,'tog','2025-05-06 09:42:32','2025-05-06 09:42:32'),
(35,5,'to','2025-05-06 09:42:41','2025-05-06 09:42:41'),
(36,5,'t','2025-05-06 09:42:49','2025-05-06 09:42:49'),
(37,46,'kos','2025-05-06 22:47:00','2025-05-06 22:47:00'),
(38,46,'to','2025-05-06 22:54:36','2025-05-06 22:54:36'),
(39,46,'t','2025-05-06 22:55:34','2025-05-06 22:55:34'),
(40,46,'t','2025-05-06 23:01:24','2025-05-06 23:01:24'),
(41,46,'to','2025-05-06 23:04:54','2025-05-06 23:04:54'),
(42,46,'kos','2025-05-07 00:59:50','2025-05-07 00:59:50'),
(43,46,'to','2025-05-07 01:19:07','2025-05-07 01:19:07'),
(44,46,'t','2025-05-07 01:19:30','2025-05-07 01:19:30'),
(45,46,'to','2025-05-07 01:19:35','2025-05-07 01:19:35'),
(46,46,'togud','2025-05-07 01:19:37','2025-05-07 01:19:37'),
(47,46,'to','2025-05-07 01:19:50','2025-05-07 01:19:50'),
(48,46,'tony','2025-05-07 01:20:12','2025-05-07 01:20:12'),
(49,46,'gu','2025-05-07 01:21:08','2025-05-07 01:21:08'),
(50,46,'test','2025-05-07 01:21:35','2025-05-07 01:21:35'),
(51,46,'t','2025-05-07 01:21:41','2025-05-07 01:21:41'),
(52,46,'ton','2025-05-07 01:23:25','2025-05-07 01:23:25'),
(53,46,'t','2025-05-07 01:23:44','2025-05-07 01:23:44'),
(54,46,'t','2025-05-07 01:24:17','2025-05-07 01:24:17'),
(55,46,'to','2025-05-07 01:24:20','2025-05-07 01:24:20'),
(56,46,'y','2025-05-07 01:27:10','2025-05-07 01:27:10'),
(57,46,'ko','2025-05-07 01:27:24','2025-05-07 01:27:24'),
(58,49,'yah','2025-05-07 01:50:52','2025-05-07 01:50:52'),
(59,49,'homestay','2025-05-07 01:56:36','2025-05-07 01:56:36'),
(60,5,'ton','2025-05-07 02:19:25','2025-05-07 02:19:25'),
(61,5,'k','2025-05-07 02:20:57','2025-05-07 02:20:57'),
(62,5,'ki','2025-05-07 02:21:07','2025-05-07 02:21:07'),
(63,5,'ba','2025-05-07 02:21:17','2025-05-07 02:21:17'),
(64,5,'bar','2025-05-07 02:21:31','2025-05-07 02:21:31'),
(65,5,'b','2025-05-07 02:21:38','2025-05-07 02:21:38'),
(66,5,'sim','2025-05-07 02:21:43','2025-05-07 02:21:43'),
(67,5,'simangulampe','2025-05-07 02:21:50','2025-05-07 02:21:50'),
(68,5,'balige','2025-05-07 02:21:59','2025-05-07 02:21:59'),
(69,5,'laguboti','2025-05-07 02:22:58','2025-05-07 02:22:58'),
(70,5,'sitolu','2025-05-07 02:23:22','2025-05-07 02:23:22'),
(71,5,'yah','2025-05-07 02:24:32','2025-05-07 02:24:32'),
(72,5,'kost','2025-05-07 02:24:58','2025-05-07 02:24:58'),
(73,5,'gud','2025-05-07 02:39:48','2025-05-07 02:39:48'),
(74,5,'ko','2025-05-07 04:38:19','2025-05-07 04:38:19'),
(75,5,'balige','2025-05-07 08:41:17','2025-05-07 08:41:17'),
(76,5,'kost','2025-05-07 08:45:56','2025-05-07 08:45:56'),
(77,5,'kos','2025-05-07 08:46:06','2025-05-07 08:46:06'),
(78,5,'togud','2025-05-07 08:58:15','2025-05-07 08:58:15'),
(79,5,'togud','2025-05-07 09:13:59','2025-05-07 09:13:59'),
(80,5,'kost','2025-05-08 01:19:37','2025-05-08 01:19:37'),
(81,5,'a','2025-05-08 01:20:15','2025-05-08 01:20:15'),
(82,5,'yahh','2025-05-08 03:43:20','2025-05-08 03:43:20'),
(83,5,'kost','2025-05-08 07:54:59','2025-05-08 07:54:59'),
(84,5,'kostl','2025-05-08 07:55:02','2025-05-08 07:55:02'),
(85,5,'kos','2025-05-08 07:55:03','2025-05-08 07:55:03'),
(86,46,'yah','2025-05-08 08:05:07','2025-05-08 08:05:07'),
(87,5,'h','2025-05-08 08:07:36','2025-05-08 08:07:36'),
(88,5,'a','2025-05-08 08:07:46','2025-05-08 08:07:46'),
(89,5,'gud','2025-05-08 09:17:42','2025-05-08 09:17:42'),
(90,5,'yah','2025-05-08 09:27:24','2025-05-08 09:27:24'),
(91,5,'ko','2025-05-08 09:32:10','2025-05-08 09:32:10'),
(92,5,'yah','2025-05-09 03:09:37','2025-05-09 03:09:37'),
(93,5,'yah','2025-05-09 03:09:56','2025-05-09 03:09:56'),
(94,5,'yah','2025-05-09 03:15:09','2025-05-09 03:15:09'),
(95,5,'ho.','2025-05-09 03:15:42','2025-05-09 03:15:42'),
(96,5,'ho','2025-05-09 03:15:44','2025-05-09 03:15:44'),
(97,5,'hom','2025-05-09 03:15:47','2025-05-09 03:15:47'),
(98,5,'homestay','2025-05-09 03:15:50','2025-05-09 03:15:50'),
(99,5,'yah','2025-05-09 04:10:18','2025-05-09 04:10:18'),
(100,5,'ko','2025-05-09 13:48:42','2025-05-09 13:48:42'),
(101,5,'go','2025-05-09 14:34:24','2025-05-09 14:34:24'),
(102,5,'p','2025-05-09 14:34:30','2025-05-09 14:34:30'),
(103,5,'pa','2025-05-09 14:34:40','2025-05-09 14:34:40'),
(104,5,'p','2025-05-09 14:34:46','2025-05-09 14:34:46'),
(105,5,'po','2025-05-09 14:34:49','2025-05-09 14:34:49'),
(106,5,'pop','2025-05-09 14:35:01','2025-05-09 14:35:01'),
(107,5,'r','2025-05-09 14:59:11','2025-05-09 14:59:11'),
(108,5,'gu','2025-05-09 14:59:23','2025-05-09 14:59:23'),
(109,5,'gun','2025-05-09 14:59:34','2025-05-09 14:59:34'),
(110,46,'yah','2025-05-09 15:10:59','2025-05-09 15:10:59'),
(111,46,'hom','2025-05-09 15:17:23','2025-05-09 15:17:23'),
(112,5,'yah','2025-05-09 15:47:05','2025-05-09 15:47:05'),
(113,46,'yah','2025-05-09 15:47:26','2025-05-09 15:47:26'),
(114,5,'yah','2025-05-09 16:06:08','2025-05-09 16:06:08'),
(115,5,'yah','2025-05-09 16:16:47','2025-05-09 16:16:47'),
(116,5,'yah','2025-05-09 16:17:35','2025-05-09 16:17:35'),
(117,5,'yah','2025-05-09 17:11:29','2025-05-09 17:11:29'),
(118,5,'yah','2025-05-09 17:40:12','2025-05-09 17:40:12'),
(119,5,'ton','2025-05-09 17:42:14','2025-05-09 17:42:14'),
(120,46,'ton','2025-05-09 17:48:19','2025-05-09 17:48:19'),
(121,5,'y','2025-05-09 17:48:28','2025-05-09 17:48:28'),
(122,5,'amba','2025-05-09 17:49:24','2025-05-09 17:49:24'),
(123,5,'homestay','2025-05-10 02:35:08','2025-05-10 02:35:08'),
(124,5,'H','2025-05-10 04:04:08','2025-05-10 04:04:08'),
(125,5,'Home','2025-05-10 04:04:11','2025-05-10 04:04:11'),
(126,5,'homestay','2025-05-10 10:20:31','2025-05-10 10:20:31'),
(127,5,'homestay','2025-05-10 10:26:41','2025-05-10 10:26:41'),
(128,5,'homestay','2025-05-10 10:35:07','2025-05-10 10:35:07'),
(129,5,'homestay','2025-05-10 17:17:05','2025-05-10 17:17:05'),
(130,5,'homestay','2025-05-10 23:25:08','2025-05-10 23:25:08'),
(131,5,'w.','2025-05-11 09:11:53','2025-05-11 09:11:53'),
(132,5,'w','2025-05-11 09:11:57','2025-05-11 09:11:57'),
(133,5,'ya','2025-05-11 09:12:01','2025-05-11 09:12:01'),
(134,5,'k','2025-05-11 10:07:14','2025-05-11 10:07:14'),
(135,5,'kost','2025-05-11 13:23:13','2025-05-11 13:23:13'),
(136,5,'yah','2025-05-11 15:31:36','2025-05-11 15:31:36'),
(137,5,'home','2025-05-12 00:55:58','2025-05-12 00:55:58'),
(138,5,'yah','2025-05-12 06:50:51','2025-05-12 06:50:51'),
(139,46,'gabs','2025-05-12 12:34:37','2025-05-12 12:34:37'),
(140,46,'gab','2025-05-12 12:34:39','2025-05-12 12:34:39'),
(141,5,'yah','2025-05-12 12:53:00','2025-05-12 12:53:00'),
(142,5,'gud','2025-05-12 13:08:07','2025-05-12 13:08:07'),
(143,5,'b','2025-05-12 13:08:21','2025-05-12 13:08:21'),
(144,5,'an','2025-05-12 13:08:29','2025-05-12 13:08:29'),
(145,5,'gud','2025-05-12 13:16:00','2025-05-12 13:16:00'),
(146,5,'ya','2025-05-12 13:16:08','2025-05-12 13:16:08'),
(147,5,'a','2025-05-12 13:16:16','2025-05-12 13:16:16'),
(148,5,'kos','2025-05-12 13:33:45','2025-05-12 13:33:45'),
(149,5,'yah','2025-05-12 13:40:36','2025-05-12 13:40:36'),
(150,5,'yah','2025-05-12 13:42:50','2025-05-12 13:42:50'),
(151,5,'man','2025-05-12 13:42:58','2025-05-12 13:42:58'),
(152,5,'yah','2025-05-12 14:09:02','2025-05-12 14:09:02'),
(153,5,'yah','2025-05-14 06:34:25','2025-05-14 06:34:25'),
(154,5,'yah','2025-05-14 06:34:47','2025-05-14 06:34:47'),
(155,5,'yah','2025-05-14 07:40:19','2025-05-14 07:40:19'),
(156,5,'yah','2025-05-14 07:40:32','2025-05-14 07:40:32'),
(157,5,'yah','2025-05-14 07:51:49','2025-05-14 07:51:49'),
(158,5,'yah','2025-05-14 14:24:14','2025-05-14 14:24:14'),
(159,5,'yah','2025-05-14 14:42:49','2025-05-14 14:42:49'),
(160,5,'yah','2025-05-14 15:18:02','2025-05-14 15:18:02'),
(161,5,'yah','2025-05-14 15:18:19','2025-05-14 15:18:19'),
(162,5,'yah','2025-05-14 16:07:43','2025-05-14 16:07:43'),
(163,5,'yah','2025-05-14 16:22:08','2025-05-14 16:22:08'),
(164,5,'yah','2025-05-15 01:52:32','2025-05-15 01:52:32'),
(165,5,'yah','2025-05-15 09:33:33','2025-05-15 09:33:33');

/*Table structure for table `reviews` */

DROP TABLE IF EXISTS `reviews`;

CREATE TABLE `reviews` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `booking_id` BIGINT UNSIGNED DEFAULT NULL,
  `property_id` BIGINT UNSIGNED DEFAULT NULL,
  `rating` INT NOT NULL,
  `comment` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`)
) ENGINE=INNODB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `reviews` */

INSERT  INTO `reviews`(`id`,`booking_id`,`property_id`,`rating`,`comment`,`created_at`,`updated_at`) VALUES 
(1,28,26,5,'bagus banget bang','2025-05-14 14:41:34','2025-05-14 14:41:34'),
(2,28,26,4,'bagus sih','2025-05-14 14:53:31','2025-05-14 14:53:31'),
(3,28,26,4,'sangat bagus','2025-05-14 15:16:14','2025-05-14 15:16:14'),
(4,28,26,4,NULL,'2025-05-15 01:30:26','2025-05-15 01:30:26'),
(5,28,26,1,NULL,'2025-05-15 01:31:13','2025-05-15 01:31:13'),
(6,28,26,1,'anjay bro','2025-05-15 01:32:20','2025-05-15 01:32:20'),
(7,56,39,4,'bagus banget bro','2025-05-15 02:14:04','2025-05-15 02:14:04');

/*Table structure for table `room_facilities` */

DROP TABLE IF EXISTS `room_facilities`;

CREATE TABLE `room_facilities` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `room_id` BIGINT UNSIGNED NOT NULL,
  `facility_name` VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `room_facilities_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `room_facilities` */

INSERT  INTO `room_facilities`(`id`,`room_id`,`facility_name`,`created_at`,`updated_at`) VALUES 
(28,3,'lemari','2025-04-17 13:33:40','2025-04-17 13:33:40'),
(29,3,'meja belajar','2025-04-17 13:33:40','2025-04-17 13:33:40'),
(35,1,'lemari','2025-04-17 13:48:26','2025-04-17 13:48:26'),
(36,1,'meja belajar','2025-04-17 13:48:26','2025-04-17 13:48:26'),
(37,4,'tv','2025-04-17 15:08:31','2025-04-17 15:08:31'),
(38,4,'cctv','2025-04-17 15:08:31','2025-04-17 15:08:31'),
(39,4,'wifi','2025-04-17 15:08:32','2025-04-17 15:08:32'),
(45,6,'lemari','2025-04-21 03:39:00','2025-04-21 03:39:00'),
(46,6,'meja belajar','2025-04-21 03:39:00','2025-04-21 03:39:00'),
(47,7,'lemari','2025-04-21 03:46:52','2025-04-21 03:46:52'),
(48,7,'meja belajar','2025-04-21 03:46:52','2025-04-21 03:46:52'),
(49,7,'wifi','2025-04-21 03:46:52','2025-04-21 03:46:52'),
(50,7,'Kursi','2025-04-21 03:46:52','2025-04-21 03:46:52'),
(51,7,'Bunkbed','2025-04-21 03:46:52','2025-04-21 03:46:52'),
(52,5,'tv','2025-04-22 04:11:47','2025-04-22 04:11:47'),
(53,5,'meja belajar','2025-04-22 04:11:47','2025-04-22 04:11:47'),
(54,5,'lemari','2025-04-22 04:11:47','2025-04-22 04:11:47'),
(55,5,'Kursi','2025-04-22 04:11:47','2025-04-22 04:11:47'),
(56,5,'wifi','2025-04-22 04:11:47','2025-04-22 04:11:47'),
(60,15,'hau','2025-04-25 13:24:41','2025-04-25 13:24:41'),
(61,15,'hiu','2025-04-25 13:24:43','2025-04-25 13:24:43'),
(62,15,'lol','2025-04-25 13:26:46','2025-04-25 13:26:46'),
(63,16,'ghi','2025-04-25 14:05:10','2025-04-25 14:05:10'),
(64,16,'vhji','2025-04-25 14:05:12','2025-04-25 14:05:12'),
(66,18,'lemari','2025-04-29 04:24:25','2025-04-29 04:24:25'),
(71,20,'lemari','2025-04-29 04:46:31','2025-04-29 04:46:31'),
(72,20,'bunkbed','2025-04-29 04:46:31','2025-04-29 04:46:31'),
(73,21,'lemari','2025-04-29 06:33:52','2025-04-29 06:33:52'),
(74,21,'bunkbed','2025-04-29 06:33:52','2025-04-29 06:33:52'),
(75,24,'kf','2025-04-30 10:52:10','2025-04-30 10:52:10'),
(76,24,'meja belajar','2025-04-30 10:52:10','2025-04-30 10:52:10'),
(77,25,'eaaaeaee','2025-04-30 14:20:46','2025-04-30 14:20:46'),
(78,25,'eaaaa','2025-04-30 14:20:47','2025-04-30 14:20:47'),
(79,28,'lemari','2025-05-05 08:46:10','2025-05-05 08:46:10'),
(80,28,'cctv','2025-05-05 08:46:11','2025-05-05 08:46:11'),
(81,17,'meja','2025-05-07 16:36:13','2025-05-07 16:36:13'),
(83,30,'dd','2025-05-09 10:29:15','2025-05-09 10:29:15'),
(84,30,'afdafs','2025-05-09 10:29:17','2025-05-09 10:29:17'),
(86,31,'lemari','2025-05-09 17:56:24','2025-05-09 17:56:24'),
(96,29,'lemari','2025-05-09 20:29:21','2025-05-09 20:29:21'),
(97,32,'lemari','2025-05-10 09:29:30','2025-05-10 09:29:30'),
(103,34,'lalal','2025-05-11 08:04:20','2025-05-11 08:04:20'),
(104,35,'ytt','2025-05-11 08:16:20','2025-05-11 08:16:20'),
(107,33,'kursi','2025-05-12 00:49:01','2025-05-12 00:49:01'),
(108,33,'meja belajar','2025-05-12 00:49:02','2025-05-12 00:49:02'),
(109,33,'tuf','2025-05-12 00:49:02','2025-05-12 00:49:02'),
(110,33,'wkwk','2025-05-12 00:49:02','2025-05-12 00:49:02'),
(111,36,'kursi','2025-05-12 00:52:31','2025-05-12 00:52:31'),
(112,36,'meja belajar','2025-05-12 00:52:31','2025-05-12 00:52:31'),
(116,22,'lemari','2025-05-13 07:23:40','2025-05-13 07:23:40'),
(117,37,'tv','2025-05-15 03:15:00','2025-05-15 03:15:00'),
(118,37,'meja belajar','2025-05-15 03:15:00','2025-05-15 03:15:00'),
(119,37,'lemari','2025-05-15 03:15:00','2025-05-15 03:15:00'),
(120,38,'Meja belajar','2025-05-15 03:16:03','2025-05-15 03:16:03');

/*Table structure for table `room_images` */

DROP TABLE IF EXISTS `room_images`;

CREATE TABLE `room_images` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `room_id` BIGINT UNSIGNED NOT NULL,
  `image_url` VARCHAR(255) NOT NULL,
  `is_main` TINYINT(1) NOT NULL DEFAULT '0',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_room_images_room_id` (`room_id`),
  KEY `idx_room_images_is_main` (`is_main`),
  CONSTRAINT `room_images_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `room_images` */

INSERT  INTO `room_images`(`id`,`room_id`,`image_url`,`is_main`,`created_at`,`updated_at`) VALUES 
(1,18,'room_images/oWkCa3UicRtpwQmu8fws5ArPYUcDZmHyh4gJS0nQ.png',1,'2025-04-29 04:24:26','2025-04-29 04:24:26'),
(2,18,'room_images/gallery/RG9j9gYaUzCUA0FGc78HOdHAGaWcuL2y9JLayHLz.png',0,'2025-04-29 04:24:27','2025-04-29 04:24:27'),
(7,20,'room_images/gallery/vpiD8sjkD85kofI9QUEPwY6D1qbbVPBsIzR5XpoG.png',0,'2025-04-29 04:33:55','2025-04-29 04:33:55'),
(8,20,'room_images/3hv1Ua2N79Pqy9smeQnpHOzlMbx8HszJ5quNPZCJ.png',1,'2025-04-29 04:46:32','2025-04-29 04:46:32'),
(9,20,'room_images/gallery/KdRHGcITDzYLltfBsBM6HzJ3IuakGkNeV9wu9Upd.png',0,'2025-04-29 04:46:32','2025-04-29 04:46:32'),
(10,20,'room_images/gallery/Mihz88CIvLu7N24HXwQUGuAT8wvLqztk97t1cmAY.png',0,'2025-04-29 04:46:32','2025-04-29 04:46:32'),
(11,21,'room_images/Bc6Y7izyR9Bk9eai1iM9tZ2lOZN1LmN1gMqAEUQx.png',1,'2025-04-29 06:33:52','2025-04-29 06:33:52'),
(12,21,'room_images/gallery/IkvhFI1PZfYbsPzLZU2uGzKdldWx4HIX6D8XNRtl.png',0,'2025-04-29 06:33:52','2025-04-29 06:33:52'),
(13,21,'room_images/gallery/I51JtJkVjOqaC4E9MGKOTpc3XaQws3LcpexPeZEK.png',0,'2025-04-29 06:33:53','2025-04-29 06:33:53'),
(14,21,'room_images/gallery/GPCC0xARpD2fWp5olBor2t7DcW3DXLyBDYNwpeyQ.png',0,'2025-04-29 06:33:53','2025-04-29 06:33:53'),
(15,24,'room_images/XufOsPUi8jGVrG0RFvzstOkTZ0FCiPnta1lV2WYv.jpg',1,'2025-04-30 10:52:10','2025-04-30 10:52:10'),
(16,24,'room_images/gallery/qGqLcLigWoqovr8NrH9cocxxMB6unenhfLvzsWx2.png',0,'2025-04-30 10:52:10','2025-04-30 10:52:10'),
(17,24,'room_images/gallery/PJ5lJdaX4HaEfrUXD48GpFQHYndmS2KlIIAqWdzm.png',0,'2025-04-30 10:52:10','2025-04-30 10:52:10'),
(18,24,'room_images/gallery/PnElZsIiHZtLMHkH0jgWV2xO7SQKcPoJ0JbGCuPe.png',0,'2025-04-30 10:52:10','2025-04-30 10:52:10'),
(19,24,'room_images/gallery/cewRgLJ9GX2fHkCoxqHgkKTrS1q4SjY8uhvFfe2t.png',0,'2025-04-30 10:52:10','2025-04-30 10:52:10'),
(20,28,'room_images/XJdsbOhn6WeVTBjjyHt22ZggT2pYCs3cvCCFuzxB.png',1,'2025-05-05 08:46:12','2025-05-05 08:46:12'),
(21,28,'room_images/gallery/lRUetsfG2QYHsKm8BD5JddyYG0QzjIHP2pPgVBBO.png',0,'2025-05-05 08:46:12','2025-05-05 08:46:12'),
(22,28,'room_images/gallery/lFBV08olQBcs92e6HKSpI7eGIrox62lkRdYYARRA.png',0,'2025-05-05 08:46:12','2025-05-05 08:46:12'),
(23,28,'room_images/gallery/n9YPIMOMqSMO8YihFIGpWaZZZ0M7y90C1hMSvBR4.png',0,'2025-05-05 08:46:13','2025-05-05 08:46:13'),
(24,28,'room_images/gallery/xABk8lBUo9OS1aRWSCZURxDB7xJvUeNa5G4WeGUV.png',0,'2025-05-05 08:46:13','2025-05-05 08:46:13'),
(25,28,'room_images/gallery/Tt3k0NpY4wLSObL4PWUk4R1zJi5vXE9WyGWLrAFP.png',0,'2025-05-05 08:46:14','2025-05-05 08:46:14'),
(26,17,'room_images/XhakhmnmIa6G7P5qHzYPzenMvTNTY8s81L470jjl.jpg',1,'2025-05-07 16:36:14','2025-05-07 16:36:14'),
(27,17,'room_images/gallery/CB5ji0BNcwGrSCJTvzqpBV9RMDmahDyJ3bDD43ER.png',0,'2025-05-07 16:36:14','2025-05-07 16:36:14'),
(28,17,'room_images/gallery/AZNU0L8pGf5uEDRWqicakz83OJChp8U4fpgCoZk0.png',0,'2025-05-07 16:36:14','2025-05-07 16:36:14'),
(29,17,'room_images/gallery/zF8RhkfDuqC5tPNAOiLKCC3BK9xU43w7iC9TRb25.png',0,'2025-05-07 16:36:14','2025-05-07 16:36:14'),
(30,17,'room_images/gallery/j7FPWWOgrf01nUpHhohe0R27G7Dt5faXZgVssW1q.jpg',0,'2025-05-07 16:36:14','2025-05-07 16:36:14'),
(32,29,'room_images/mTETbRoctTod0td4qWrS0KOzwRuOMMRzi62UiHoS.png',1,'2025-05-09 17:52:21','2025-05-09 17:52:21'),
(33,29,'room_images/gallery/Zo6k1mn8gbxlreLnKcdazrBdYE44f3glK4UqodHO.png',0,'2025-05-09 17:52:21','2025-05-09 17:52:21'),
(34,29,'room_images/gallery/DzBSCTaGtuUEZENz6OgQfsLoDEdqLCvZf2mTtr6R.png',0,'2025-05-09 17:52:21','2025-05-09 17:52:21'),
(35,29,'room_images/gallery/d7qnn0BrVPREBAjZkn93XD3Ttyiuyt20UUJ0Ytbd.png',0,'2025-05-09 17:52:22','2025-05-09 17:52:22'),
(36,31,'room_images/UdsEqEcI1FxBgr7P6H6zocbs2qdjXCGlv07TsBQX.png',1,'2025-05-09 17:56:24','2025-05-09 17:56:24'),
(37,31,'room_images/gallery/E5gu2qq3snm9yQAECb7JT5trJglU7ByQOaGtRV75.png',0,'2025-05-09 17:56:24','2025-05-09 17:56:24'),
(38,31,'room_images/gallery/Mqo3GhReEtnyLzXvvmeDO4Dze5yc1oumfuQwoNT6.png',0,'2025-05-09 17:56:24','2025-05-09 17:56:24'),
(39,32,'room_images/N1DpECw9hbTBQy9gcwj0UtzRd7ub70E7xhiETduK.png',1,'2025-05-10 09:29:31','2025-05-10 09:29:31'),
(40,32,'room_images/gallery/1B8hEcYtmDbW9QdxnoN1ptnNT2FyRrfYfza3Lw0p.png',0,'2025-05-10 09:29:31','2025-05-10 09:29:31'),
(41,32,'room_images/gallery/eNZxC3HeUT8ZVAG2VIqB3KnOTuVFUMUBT6Ra3UcL.png',0,'2025-05-10 09:29:31','2025-05-10 09:29:31'),
(42,33,'room_images/UpmwE3Yc1GcYgvRCjuzwxNYizpVJQ5RWeZl3HmhH.png',1,'2025-05-10 23:50:15','2025-05-10 23:50:15'),
(43,33,'room_images/gallery/6jmnkznbRW91j4LViJASLJYgHXnzO8dgnvrzCKlf.png',0,'2025-05-10 23:50:16','2025-05-10 23:50:16'),
(44,33,'room_images/gallery/luyhd03OIGIcylJtMKcnwCU6apozlGBCEgGwZ0ao.png',0,'2025-05-10 23:50:16','2025-05-10 23:50:16'),
(45,33,'room_images/gallery/EV3aWHySgEpSeIzGxOnudi4SHdI4SiqfoGHyh44B.png',0,'2025-05-10 23:50:16','2025-05-10 23:50:16'),
(46,33,'room_images/gallery/Cb9oMw2cwuSblnwH6S0Q9DQVo6eJIjexLvrP5lE7.png',0,'2025-05-10 23:50:16','2025-05-10 23:50:16'),
(47,33,'room_images/gallery/zEY75AndYlAupYyiXxV2PVLQWiGJpZ6je0k0wppQ.png',0,'2025-05-10 23:50:16','2025-05-10 23:50:16'),
(48,34,'room_images/lh1qO03UrsgWdblkRiidc7d1hL37hgRyu3xLQk4b.png',1,'2025-05-11 07:59:39','2025-05-11 07:59:39'),
(49,35,'room_images/ReENwi0wqUPKFjH36pQ9OTUY3q5rBFfuhKZEnE0f.png',1,'2025-05-11 08:16:20','2025-05-11 08:16:20'),
(50,36,'room_images/Zbjj1xyEGVRHNm9RgyohLWR6Rlki96rgcFfsZBKd.png',1,'2025-05-11 17:51:09','2025-05-11 17:51:09'),
(51,36,'room_images/gallery/HCSomt1FmmIeaT9F2tpuZUvWpSipf9P8UFrpwPQh.png',0,'2025-05-11 17:51:09','2025-05-11 17:51:09'),
(52,36,'room_images/gallery/rFVbYoDzlHNlzZ7PTGlvo5WPg140xwi8jnlb98UB.png',0,'2025-05-11 17:51:10','2025-05-11 17:51:10'),
(53,36,'room_images/gallery/dXo2xoHZ2ndX898TMRdzk0o9RKVAtsyxnuxnxxqU.png',0,'2025-05-11 17:51:10','2025-05-11 17:51:10'),
(54,36,'room_images/gallery/7NYkE2EHYYbmD93pZRojjw4wCoPuP2LaQr8Yc7e8.png',0,'2025-05-11 17:51:10','2025-05-11 17:51:10'),
(55,36,'room_images/gallery/kTT1OlDG7Ze4kdFy5nw70lQNwshGcoti8517AEnV.png',0,'2025-05-11 17:51:10','2025-05-11 17:51:10'),
(56,37,'room_images/zd3nM1mR9n6rZbHbJ4Z31IXSmOgrLbbRxymxuYql.jpg',1,'2025-05-12 13:54:57','2025-05-12 13:54:57'),
(57,37,'room_images/gallery/uope1LIC0KHUHSL8q6If4IHTMHCwP2WzZAYmTr6T.jpg',0,'2025-05-12 13:54:57','2025-05-12 13:54:57'),
(58,37,'room_images/gallery/wB3vYeFowVsPIK1OhNAAXY0AemuN4rwCpWqIfpOJ.jpg',0,'2025-05-12 13:54:57','2025-05-12 13:54:57'),
(59,37,'room_images/gallery/1DPdSgfAgwVcPWRNKprUZaasKChwO5fg6MaaIdcW.jpg',0,'2025-05-12 13:54:57','2025-05-12 13:54:57'),
(60,37,'room_images/gallery/c7yIhOY85RxogEEiWhhgmG2Aw4luhnZyDiNCfMRs.jpg',0,'2025-05-12 13:54:58','2025-05-12 13:54:58'),
(61,37,'room_images/gallery/b1kJLBp8DVu576wDD3UwpmeOIIFhYgNNJAbGpzCJ.jpg',0,'2025-05-12 13:54:58','2025-05-12 13:54:58'),
(62,22,'room_images/XTp5W3lOSwRIl6XmoFxb0XWAxDw29BwaaJZ4jB6e.jpg',1,'2025-05-13 07:23:41','2025-05-13 07:23:41'),
(63,22,'room_images/gallery/2ollmACPM9kYfu9cNgt4oZR1IJfpJvngkXJAoned.jpg',0,'2025-05-13 07:23:41','2025-05-13 07:23:41'),
(64,22,'room_images/gallery/gGDorFJJl1M2BeD9lRtxElPexcSHhfjfXLOkrtVt.jpg',0,'2025-05-13 07:23:42','2025-05-13 07:23:42'),
(65,38,'room_images/P7oNFrafCJRmCVbBzGSKHcEanbUjuaZOpPasUxyb.jpg',1,'2025-05-15 03:16:03','2025-05-15 03:16:03'),
(66,38,'room_images/gallery/iydd84wRFOeQv8FMLT0Tp0g6n4dthvMYaYt9zGXx.jpg',0,'2025-05-15 03:16:03','2025-05-15 03:16:03'),
(67,38,'room_images/gallery/wqsn7AvoD7TC1j9uxSCDrPam3Esazo1qREYwFoF7.jpg',0,'2025-05-15 03:16:03','2025-05-15 03:16:03'),
(68,38,'room_images/gallery/8NfI9wqSiGmZQKUd45Effm0dcGeClWG3kBpxlHpI.jpg',0,'2025-05-15 03:16:03','2025-05-15 03:16:03'),
(69,38,'room_images/gallery/pz3oGdkZHWhLbtOhRtrC5Ipad5b0HDqHMSCw4omR.jpg',0,'2025-05-15 03:16:03','2025-05-15 03:16:03'),
(70,38,'room_images/gallery/C8gg6bp5EiucyzRsygt7Lbr8Ek67lVdhua9v1wtv.jpg',0,'2025-05-15 03:16:04','2025-05-15 03:16:04');

/*Table structure for table `rooms` */

DROP TABLE IF EXISTS `rooms`;

CREATE TABLE `rooms` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `property_id` BIGINT UNSIGNED NOT NULL,
  `room_type` VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `room_number` VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` DECIMAL(12,2) NOT NULL,
  `size` VARCHAR(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `capacity` INT NOT NULL DEFAULT '1',
  `is_available` TINYINT(1) DEFAULT '1',
  `description` TEXT COLLATE utf8mb4_unicode_ci,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `rooms` */

INSERT  INTO `rooms`(`id`,`property_id`,`room_type`,`room_number`,`price`,`size`,`capacity`,`is_available`,`description`,`created_at`,`updated_at`) VALUES 
(1,2,'premium','43',3000000.00,'4X5',2,0,'test aja','2025-04-17 04:12:41','2025-04-17 13:48:25'),
(3,2,'kosongan','12',500000.00,'4X3',2,0,'test aja','2025-04-17 13:33:40','2025-05-09 17:43:13'),
(4,10,'premium','1',2000000.00,'4X6',3,1,'test aja','2025-04-17 15:08:31','2025-05-12 07:38:14'),
(5,11,'premium','12',3000000.00,'4X5',2,1,'nyaman dan bersih','2025-04-18 02:11:57','2025-04-18 02:11:57'),
(6,12,'kosongan','1 - 10',500000.00,'4X5',2,1,'test aja','2025-04-21 03:39:00','2025-04-21 03:39:00'),
(7,12,'premium','11 - 15',500.00,'4X5',2,1,'bagus','2025-04-21 03:46:51','2025-04-21 03:46:51'),
(8,17,'ya','4',1000000.00,'4x4',2,1,'jdj','2025-04-25 02:45:52','2025-04-25 02:45:52'),
(10,17,'yoi','walae',800000.00,'4x3',2,1,'test aja','2025-04-25 12:26:24','2025-04-25 12:26:24'),
(11,17,'yah','6',800000.00,'4x6',3,1,'yah','2025-04-25 12:49:37','2025-04-25 12:49:37'),
(12,17,'ueje','8',300000.00,'2x3',1,1,'ya','2025-04-25 12:53:28','2025-04-25 12:53:28'),
(13,17,'yejej','23',20049.00,'5x2',2,1,'shsh','2025-04-25 12:57:43','2025-04-25 12:57:43'),
(14,17,'hsjs','12',8404001.00,'4x2',2,1,'ysbsjj','2025-04-25 13:04:48','2025-04-25 13:04:48'),
(15,17,'jsjsj','7',56569.00,'4x2',2,1,'jdjdj','2025-04-25 13:24:37','2025-04-25 13:24:37'),
(16,18,'yt','45',98888.00,'cffd',88,1,'ddj','2025-04-25 14:04:39','2025-04-25 14:04:39'),
(17,26,'kosongan','24-30',600000.00,'4x5',2,0,'yah gaada','2025-04-28 06:30:03','2025-05-09 15:48:03'),
(18,26,'premium','1 - 10',500000.00,'4X5',12,0,'ds','2025-04-29 04:24:25','2025-05-09 16:06:52'),
(20,26,'premium','1-3',549997.00,'4X5',20,0,'ddsa','2025-04-29 04:33:55','2025-05-09 17:12:45'),
(21,26,'kosongan','24-30',500000.00,'4X5',10,0,'kokon','2025-04-29 06:33:51','2025-05-09 17:28:30'),
(22,34,'premium','2-4',800000.00,'4x3',3,1,'coba',NULL,NULL),
(23,26,'da','123',221.00,'4x2',1,0,'desa','2025-04-30 04:35:04','2025-05-09 17:41:11'),
(24,35,'premium','43',500000.00,'30',2,0,'dnfoje','2025-04-30 10:52:09','2025-04-30 19:41:53'),
(25,35,'premium','22',50000.00,'4x7',22,0,'rdtyfugihjlkndsan','2025-04-30 14:20:44','2025-04-30 19:43:01'),
(27,34,'premium','12',4000.00,'4x5',22,1,'qwertyuio',NULL,'2025-05-12 14:31:14'),
(28,37,'songud','43',100000.00,'24',2,0,'lolll','2025-05-05 08:46:09','2025-05-08 06:42:41'),
(29,38,'standard','10',100000.00,'3x4',1,1,'anjas','2025-05-08 09:24:50','2025-05-12 02:26:43'),
(30,39,'fbahk','12',123456789.00,'30',2,0,'dasda','2025-05-09 10:29:13','2025-05-09 15:33:44'),
(31,38,'kosongan','12',500000.00,'30',1,0,'ccd','2025-05-09 17:56:24','2025-05-09 18:18:00'),
(32,39,'anjay','10',10000000.00,'20',2,1,'walae','2025-05-10 09:29:29','2025-05-13 06:20:43'),
(33,40,'Premium','1',200000.00,'3x4',2,1,'qwertyuiop','2025-05-10 23:50:15','2025-05-12 00:49:01'),
(34,39,'dangbeltest','18',800000.00,'20',1,1,'walae','2025-05-11 07:59:38','2025-05-12 07:37:51'),
(35,39,'premium','10',1234567.00,'45',1,1,'xdg','2025-05-11 08:16:20','2025-05-14 08:49:12'),
(36,40,'PREMIUM','2',1200000.00,'3x4',3,1,'qwertyuio','2025-05-11 17:51:09','2025-05-12 00:52:31'),
(37,43,'premium','10',2000000.00,'24',2,0,'nyaman aman dan bersih','2025-05-12 13:54:56','2025-05-15 03:19:12'),
(38,43,'Kamar Razes','12',2000000.00,'2*3',5,1,'asdf','2025-05-13 04:37:18','2025-05-15 03:16:02');

/*Table structure for table `sessions` */

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` BIGINT UNSIGNED DEFAULT NULL,
  `ip_address` VARCHAR(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` INT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `sessions` */

INSERT  INTO `sessions`(`id`,`user_id`,`ip_address`,`user_agent`,`payload`,`last_activity`) VALUES 
('4br65Q48oA91z1pchR4XlhHetbox10DRVSDHd1fC',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoibE5JUG80ak04b0NzYm9qbnBnUnlHdEhQTEo0bm1CTmYzbWtHQWxBeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747300067),
('8x4e0NFOkuEM56pCHPcqjX1RCU8jbp81L9d4QciT',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiSHVsQzExNlB4NUdLV2Fvd2ZJaGlyWEEzcEhSQmRxQ2lrd1RCNGk4NSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747293535),
('B1UqSMT5ca5KMZ98ySe7NBLviNhejis7hcqKDWhX',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoidmtiNmF1TURvY25IQ3JkSGVDVjU0RHdFZFFDOVFBNTZFa29OVldSOCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747293093),
('bijHZbAP1bgqdfaYPQqJPMBiZDgIcfFsMxr7Hf7a',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTUEzR3RSc1ZXQTNma1dEeDhqR3YwT3pFcXFheTQxYTdiYW1ZUlVTaiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747299292),
('BQr3Ox7mzwPa6MEBXy78QDjCCyLOywnGrrB3UgQh',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTzRNSU13MDRyNU5teEZuZ2piZkgwbUJBaXQ5TGFVcmxWdFhSY0Z6cCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wbGF0Zm9ybS1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToyO30=',1747301752),
('BRLrixv5mWx3Aclsbmhst3TYp93RzLu1RzNl2Vm7',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoibWQ4NkNzR2tubkJJWWp2VjZJd242b0U1eFhJdXlyZE41TExDUHJxNiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747300010),
('BSp3YwE9dmOfUmQFW19hWG99athZxkjzPb34cQ0L',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZkc4ejJNS3hoNjFReHJyOU1USVhCMmp2WVJrcXYwUGZySFBGdElUZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747295732),
('BVLx26prSyhKXecQailnrx50lPL2GqUzt0HhuVyL',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiSVpsWkZKRmt6cEdhbmJsd0xCZ0htQ1FFRERRdlhRQmlUdmFTcUZ6TCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTt9',1747298774),
('cjTELL4pENPc1OndefLZx4eGZxNe8whND8ONEdzS',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoicXZ5cmZJNGl2TlZLZ1FLVWhrOUQxamlSWHRCelc3N3lhNDV3NVpLZyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747298419),
('DGl2hMtRFZxJJU027TP7MhCognGMEbfY9PKqNUjQ',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiM1NaZ1k4ZVlWUFdkUzNPcUp3TjZyZXhWYk5oc0NwYkJ4dGc4SjEyeSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1747300209),
('efTA5tz1rU9EuASsidjWmAFBwSBkTV0yS6h7uHaV',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiVGFjSE92cG12VDQxMmVwMDdiUVdUMlFvYW5mdjhsZlNxQ1RyOXFESyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747297678),
('EVOlGgEg2R9hfS8yTfVo1jKK4cjnNYMo0hFWhqM7',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTU02NFN0S0lmRGFkaDJPVDR0Wjl2eEx0aVBjVzg0a2U5YlhGc01hTiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747294614),
('FRjtGXy0Jd8tzJQZUf6QMKQKq7DxYDdiBKYlmTgs',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoick9xb1V2WGpLZksyNGtWWlFnRlZQMVpweEx5aExGVFM1VWdINGtlSCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wbGF0Zm9ybS1hZG1pbi9wcm9wZXJ0aWVzL2RldGFpbHMvMiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjI7fQ==',1747301172),
('J7MUsAamjx3DJhWU7SrK3OFo4EVYNHhib97aoltM',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiSklBM3lQTjlhWUJ2Z3IzQU9seTcwbzNEVXNsUGxoQ3VXOTBxV0pYQyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747297648),
('JQ6sLQjWafP9e00nNkGaWH3oakwdW9ZnaC0XQCFz',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:138.0) Gecko/20100101 Firefox/138.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWFpHdEExRGVzVlZ4YWNvY2JNNE1jYlZ0MFpVc1V5WEZxM2l5U3pMRyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1747294184),
('jw2dnQrHqNcD8N3HV1EefAKwEudgBbsJnla0p28p',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiWHNTSVdxMm9mUWJuTE00dG1iYkZnYlV5cndSdUI5dFZDaXlVV09mTCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747293006),
('KfHpU3f0uMKADN2SijSROdz2NKG9ATkhgbCMfuPm',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTnh6RWNoTElpbG1sWkVJTGoyOURDS00xYU96Y3h4MTlZQ2hMZjdTOSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wbGF0Zm9ybS1hZG1pbi9wZW5ndXNhaGEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToyO30=',1747300911),
('kY8JwP27JoAmOZpVytu86rUP4BV9Cy8PMHu4Issx',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiN2RWTU1Lb2V1TjNLNnpmNEVRVmRGZVdQZU5mZjJLdlJ0ek5EZ0NiRiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wbGF0Zm9ybS1hZG1pbi9lbnRyZXByZW5ldXJzLzExIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mjt9',1747301021),
('KZ0B78QqlybEBPmseJJNe4nDA6oOTwjbEycxwaGY',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiNHpSa0o3aHJoQ1VKSGtMY1kxVVQ5TmNRaHE3R0Q3QTdwNUI0YWkzVyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747300029),
('LZd6kSSSnHSfr2iBXTNFn3Cjh6wmEvQZiZajcM6l',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiaVlOUnlHeUJIM1lvWk9iSHJ2aGc3Tm1rRHlaTkljeUNHNzYxckNqWiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747299224),
('mBrHWr2f7Ifc2MYzhFcKudActv1vtZYVLm9MVRWK',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:138.0) Gecko/20100101 Firefox/138.0','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiOGM1b3NZazBwamFKZTlTczBSbThhT21NSDhGTkxqU1lMMDN1R3NZZiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747299952),
('mTz157gug2aGaFdkS6rNvxRz16tFN8zilsNihefe',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiQTRtd3RyWnFjRFUyV1ZmdzgySzdwamE2cENLMXZuczhSQW1IRVRmNCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747295704),
('p6DwY9OlBoN8s2lCwk6zkb6O36nFYJ7CFC4f12Cx',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZEdjZXpVSnFCT0dsMEhHaHVHckJRMHppT3RnSFNhWmNDaXh0MVhVbCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747299699),
('RoUyUVeYhsiGMj0NiBGa1U20VDIseKvmFzWHXuqs',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiN3ZqQ1hIZzBIeE9UMms2T3VYa2pVOFZnU0UzcE0yeER4YWRTV2hqSyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747297771),
('TZWgq1OwBK4zw4yaHHkZgVnyk3EGo8yC7cfR6zsW',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoid2xYaU1nOXJTMXFhdHVDZm04cjFlaW5kMVVGUTN5b1ZkWXRycXpEaiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wbGF0Zm9ybS1hZG1pbi9wZW5ndXNhaGEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToyO30=',1747300566),
('UUaruuCNC7vmKrObdSlCGy3T1mdytESDTR9lyrlT',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiMDBSeGY0aUJoVWhWWlRHdWhUZU1NVVhybnE0QUV3YWI0UGphdFNvYiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747299971),
('vyJXCUkVNjPYcDvWvVN8oZF7xFSYYRXqoS8OBNrG',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiNmZPOFlBTENTUUNjR09wbEtKcVd6eXdON3JJVHREZWRUamM3d05adiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wbGF0Zm9ybS1hZG1pbi9wcm9wZXJ0aWVzL2RldGFpbHMvMTEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToyO30=',1747301231),
('W5jVw07dTojseBE75uSB54TZ2FjBPvIW1BwsQg1x',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiVERDak5sMlZ2eVNHcFUwMlpCdG9EZVk5Rmg4VVR2czNMTEpBSHBwbyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTI6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wbGF0Zm9ybS1hZG1pbi9lbnRyZXByZW5ldXJzLzEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToyO30=',1747301107),
('Woj7rVqeLw2B9WBNKXbwnJ99Eng2Bhx4zFksu6uI',1,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiMEdBcDM3dFkzNTQ5NnpST013emQzQWU5VE1zMkpNRWhVT29SSzhoWCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9wcm9wZXJ0aWVzL2Jvb2tpbmdzL3BlbmRpbmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=',1747296155),
('X6hxejJB0l6GwxJDZtR0CwaSf6BI0zjXxwPCppL9',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoicHlSN0ZGakJIcE51ekF0Sk9od0xPMFpTUFp2aTZSNTBLMWJyb1UwZyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wbGF0Zm9ybS1hZG1pbi9wZW5ndXNhaGEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToyO30=',1747300872),
('YpSyzXzNURsaZ72TGfmOS3RumnJJG1USIikZIZVW',3,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoibmdLMDBROGNIVTJkU3RvNFhpSnZUVWh6U0RtOElDRm9hQ014eGx0NCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zdXBlci1hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTozO30=',1747293570),
('ZTZhX93k8jA5FJFlAsD9iel6YyLBkSXYPg1BTBPs',3,'192.168.173.46','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiYld6S05ldVdZUEFnR3lMemswcGVHcnhWbmtxY1IwbEppWXVqbDFtVyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NjA6Imh0dHA6Ly8xOTIuMTY4LjE3My40Njo4MDAwL3N1cGVyLWFkbWluL2VudHJlcHJlbmV1cnMvcGVuZGluZyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjM7fQ==',1747295081);

/*Table structure for table `subdistricts` */

DROP TABLE IF EXISTS `subdistricts`;

CREATE TABLE `subdistricts` (
  `id` BIGINT UNSIGNED NOT NULL,
  `subdis_name` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dis_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_subdistricts_district_new` (`dis_id`),
  CONSTRAINT `fk_subdistricts_district_new` FOREIGN KEY (`dis_id`) REFERENCES `districts` (`id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `subdistricts` */

INSERT  INTO `subdistricts`(`id`,`subdis_name`,`dis_id`,`created_at`,`updated_at`) VALUES 
(1,'Desa Laguboti',9,'2025-04-10 02:39:31','2025-04-10 02:39:31'),
(2,'Desa Sosor Dolok',9,'2025-04-10 02:39:31','2025-04-10 02:39:31'),
(3,'Desa Sitoluama',9,'2025-04-10 02:39:31','2025-04-10 02:39:31'),
(4,'Desa Purbatua',9,'2025-04-10 02:39:31','2025-04-10 02:39:31'),
(5,'Soposurung',2,'2025-04-10 02:41:08','2025-04-10 02:41:08'),
(6,'Balige',2,'2025-04-10 02:41:08','2025-04-10 02:41:08'),
(7,'Lumban Solit',2,'2025-04-10 02:41:08','2025-04-10 02:41:08');

/*Table structure for table `user_roles` */

DROP TABLE IF EXISTS `user_roles`;

CREATE TABLE `user_roles` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `user_roles` */

INSERT  INTO `user_roles`(`id`,`name`,`created_at`,`updated_at`) VALUES 
(1,'Super Admin',NULL,NULL),
(2,'Owner',NULL,NULL),
(3,'Admin Platform',NULL,NULL),
(4,'Penyewa',NULL,NULL);

/*Table structure for table `user_types` */

DROP TABLE IF EXISTS `user_types`;

CREATE TABLE `user_types` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `user_types` */

INSERT  INTO `user_types`(`id`,`name`,`created_at`,`updated_at`) VALUES 
(1,'Super Admin',NULL,NULL),
(2,'Owner',NULL,NULL),
(3,'Admin Platform',NULL,NULL),
(4,'Pengguna',NULL,NULL);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` ENUM('Pria','Wanita') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_picture` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_banned` TINYINT(1) NOT NULL DEFAULT '0',
  `user_type_id` BIGINT UNSIGNED DEFAULT NULL,
  `user_role_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `status` ENUM('pending','approved') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_username_unique` (`username`),
  KEY `users_user_role_id_foreign` (`user_role_id`),
  KEY `users_user_type_id_foreign` (`user_type_id`),
  CONSTRAINT `users_user_role_id_foreign` FOREIGN KEY (`user_role_id`) REFERENCES `user_roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_user_type_id_foreign` FOREIGN KEY (`user_type_id`) REFERENCES `user_types` (`id`)
) ENGINE=INNODB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `users` */

INSERT  INTO `users`(`id`,`name`,`username`,`gender`,`phone`,`address`,`profile_picture`,`email`,`password`,`is_banned`,`user_type_id`,`user_role_id`,`created_at`,`updated_at`,`status`) VALUES 
(1,'Anisetus','manaluu','Pria','082276735593','Siborongborong','1747213818.jpg','bambang@gmail.com','$2y$12$Dd/0vPU2XT8W2YbXut5uAuYB2EPOZn0vSLG32cOX40a8bXkes.Iqq',0,2,2,'2025-04-16 21:50:45','2025-05-15 01:18:36','approved'),
(2,'adminplatform','adminplatform','Pria','081234567891','Aekraja No. 1','3cbb4b41-73c8-4fcc-987f-e6f93ef1dc2a.jpg','adminplatform@gmail.com','$2y$12$0tUWaBuZWhy4DN9WiJ5r/ufxsUVPKR8pybNTBHrqJek1jga81nDw.',0,3,3,'2025-04-14 13:50:47','2025-04-18 03:28:50',NULL),
(3,'superadmin','superadmin','Pria','081234567892','Jl. Superadmin No. 7','84ffabac-df39-4024-8d2a-fed08e34f3ef.jpg','superadmin@gmail.com','$2y$12$1AEGzwMcNQP4LfkOShpA2.2Q8G9.JyfzPGPrHmVChwghSVlVU388W',0,1,1,'2025-04-14 13:50:49','2025-05-15 04:37:48',NULL),
(4,'penyewa1','penyewa1','Pria','081234567893','WaterKing',NULL,'penyewa@gmail.com','$2y$10$rydY2D0nbHdtN/fPYTn0WeAhyJTepjRVg6dyJzznOVir4ecDuhGIC',0,4,4,'2025-04-15 17:50:50','2025-05-06 16:44:08','approved'),
(5,'Deni yaa','densi','Pria','0987654234562','Simangulampe','1746759217.jpg','qazwsx@gmail.com','$2y$10$rydY2D0nbHdtN/fPYTn0WeAhyJTepjRVg6dyJzznOVir4ecDuhGIC',0,4,4,'2025-04-18 22:43:42','2025-05-09 03:47:21',NULL),
(8,'gunadi','gunadi11','Pria','0987656789876','watermak','profile_photos/JFUJtt06XUO4oSzLblkOPL0W2Fz4x6wOWT2QNuc5.jpg','qwert@gmail.com','$2y$12$ctwj5MewcjHYLxKc3psPiOBZat.qwlCWPnWqv1decG7y.86xqzNwK',0,2,2,'2025-04-18 15:43:42',NULL,'approved'),
(9,'dangbeldarksistem','dangbel@gmail.com','Pria',NULL,NULL,NULL,'dangbel@gmail.com','$2y$12$iyBwmAaV1eo8bH5zaZclLec6NB1tpCo5DdhVI8G6/PvPgkFO9nmwS',0,NULL,3,'2025-04-17 09:24:10','2025-04-20 12:47:38',NULL),
(10,'Owner','Owner','Pria',NULL,NULL,NULL,'owner@gmail.com','$2y$12$nQwwGHz2oRhCBXqn928kzOFvlFJBzv9WXZjiT1R2XgEGyO0izgskS',0,2,2,'2025-04-20 13:23:28','2025-05-06 09:21:08','approved'),
(11,'flora','flora10','Pria',NULL,NULL,NULL,'flora@gmail.com','$2y$12$WXV3wxpISRk0Sppsds2Leu2ml7tUWxjjFSzvpF71tialdVUmahovW',0,2,2,'2025-04-21 03:46:45','2025-04-21 03:46:45','approved'),
(13,'Deni saja','densiiii','Pria',NULL,NULL,NULL,'danzoo@gmail.com','$2y$12$nLg8JFF5Q.xBUxcyTtjuMuI9eyEpcz8zWyF0LPufoUSsdH5GP5oMi',0,NULL,2,'2025-04-24 09:24:34','2025-05-06 09:40:05','approved'),
(14,'Daniell','qwertyuiop','Pria',NULL,NULL,NULL,'asdfghjkl@gmail.com','$2y$12$QUOFlqvk1XCjKT.CQFOv.eBqsPxLXnAR6F6sGyJG3QeRkRPkzNCMm',1,NULL,2,'2025-04-24 04:16:17','2025-04-28 04:40:43','approved'),
(15,'Dangbell sinambela','qwertyuioppo','Pria',NULL,NULL,NULL,'daniensinambela@gmail.com','$2y$12$dMzaiOktUtYuN9jILRrOTeOQ9K9yxGjfrg7JtQmHaK.QlmDZFglyq',0,NULL,2,'2025-04-24 04:18:21','2025-04-24 04:18:21','approved'),
(16,'Daniel','denn1234567890','Pria',NULL,NULL,NULL,'dangbeel@gmail.com','$2y$12$ctwj5MewcjHYLxKc3psPiOBZat.qwlCWPnWqv1decG7y.86xqzNwK',0,NULL,4,'2025-04-24 04:19:54','2025-04-24 04:19:54',NULL),
(17,'Peniel','johannes','Pria',NULL,NULL,NULL,'gunadirey@gmail.com','$2y$12$Xcv.gMUGVKkredZFFLa7GexFzuXr9Hin64Lf.JBBTDsP3sb8KAno.',0,2,2,'2025-04-25 01:51:25','2025-04-25 01:51:25','approved'),
(18,'test','test','Pria',NULL,NULL,NULL,'test@gmail.com','$2y$12$CYxat3kYIhtg5b5v8vTG8eMJBJmediHQRb9awDJuLQklT1NKJzdVK',0,2,2,'2025-04-25 13:42:06','2025-05-04 11:50:15','approved'),
(19,'Daniell sinambela','dantod12','Pria',NULL,NULL,NULL,'dangtod@email.com','$2y$12$9Lr.SN8f9kcu0Jx181xjTO.MEeubg53yhl6AB7VtYH8.07CM3AYgC',0,NULL,4,'2025-04-28 06:46:17','2025-04-28 06:46:17',NULL),
(21,'dangbel','dangbel','Pria',NULL,NULL,NULL,'dangbel123@gmail.com','$2y$12$Ptl1UPh9nm1TpB1EHLN3SOEyL1H99V1s4cfmis2VUdOjjW1DnmFYu',0,NULL,4,'2025-05-03 15:45:21','2025-05-03 15:45:21',NULL),
(23,'Anisetus Bambang Manalu','Anisetus','Pria',NULL,NULL,NULL,'anisetusm@gmail.com','$2y$12$IV2W2R33R5/LmOjVYip0XO5n5DkKbBlBZYokXCY5rYyuXb4rdUscy',0,NULL,4,'2025-05-03 15:54:18','2025-05-03 15:54:18',NULL),
(24,'yaelahbang','yolo','Pria',NULL,NULL,NULL,'hemmm@gmail.com','$2y$12$8aGs1s8vYw7ANd/UwtzW/e1H6CFzwtqQUPUeSrheqs4bmXOch3daK',0,2,2,'2025-05-04 05:04:54','2025-05-04 05:04:54','approved'),
(25,'semogabisa','semogabisa','Pria',NULL,NULL,NULL,'semogabisa@gmail.com','$2y$12$akbKkmaUneMeLPjLrP6qeeIPyfO/N3XeMRvG4.yqI1Gm61hkvk6FS',1,NULL,2,'2025-05-04 13:16:58','2025-05-06 09:39:57','approved'),
(26,'beli','beli','Pria',NULL,NULL,NULL,'beli@gmail.com','$2y$10$AFqbur7t2gmyS8OjEMX39eYy8buOSjdR6B5frZ8hO2gf.EmVH49qC',0,NULL,4,'2025-05-05 03:30:13','2025-05-05 03:30:13','approved'),
(27,'rey gunadi sinurat','rey','Pria',NULL,NULL,NULL,'rey@gmail.com','$2y$10$.p/YNU3Z2hhPNKoMq9wbO.vxKDuFUkRBGdLS191eq/GBBiqjas6uG',0,NULL,4,'2025-05-05 10:36:00','2025-05-05 10:36:00','pending'),
(28,'danielbela','danielbela','Pria',NULL,NULL,NULL,'danbela@gmail.com','$2y$12$dq5OPdl2xmXIg1uQprbJY.yr9BOxBN/71KtIFkkhRuAzazGGwioMi',0,NULL,4,'2025-05-05 04:02:35','2025-05-05 04:02:35','pending'),
(29,'www','www','Pria',NULL,NULL,NULL,'www@gmail.com','$2y$10$WhSKEMgajql.3uTSzwF.leY2HoYn8loDdfKJkKgWQ5Vhh69PwwFL2',0,NULL,4,'2025-05-05 11:22:40','2025-05-05 11:22:40','pending'),
(30,'kesekian','kesekian','Pria',NULL,NULL,NULL,'kesekian@gmail.com','$2y$12$UGMPyklBri9DHC3kv4nLM.D/hqZJeWCPJ85B3.GsvoGTQ.DPxEn1W',0,NULL,4,'2025-05-05 04:48:10','2025-05-05 04:48:10','pending'),
(31,'jiur','jiur','Pria',NULL,NULL,NULL,'nael@gmail.com','$2y$10$YHLsD7U7oHad94VQ19BjS.VJhDA7t0FLfSmrAoTRxrlLujyZG7F.a',0,NULL,4,'2025-05-05 07:15:44','2025-05-05 07:15:44','pending'),
(32,'gatau','gatau','Pria',NULL,NULL,NULL,'gatau@gmail.com','$2y$10$3yUnGNq9us6fEdxCdJd4EuRyZHpaRg1POLXvwMR98KRDglqXlTI2a',0,NULL,4,'2025-05-05 07:32:54','2025-05-05 07:32:54','pending'),
(33,'xxxnxxn','xxxxx','Pria',NULL,NULL,NULL,'xxnxx@gmail.com','$2y$12$6FYhF//zuyietIdjBH6Qg.Mvpur0cPMmSXtPcicQGe8RuPIevGbae',0,NULL,4,'2025-05-05 07:35:05','2025-05-05 07:35:05','pending'),
(34,'bela','bela','Pria',NULL,NULL,NULL,'bela@gmail.com','$2y$10$N4xQPjLJi0TtNmBfLN9Yp.uur3E75szQt2hSCsWlhi3wsJnVi8Ijq',0,NULL,4,'2025-05-05 07:44:28','2025-05-05 07:44:28','pending'),
(35,'kofi','kofi','Pria',NULL,NULL,NULL,'samsi@gmail.com','$2y$10$tvA8W3r0NWNJUBSd6f9Vy.gGpqN8B0Z5ReEXrgZEQcGScqc9hyiVi',0,NULL,4,'2025-05-05 07:50:21','2025-05-05 07:50:21','pending'),
(36,'sinurat','sinurat','Pria',NULL,NULL,NULL,'sinurat@gmail.com','$2y$10$LypEAEQTrGUoKAbzpSgmZ.B5blBBRYDDYU5mQTp0cV4Y5qSOeEAFu',0,NULL,4,'2025-05-05 15:49:48','2025-05-05 15:49:48','pending'),
(37,'qwertyuiop','mnbvcxz','Pria',NULL,NULL,NULL,'wemail@gmail.com','$2y$12$EuksRX.XAd8o8lFZ4Hzj5ewZecWb6UElKQLi2/z5ACTUUgct31dhe',0,NULL,4,'2025-05-05 09:15:21','2025-05-05 09:15:21','pending'),
(38,'Daniel','asdfghjkl','Pria',NULL,NULL,NULL,'owwner@gmail.com','$2y$12$dyJ.KqpMRwpYtFX967i8Heu7USKV7PAlznWvBzzolNBIdbDVKhVbe',0,NULL,2,'2025-05-05 09:17:16','2025-05-05 09:17:16','approved'),
(39,'yaelah','yaelah','Pria',NULL,NULL,NULL,'yaelah@gmail.com','$2y$12$IMW1nVJ1G04zXdeIgJH6eeLtjSjguEMJ0YwBMd/x2gkCd/9QR.1EW',1,NULL,4,'2025-05-05 09:33:34','2025-05-06 08:43:51','pending'),
(40,'bambangla','bambangla','Pria',NULL,NULL,NULL,'bambangla@gmail.com','$2y$12$Ej5/kxJMRObeQ1CpcuCAEupBMocHRnz91WE/g84y22LnfbtuYxYgi',0,NULL,4,'2025-05-05 09:35:11','2025-05-05 09:35:11','pending'),
(46,'bakwan','bakwan','Pria',NULL,NULL,'1746518441.jpg','bakwan@gmail.com','$2y$12$Pmj9nh2.7xQ42eXg9Ig7FuZIv7EAFw9BVzc9SXXRvtQU4YVAo.9ki',0,NULL,4,'2025-05-06 02:08:37','2025-05-06 09:48:50','pending'),
(47,'flow','flow','Pria',NULL,NULL,NULL,'flowin@gmail.com','$2y$12$I4l8dVG0kY.qlWF0qy2xo.w2PoiHFSS92WFCgEdDdK1fakdy.KEwK',0,2,2,'2025-05-06 07:10:48','2025-05-06 07:10:48','approved'),
(48,'qwerty','qwerty','Pria',NULL,NULL,NULL,'qwerty@gmail.com','$2y$12$9MkH6i.dWfqKub10KsSSCu8aqgOndnSPzCKJy0YYmsV3NzTQyeRRG',0,NULL,4,'2025-05-07 01:16:56','2025-05-07 01:16:56','pending'),
(49,'hdhej','hdjr','Pria',NULL,NULL,'1746582340.jpg','ytrewq@gmail.com','$2y$12$R3A.UfGiqLRzW9JC36GzMOHmHiifAyae0.FFRxh94b4gCfiTOMjWi',0,NULL,4,'2025-05-07 01:42:29','2025-05-07 01:45:40','pending'),
(50,'Leonel Messi Manalu','Messi','Pria',NULL,NULL,NULL,'messi@gmail.com','$2y$12$g7Qhw1bVeKGAqSsct4uqLus6EQQV5j.QkuKZU1XK3PnqKzXGU7W3G',0,NULL,2,'2025-05-11 07:07:18','2025-05-11 07:07:18','approved'),
(52,'Esron Nainggolan','esron11','Pria',NULL,NULL,NULL,'esron@gmail.com','$2y$12$lmix43kfBE2inqg8fFs0teZEQzsTaWFqilPAiIDAZhYI3lO8.atfi',0,2,2,'2025-05-12 14:00:50','2025-05-12 14:00:50','approved'),
(53,'Bambang','bambang12','Pria',NULL,NULL,NULL,'bambang111@gmail.com','$2y$12$uPTgYUJyXafDY3KcIUwlHubyifWrQZ5AcS.8ZuyMzZzCP6E2xahzG',0,2,2,'2025-05-12 14:01:29','2025-05-12 14:01:29','approved'),
(54,'razes simanjuntak','razes123','Pria',NULL,NULL,NULL,'razes@gmail.com','$2y$12$z2EFy5qs7cJ9UQP1lSaemeynPza6gZpHOlgJyUxEtXR/NY9CElute',0,NULL,2,'2025-05-12 14:08:11','2025-05-12 14:08:11','pending'),
(55,'Nathanael T. J. Tampubolon','_nthnjoy','Pria',NULL,NULL,NULL,'nathanaeltampubolonsklh1005@gmail.com','$2y$12$zDL2ZZdp4r2w3MvegAN7D.4FIdV8VjbomnIDEQ4ENP25URtx7oHCK',0,NULL,3,'2025-05-12 15:24:57','2025-05-12 15:24:57','pending'),
(58,'kohom','kohom2','Pria',NULL,NULL,NULL,'samsimik@gmail.com','$2y$12$SfNyN7v1chGc7pG18KGVh.dbCrkCqM88KsxfeI7beDOEbI4AZgWau',0,NULL,4,'2025-05-14 03:42:32','2025-05-14 03:42:32','pending'),
(60,'Anisetus Bambang Manalu','AnisetusBambang','Pria',NULL,NULL,NULL,'anisetusbambang@gmail.com','$2y$12$NFLFVt1gq3Z3p/CwlJMRMeqr.uJNcjWu3y/VivN3VtqALeYI3X9q2',0,NULL,2,'2025-05-14 03:43:08','2025-05-14 03:43:08','pending'),
(61,'atom sinambela','atoms','Pria',NULL,NULL,NULL,'atom@gmail.com','$2y$12$cVEkcfQ6OkxerE6Czy9jk.gfz1p8QdSNh31eTU3FyaZ5efnh0dD4G',0,NULL,2,'2025-05-14 03:47:33','2025-05-14 03:47:33','approved');

/*Table structure for table `wishlists` */

DROP TABLE IF EXISTS `wishlists`;

CREATE TABLE `wishlists` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `property_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wishlists_user_id_property_id_unique` (`user_id`,`property_id`),
  KEY `wishlists_property_id_foreign` (`property_id`),
  CONSTRAINT `wishlists_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlists_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `wishlists` */

INSERT  INTO `wishlists`(`id`,`user_id`,`property_id`,`created_at`,`updated_at`) VALUES 
(21,4,35,'2025-04-30 14:14:49','2025-04-30 14:14:49'),
(30,46,36,'2025-05-06 07:54:32','2025-05-06 07:54:32'),
(33,5,37,'2025-05-06 08:37:58','2025-05-06 08:37:58'),
(43,5,40,'2025-05-11 13:02:07','2025-05-11 13:02:07'),
(47,5,41,'2025-05-12 13:40:42','2025-05-12 13:40:42'),
(50,46,43,'2025-05-14 03:24:20','2025-05-14 03:24:20'),
(54,5,42,'2025-05-15 03:48:22','2025-05-15 03:48:22');

/* Procedure structure for procedure `viewAll_Properties` */

/*!50003 DROP PROCEDURE IF EXISTS  `viewAll_Properties` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `viewAll_Properties`()
BEGIN
    SELECT * FROM properties;
END */$$
DELIMITER ;

/* Procedure structure for procedure `login_user` */

/*!50003 DROP PROCEDURE IF EXISTS  `login_user` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `login_user`(IN input_email VARCHAR(255))
BEGIN
    SELECT 
        users.id,
        users.name,
        users.username,
        users.email,
        users.password,
        users.user_role_id,
        users.user_type_id,
        users.is_banned,
        user_roles.name AS role_name,
        user_types.name AS type_name
    FROM users
    JOIN user_roles ON users.user_role_id = user_roles.id
    JOIN user_types ON users.user_type_id = user_types.id
    WHERE users.email COLLATE utf8mb4_unicode_ci = input_email COLLATE utf8mb4_unicode_ci;
END */$$
DELIMITER ;

/* Procedure structure for procedure `getAllEntrepreneurs` */

/*!50003 DROP PROCEDURE IF EXISTS  `getAllEntrepreneurs` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `getAllEntrepreneurs`()
BEGIN
    SELECT * FROM users WHERE user_role_id = 2; -- misal 2 adalah role untuk entrepreneur
END */$$
DELIMITER ;

/* Procedure structure for procedure `getPropertyTypes` */

/*!50003 DROP PROCEDURE IF EXISTS  `getPropertyTypes` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `getPropertyTypes`()
BEGIN
    SELECT * FROM property_types;
END */$$
DELIMITER ;

/* Procedure structure for procedure `getProvinces` */

/*!50003 DROP PROCEDURE IF EXISTS  `getProvinces` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `getProvinces`()
BEGIN
    SELECT id, prov_name FROM provinces ORDER BY prov_name ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `insert_province` */

/*!50003 DROP PROCEDURE IF EXISTS  `insert_province` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `insert_province`(IN prov_name VARCHAR(100))
BEGIN
    INSERT INTO provinces (prov_name) VALUES (prov_name);
END */$$
DELIMITER ;

/* Procedure structure for procedure `insert_city` */

/*!50003 DROP PROCEDURE IF EXISTS  `insert_city` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `insert_city`(IN city_name VARCHAR(100), IN prov_id BIGINT)
BEGIN
    INSERT INTO cities (city_name, prov_id) VALUES (city_name, prov_id);
END */$$
DELIMITER ;

/* Procedure structure for procedure `insert_district` */

/*!50003 DROP PROCEDURE IF EXISTS  `insert_district` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `insert_district`(IN district_name VARCHAR(100), IN city_id BIGINT)
BEGIN
    INSERT INTO districts (dis_name, city_id) VALUES (district_name, city_id);
END */$$
DELIMITER ;

/* Procedure structure for procedure `insert_subdistrict` */

/*!50003 DROP PROCEDURE IF EXISTS  `insert_subdistrict` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `insert_subdistrict`(IN subdistrict_name VARCHAR(100), IN district_id BIGINT)
BEGIN
    INSERT INTO subdistricts (subdis_name, dis_id) VALUES (subdistrict_name, district_id);
END */$$
DELIMITER ;

/* Procedure structure for procedure `view_propertiesByidowner` */

/*!50003 DROP PROCEDURE IF EXISTS  `view_propertiesByidowner` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `view_propertiesByidowner`(IN owner_id BIGINT)
BEGIN
    SELECT * FROM properties
    WHERE user_id = owner_id AND isDeleted = 0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `storeEntrepreneur` */

/*!50003 DROP PROCEDURE IF EXISTS  `storeEntrepreneur` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `storeEntrepreneur`(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_username VARCHAR(100),
    IN p_password VARCHAR(255)
)
BEGIN
    INSERT INTO users (
        name,
        email,
        username,
        password,
        user_role_id,
        user_type_id,
        created_at,
        updated_at
    ) VALUES (
        p_name,
        p_email,
        p_username,
        p_password,
        2,  -- Role ID untuk Entrepreneur
        2,  -- User Type ID untuk Entrepreneur
        NOW(),
        NOW()
    );
END */$$
DELIMITER ;

/* Procedure structure for procedure `getEntrepreneurById` */

/*!50003 DROP PROCEDURE IF EXISTS  `getEntrepreneurById` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `getEntrepreneurById`(IN uid INT)
BEGIN
    SELECT * FROM users
    WHERE id = uid AND user_type_id = 2; 
END */$$
DELIMITER ;

/* Procedure structure for procedure `store_propertyy` */

/*!50003 DROP PROCEDURE IF EXISTS  `store_propertyy` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `store_propertyy`(IN data JSON)
BEGIN
    DECLARE v_name VARCHAR(255);
    DECLARE v_property_type_id INT;
    DECLARE v_province_id INT;
    DECLARE v_city_id INT;
    DECLARE v_district_id INT;
    DECLARE v_subdis_id INT;
    DECLARE v_description TEXT;
    DECLARE v_user_id INT;
    SET v_name = JSON_UNQUOTE(JSON_EXTRACT(data, '$.name'));
    SET v_property_type_id = JSON_UNQUOTE(JSON_EXTRACT(data, '$.property_type_id'));
    SET v_province_id = JSON_UNQUOTE(JSON_EXTRACT(data, '$.province_id'));
    SET v_city_id = JSON_UNQUOTE(JSON_EXTRACT(data, '$.city_id'));
    SET v_district_id = JSON_UNQUOTE(JSON_EXTRACT(data, '$.district_id'));
    SET v_subdis_id = JSON_UNQUOTE(JSON_EXTRACT(data, '$.subdis_id'));
    SET v_description = JSON_UNQUOTE(JSON_EXTRACT(data, '$.description'));
    SET v_user_id = JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id'));
    INSERT INTO properties (name, property_type_id, province_id, city_id, district_id, subdis_id, description, user_id, created_at, updated_at)
    VALUES (v_name, v_property_type_id, v_province_id, v_city_id, v_district_id, v_subdis_id, v_description, v_user_id, NOW(), NOW());
END */$$
DELIMITER ;

/* Procedure structure for procedure `searchProperties` */

/*!50003 DROP PROCEDURE IF EXISTS  `searchProperties` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `searchProperties`(
    IN p_keyword VARCHAR(255),
    IN p_property_type INT,
    IN p_city_id INT,
    IN p_min_price DECIMAL(12,2),
    IN p_max_price DECIMAL(12,2),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT 
        p.*,
        pt.property_type,
        c.city_name,
        d.dis_name,
        s.subdis_name,
        pr.prov_name
    FROM properties p
    JOIN property_types pt ON p.property_type_id = pt.id
    JOIN cities c ON p.city_id = c.id
    JOIN districts d ON p.district_id = d.id
    JOIN subdistricts s ON p.subdistrict_id = s.id
    JOIN provinces pr ON p.province_id = pr.id
    WHERE 
        (p.name LIKE CONCAT('%', p_keyword, '%') OR 
         p.description LIKE CONCAT('%', p_keyword, '%')) AND
        (p_property_type IS NULL OR p.property_type_id = p_property_type) AND
        (p_city_id IS NULL OR p.city_id = p_city_id) AND
        (p_min_price IS NULL OR p.price >= p_min_price) AND
        (p_max_price IS NULL OR p.price <= p_max_price) AND
        p.isDeleted = 0
    LIMIT p_limit OFFSET p_offset;
END */$$
DELIMITER ;

/* Procedure structure for procedure `getPropertyDetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `getPropertyDetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `getPropertyDetails`(IN property_id BIGINT)
BEGIN
    -- Info properti dasar
    SELECT 
        p.*,
        pt.property_type,
        c.city_name,
        d.dis_name,
        s.subdis_name,
        pr.prov_name,
        u.name AS owner_name,
        u.phone AS owner_phone
    FROM properties p
    JOIN property_types pt ON p.property_type_id = pt.id
    JOIN cities c ON p.city_id = c.id
    JOIN districts d ON p.district_id = d.id
    JOIN subdistricts s ON p.subdistrict_id = s.id
    JOIN provinces pr ON p.province_id = pr.id
    JOIN users u ON p.user_id = u.id
    WHERE p.id = property_id;
    
    -- Fasilitas
    SELECT * FROM property_facilities WHERE property_id = property_id;
    
    -- Gambar
    SELECT * FROM property_images WHERE property_id = property_id;
    
    -- Review
    SELECT 
        r.*,
        u.name AS reviewer_name,
        u.profile_picture AS reviewer_picture
    FROM reviews r
    JOIN users u ON r.user_id = u.id
    WHERE r.property_id = property_id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `get_owner_property_stats` */

/*!50003 DROP PROCEDURE IF EXISTS  `get_owner_property_stats` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `get_owner_property_stats`(IN owner_id BIGINT)
BEGIN
    SELECT 
        COUNT(*) AS total_properties,
        SUM(CASE WHEN available_rooms > 0 THEN 1 ELSE 0 END) AS active_properties,
        SUM(available_rooms) AS total_available_rooms,
        AVG(price) AS average_price,
        MIN(price) AS min_price,
        MAX(price) AS max_price
    FROM properties
    WHERE user_id = owner_id AND isDeleted = 0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `store_property_image` */

/*!50003 DROP PROCEDURE IF EXISTS  `store_property_image` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `store_property_image`(
    IN p_property_id BIGINT,
    IN p_image_url VARCHAR(255)
)
BEGIN
    INSERT INTO property_images (
        property_id,
        url,
        created_at,
        updated_at
    ) VALUES (
        p_property_id,
        p_image_url,
        NOW(),
        NOW()
    );
END */$$
DELIMITER ;

/* Procedure structure for procedure `store_property_facility` */

/*!50003 DROP PROCEDURE IF EXISTS  `store_property_facility` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `store_property_facility`(
    IN p_property_id BIGINT,
    IN p_facility_name VARCHAR(255)
)
BEGIN
    INSERT INTO property_facilities (
        property_id,
        name,
        created_at,
        updated_at
    ) VALUES (
        p_property_id,
        p_facility_name,
        NOW(),
        NOW()
    );
END */$$
DELIMITER ;

/* Procedure structure for procedure `soft_delete_property` */

/*!50003 DROP PROCEDURE IF EXISTS  `soft_delete_property` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `soft_delete_property`(IN p_property_id BIGINT)
BEGIN
    UPDATE properties 
    SET 
        isDeleted = 1,
        updated_at = NOW()
    WHERE id = p_property_id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `get_property_facilities` */

/*!50003 DROP PROCEDURE IF EXISTS  `get_property_facilities` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `get_property_facilities`(IN p_property_id BIGINT)
BEGIN
    SELECT 
        id,
        name,
        created_at,
        updated_at
    FROM property_facilities
    WHERE property_id = p_property_id
    ORDER BY name;
END */$$
DELIMITER ;

/* Procedure structure for procedure `get_property_images` */

/*!50003 DROP PROCEDURE IF EXISTS  `get_property_images` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `get_property_images`(IN p_property_id BIGINT)
BEGIN
    SELECT 
        id,
        url,
        created_at,
        updated_at
    FROM property_images
    WHERE property_id = p_property_id
    ORDER BY created_at;
END */$$
DELIMITER ;

/* Procedure structure for procedure `update_property` */

/*!50003 DROP PROCEDURE IF EXISTS  `update_property` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `update_property`(IN property_data JSON)
BEGIN
    UPDATE properties SET
        name = JSON_UNQUOTE(JSON_EXTRACT(property_data, '$.name')),
        description = JSON_UNQUOTE(JSON_EXTRACT(property_data, '$.description')),
        property_type_id = JSON_EXTRACT(property_data, '$.property_type_id'),
        province_id = JSON_EXTRACT(property_data, '$.province_id'),
        city_id = JSON_EXTRACT(property_data, '$.city_id'),
        district_id = JSON_EXTRACT(property_data, '$.district_id'),
        subdistrict_id = JSON_EXTRACT(property_data, '$.subdistrict_id'),
        price = JSON_EXTRACT(property_data, '$.price'),
        address = JSON_UNQUOTE(JSON_EXTRACT(property_data, '$.address')),
        capacity = JSON_EXTRACT(property_data, '$.capacity'),
        available_rooms = JSON_EXTRACT(property_data, '$.available_rooms'),
        latitude = JSON_EXTRACT(property_data, '$.latitude'),
        longitude = JSON_EXTRACT(property_data, '$.longitude'),
        rules = JSON_UNQUOTE(JSON_EXTRACT(property_data, '$.rules')),
        image = CASE 
                  WHEN JSON_EXTRACT(property_data, '$.image') IS NOT NULL THEN 
                    JSON_UNQUOTE(JSON_EXTRACT(property_data, '$.image'))
                  ELSE image
                END,
        updated_at = NOW()
    WHERE id = JSON_EXTRACT(property_data, '$.id');
END */$$
DELIMITER ;

/* Procedure structure for procedure `delete_property_facilities` */

/*!50003 DROP PROCEDURE IF EXISTS  `delete_property_facilities` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `delete_property_facilities`(IN p_property_id BIGINT)
BEGIN
    DELETE FROM property_facilities 
    WHERE property_id = p_property_id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `getDistricts` */

/*!50003 DROP PROCEDURE IF EXISTS  `getDistricts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `getDistricts`(IN p_city_id BIGINT)
BEGIN
    SELECT 
        id,
        dis_name AS name
    FROM 
        districts
    WHERE 
        city_id = p_city_id
    ORDER BY 
        dis_name ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `getSubdistricts` */

/*!50003 DROP PROCEDURE IF EXISTS  `getSubdistricts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `getSubdistricts`(IN p_district_id BIGINT)
BEGIN
    SELECT 
        id,
        subdis_name AS name
    FROM 
        subdistricts
    WHERE 
        dis_id = p_district_id
    ORDER BY 
        subdis_name ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `getCities` */

/*!50003 DROP PROCEDURE IF EXISTS  `getCities` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `getCities`(IN p_province_id BIGINT)
BEGIN
    SELECT 
        id,
        city_name AS name
    FROM 
        cities
    WHERE 
        prov_id = p_province_id
    ORDER BY 
        city_name ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `store_property` */

/*!50003 DROP PROCEDURE IF EXISTS  `store_property` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`%` PROCEDURE `store_property`(IN data JSON)
BEGIN
    INSERT INTO properties (
        name,
        description,
        user_id,
        property_type_id,
        province_id,
        city_id,
        district_id,
        subdistrict_id,
        price,
        address,
        capacity,
        available_rooms,
        latitude,
        longitude,
        rules,
        image,
        created_at,
        updated_at
    )
    VALUES (
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.name')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.description')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.property_type_id')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.province_id')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.city_id')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.district_id')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.subdistrict_id')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.price')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.address')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.capacity')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.available_rooms')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.latitude')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.longitude')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.rules')),
        JSON_UNQUOTE(JSON_EXTRACT(data, '$.image')),
        NOW(),
        NOW()
    );
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
