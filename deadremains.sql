-- --------------------------------------------------------
-- Värd:                         127.0.0.1
-- Server version:               5.6.25-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.2.0.4975
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for deadremains
CREATE DATABASE IF NOT EXISTS `deadremains` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `deadremains`;


-- Dumping structure for table deadremains.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam_id` varchar(32) NOT NULL,
  `need_thirst` int(11) NOT NULL,
  `need_health` int(11) NOT NULL,
  `need_hunger` int(11) NOT NULL,
  `characteristic_thirst` int(11) NOT NULL,
  `characteristic_health` int(11) NOT NULL,
  `characteristic_hunger` int(11) NOT NULL,
  `characteristic_sight` int(11) NOT NULL,
  `characteristic_strength` int(11) NOT NULL,
  `gender` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `steam_id` (`steam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
