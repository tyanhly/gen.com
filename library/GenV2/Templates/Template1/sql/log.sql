/*
SQLyog Enterprise - MySQL GUI v8.18 
MySQL - 5.5.22-0ubuntu1 : Database - system_log_dev
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`system_log_dev` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `system_log_dev`;

/*Table structure for table `BackendLogs` */

DROP TABLE IF EXISTS `BackendLogs`;

CREATE TABLE `BackendLogs` (
  `BackendLogId` double NOT NULL AUTO_INCREMENT,
  `UserAgent` blob,
  `IPAddress` varchar(765) DEFAULT NULL,
  `RequestURI` varchar(765) DEFAULT NULL,
  `HttpReferer` varchar(765) DEFAULT NULL,
  `GeoIPCountryCode` varchar(765) DEFAULT NULL,
  `GeoIPCountryName` varchar(765) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`BackendLogId`)
) ENGINE=MyISAM AUTO_INCREMENT=23163 DEFAULT CHARSET=latin1;

/*Table structure for table `BuyButtonLogSummaries` */

DROP TABLE IF EXISTS `BuyButtonLogSummaries`;

CREATE TABLE `BuyButtonLogSummaries` (
  `BuyButtonLogSummaryId` int(11) NOT NULL AUTO_INCREMENT,
  `ButtonPositionKey` varchar(50) NOT NULL,
  `TotalClick` int(11) NOT NULL,
  `TotalOrder` int(11) NOT NULL,
  `TotalPrice` int(11) NOT NULL,
  `Date` date NOT NULL,
  PRIMARY KEY (`BuyButtonLogSummaryId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Table structure for table `BuyButtonLogs` */

DROP TABLE IF EXISTS `BuyButtonLogs`;

CREATE TABLE `BuyButtonLogs` (
  `BuyButtonLogId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `OrderId` int(11) DEFAULT NULL,
  `UserId` int(11) DEFAULT NULL,
  `ButtonPositionKey` varchar(50) NOT NULL,
  `SessionId` varchar(40) NOT NULL,
  `ReferrerUrl` varchar(255) NOT NULL,
  `ReferrerWebsite` varchar(255) NOT NULL,
  `UserAgent` varchar(255) NOT NULL,
  `IpNumber` bigint(20) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`BuyButtonLogId`)
) ENGINE=MyISAM AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;

/*Table structure for table `Categories` */

DROP TABLE IF EXISTS `Categories`;

CREATE TABLE `Categories` (
  `CategoryId` int(11) NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(250) NOT NULL,
  `AccessLogPath` varchar(250) NOT NULL,
  `AccessLogPid` int(11) DEFAULT NULL,
  `ErrorLogPath` varchar(250) NOT NULL,
  `ErrorLogPid` int(11) DEFAULT NULL,
  `MysqlAccessLogPath` varchar(250) NOT NULL,
  `MysqlAccessLogPid` int(11) DEFAULT NULL,
  `MysqlErrorLogPath` varchar(250) NOT NULL,
  `MysqlErrorLogPid` int(11) DEFAULT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `IsVisible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`CategoryId`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Table structure for table `EmailTrackings` */

DROP TABLE IF EXISTS `EmailTrackings`;

CREATE TABLE `EmailTrackings` (
  `EmailTrackingId` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(100) NOT NULL,
  `EmailScheduleId` int(11) NOT NULL,
  `UserId` int(11) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`EmailTrackingId`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=latin1;

/*Table structure for table `LogAccesses` */

DROP TABLE IF EXISTS `LogAccesses`;

CREATE TABLE `LogAccesses` (
  `LogAccessId` int(11) NOT NULL AUTO_INCREMENT,
  `Domain` varchar(255) DEFAULT NULL,
  `Controller` varchar(255) NOT NULL,
  `Action` varchar(255) NOT NULL,
  `Url` text,
  `RemoteAddress` bigint(20) NOT NULL,
  `CustomData` text,
  `PHPSESSID` varchar(40) DEFAULT NULL,
  `GET` text,
  `POST` text,
  `COOKIE` text,
  `SERVER` text,
  `SQL` text,
  `CreatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`LogAccessId`)
) ENGINE=InnoDB AUTO_INCREMENT=16729 DEFAULT CHARSET=latin1;

/*Table structure for table `LogErrors` */

DROP TABLE IF EXISTS `LogErrors`;

CREATE TABLE `LogErrors` (
  `LogErrorId` int(11) NOT NULL AUTO_INCREMENT,
  `Domain` varchar(255) NOT NULL,
  `Url` text NOT NULL,
  `RemoteAddress` bigint(20) NOT NULL,
  `GET` text NOT NULL,
  `POST` text NOT NULL,
  `SERVER` text NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`LogErrorId`)
) ENGINE=InnoDB AUTO_INCREMENT=4619 DEFAULT CHARSET=latin1;

/*Table structure for table `LogSQLQueries` */

DROP TABLE IF EXISTS `LogSQLQueries`;

CREATE TABLE `LogSQLQueries` (
  `LogSQLQueryId` int(11) NOT NULL AUTO_INCREMENT,
  `Domain` varchar(255) NOT NULL,
  `RemoteAddress` bigint(20) NOT NULL,
  `Url` text NOT NULL,
  `TotalTime` float NOT NULL,
  `Query` text NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`LogSQLQueryId`)
) ENGINE=InnoDB AUTO_INCREMENT=22099 DEFAULT CHARSET=latin1;

/*Table structure for table `MysqlAccesses` */

DROP TABLE IF EXISTS `MysqlAccesses`;

CREATE TABLE `MysqlAccesses` (
  `AccessId` int(11) NOT NULL AUTO_INCREMENT,
  `Message` text NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`AccessId`)
) ENGINE=MyISAM AUTO_INCREMENT=91 DEFAULT CHARSET=latin1;

/*Table structure for table `MysqlErrors` */

DROP TABLE IF EXISTS `MysqlErrors`;

CREATE TABLE `MysqlErrors` (
  `ErrorId` int(11) NOT NULL AUTO_INCREMENT,
  `Message` text NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ErrorId`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `WebServerAccesses` */

DROP TABLE IF EXISTS `WebServerAccesses`;

CREATE TABLE `WebServerAccesses` (
  `AccessId` int(11) NOT NULL AUTO_INCREMENT,
  `Message` text NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`AccessId`)
) ENGINE=MyISAM AUTO_INCREMENT=3327 DEFAULT CHARSET=latin1;

/*Table structure for table `WebServerErrors` */

DROP TABLE IF EXISTS `WebServerErrors`;

CREATE TABLE `WebServerErrors` (
  `ErrorId` int(11) NOT NULL AUTO_INCREMENT,
  `Message` text NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ErrorId`)
) ENGINE=InnoDB AUTO_INCREMENT=5647 DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
