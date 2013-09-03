/*
SQLyog Enterprise - MySQL GUI v8.18 
MySQL - 5.5.22-0ubuntu1 : Database - email_queue_dev
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`email_queue_dev` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `email_queue_dev`;

/*Table structure for table `EmailQueueAttachments` */

DROP TABLE IF EXISTS `EmailQueueAttachments`;

CREATE TABLE `EmailQueueAttachments` (
  `EmailQueueAttachmentId` int(11) NOT NULL AUTO_INCREMENT,
  `EmailQueueId` int(11) NOT NULL,
  `FileName` varchar(250) CHARACTER SET latin1 NOT NULL,
  `File` longblob NOT NULL,
  PRIMARY KEY (`EmailQueueAttachmentId`),
  KEY `FK_EmailQueueAttachments_EmailQueueId_EmailQueues` (`EmailQueueId`),
  CONSTRAINT `FK_EmailQueueAttachments_EmailQueueId_EmailQueues` FOREIGN KEY (`EmailQueueId`) REFERENCES `EmailQueues` (`EmailQueueId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `EmailQueues` */

DROP TABLE IF EXISTS `EmailQueues`;

CREATE TABLE `EmailQueues` (
  `EmailQueueId` int(11) NOT NULL AUTO_INCREMENT,
  `EmailFrom` varchar(100) CHARACTER SET latin1 NOT NULL,
  `EmailTo` varchar(100) CHARACTER SET latin1 NOT NULL,
  `EmailCc` text CHARACTER SET latin1,
  `EmailBcc` text CHARACTER SET latin1,
  `EmailReplyTo` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `EmailSubject` text CHARACTER SET latin1 NOT NULL,
  `EmailReferences` mediumtext CHARACTER SET latin1,
  `EmailBody` text CHARACTER SET latin1 NOT NULL,
  `SentResults` text CHARACTER SET latin1,
  `HasDailySendingLimit` tinyint(1) NOT NULL DEFAULT '0',
  `SentDate` datetime DEFAULT NULL,
  `Priority` tinyint(1) unsigned NOT NULL DEFAULT '5',
  `QueueStatus` enum('PENDING','SENDING','SENT','ERROR','LIMITED') CHARACTER SET latin1 DEFAULT 'PENDING',
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '{"util":"create time"}',
  `IsVisible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`EmailQueueId`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
