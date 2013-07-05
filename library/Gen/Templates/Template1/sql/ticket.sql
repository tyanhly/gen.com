/*
SQLyog Enterprise - MySQL GUI v8.18 
MySQL - 5.5.22-0ubuntu1 : Database - ticket_dev
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`ticket_dev` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `ticket_dev`;

/*Table structure for table `AssignedTickets` */

DROP TABLE IF EXISTS `AssignedTickets`;

CREATE TABLE `AssignedTickets` (
  `AssignedTicketId` int(11) NOT NULL AUTO_INCREMENT,
  `TicketId` int(11) DEFAULT NULL,
  `StaffId` int(11) DEFAULT NULL,
  `StaffName` varchar(250) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`AssignedTicketId`),
  KEY `FK_TicketAssigns_Tickets1` (`TicketId`),
  CONSTRAINT `FK_TicketAssigns_Tickets1` FOREIGN KEY (`TicketId`) REFERENCES `Tickets` (`TicketId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Table structure for table `Attachments` */

DROP TABLE IF EXISTS `Attachments`;

CREATE TABLE `Attachments` (
  `AttachmentId` int(11) NOT NULL AUTO_INCREMENT,
  `TicketId` int(11) DEFAULT NULL,
  `TicketConversationId` int(11) DEFAULT NULL,
  `EmailId` int(11) DEFAULT NULL,
  `FileName` varchar(45) DEFAULT NULL,
  `FileType` varchar(45) DEFAULT NULL,
  `FileEncoded` varchar(250) DEFAULT NULL,
  `Content` longtext,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`AttachmentId`),
  KEY `FK_Attachments_1` (`EmailId`),
  KEY `FK_Attachments_2` (`TicketConversationId`),
  KEY `FK_Attachments_TicketId_Tickets` (`TicketId`),
  CONSTRAINT `FK_Attachments_1` FOREIGN KEY (`EmailId`) REFERENCES `Emails` (`EmailId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_Attachments_2` FOREIGN KEY (`TicketConversationId`) REFERENCES `TicketConversations` (`TicketConversationId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Attachments_TicketId_Tickets` FOREIGN KEY (`TicketId`) REFERENCES `Tickets` (`TicketId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Table structure for table `Emails` */

DROP TABLE IF EXISTS `Emails`;

CREATE TABLE `Emails` (
  `EmailId` int(11) NOT NULL AUTO_INCREMENT,
  `EmailSender` varchar(250) DEFAULT NULL,
  `EmailSubject` varchar(500) DEFAULT NULL,
  `EmailHeader` text,
  `EmailContent` text,
  `EmailStatus` enum('PENDING','PROCESSING','COMPLETED') NOT NULL DEFAULT 'PENDING' COMMENT '''PENDING'' when get mail, ''PROCESSING'' : Convert mail to Message ''COMPLETED'': Convert success ',
  `DateSent` datetime DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TicketConversationId` int(11) DEFAULT NULL,
  `MessageId` varchar(255) DEFAULT NULL,
  `ReferenceIds` varchar(255) DEFAULT NULL,
  `EmailIndex` int(11) DEFAULT NULL,
  PRIMARY KEY (`EmailId`),
  KEY `FK_Emails_TicketConversations1` (`TicketConversationId`),
  CONSTRAINT `FK_Emails_TicketConversations1` FOREIGN KEY (`TicketConversationId`) REFERENCES `TicketConversations` (`TicketConversationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

/*Table structure for table `FetchMailLogs` */

DROP TABLE IF EXISTS `FetchMailLogs`;

CREATE TABLE `FetchMailLogs` (
  `FetchMailLogId` int(11) NOT NULL AUTO_INCREMENT,
  `DateStart` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateEnd` datetime DEFAULT NULL,
  `Amount` int(11) DEFAULT NULL,
  `IndexLastMail` int(11) DEFAULT NULL,
  `IndexStartMail` int(11) DEFAULT NULL,
  PRIMARY KEY (`FetchMailLogId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Table structure for table `StaffProfiles` */

DROP TABLE IF EXISTS `StaffProfiles`;

CREATE TABLE `StaffProfiles` (
  `StaffId` int(11) NOT NULL,
  `Signature` text NOT NULL,
  PRIMARY KEY (`StaffId`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `TicketActivityLogRules` */

DROP TABLE IF EXISTS `TicketActivityLogRules`;

CREATE TABLE `TicketActivityLogRules` (
  `TicketActivityLogRuleId` int(11) NOT NULL AUTO_INCREMENT,
  `RuleName` varchar(45) DEFAULT NULL,
  `ControllerName` varchar(45) DEFAULT NULL,
  `ActionName` varchar(45) DEFAULT NULL,
  `Event` varchar(250) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IsDeleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`TicketActivityLogRuleId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

/*Table structure for table `TicketActivityLogs` */

DROP TABLE IF EXISTS `TicketActivityLogs`;

CREATE TABLE `TicketActivityLogs` (
  `TicketActivityLogId` int(11) NOT NULL AUTO_INCREMENT,
  `TicketId` int(11) DEFAULT NULL,
  `StaffId` int(11) DEFAULT NULL,
  `StaffName` varchar(250) DEFAULT NULL,
  `Event` varchar(250) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`TicketActivityLogId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Table structure for table `TicketCategories` */

DROP TABLE IF EXISTS `TicketCategories`;

CREATE TABLE `TicketCategories` (
  `TicketCategoryId` int(11) NOT NULL AUTO_INCREMENT,
  `TicketCategoryName` varchar(250) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IsDeleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`TicketCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `TicketConfigs` */

DROP TABLE IF EXISTS `TicketConfigs`;

CREATE TABLE `TicketConfigs` (
  `TicketConfigId` int(11) NOT NULL AUTO_INCREMENT,
  `ConfigName` varchar(250) DEFAULT NULL,
  `ConfigValue` varchar(250) DEFAULT NULL,
  `ConfigCode` varchar(45) DEFAULT NULL,
  `Description` text,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IsDeleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`TicketConfigId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `TicketConversations` */

DROP TABLE IF EXISTS `TicketConversations`;

CREATE TABLE `TicketConversations` (
  `TicketConversationId` int(11) NOT NULL AUTO_INCREMENT,
  `TicketId` int(11) NOT NULL,
  `StaffId` int(11) DEFAULT NULL,
  `StaffName` varchar(250) DEFAULT NULL,
  `Message` text,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IsTicket` tinyint(1) DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TicketConversationId`),
  KEY `FK_TicketReplies_Tickets1` (`TicketId`),
  CONSTRAINT `FK_TicketReplies_Tickets1` FOREIGN KEY (`TicketId`) REFERENCES `Tickets` (`TicketId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

/*Table structure for table `TicketNotes` */

DROP TABLE IF EXISTS `TicketNotes`;

CREATE TABLE `TicketNotes` (
  `TicketNoteId` int(11) NOT NULL AUTO_INCREMENT,
  `TicketId` int(11) NOT NULL,
  `TicketConversationId` int(11) DEFAULT NULL,
  `StaffId` int(11) DEFAULT NULL,
  `StaffName` varchar(250) DEFAULT NULL,
  `Notes` text,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`TicketNoteId`),
  KEY `FK_TicketNotes_1` (`TicketConversationId`),
  CONSTRAINT `FK_TicketNotes_1` FOREIGN KEY (`TicketConversationId`) REFERENCES `TicketConversations` (`TicketConversationId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Table structure for table `Tickets` */

DROP TABLE IF EXISTS `Tickets`;

CREATE TABLE `Tickets` (
  `TicketId` int(11) NOT NULL AUTO_INCREMENT,
  `TicketCategoryId` int(11) DEFAULT NULL,
  `EmailName` varchar(50) DEFAULT NULL,
  `Email` varchar(250) DEFAULT NULL,
  `Subject` varchar(500) DEFAULT NULL,
  `TicketStatus` enum('NEW','OPENED','NEW-OPENED','CLOSED','WAITING-FOR-CUSTOMER') NOT NULL DEFAULT 'NEW',
  `Priority` enum('LOW','HEIGHT') NOT NULL DEFAULT 'LOW',
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DateUpdated` datetime DEFAULT NULL,
  `CustomerId` varchar(45) DEFAULT NULL,
  `HasAttachment` tinyint(1) DEFAULT NULL,
  `TicketChannel` enum('TICKETC','TICKETB','TICKETE') NOT NULL DEFAULT 'TICKETC',
  `IsDeleted` tinyint(1) NOT NULL DEFAULT '0',
  `ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`TicketId`),
  KEY `FK_Tickets_TicketCategories` (`TicketCategoryId`),
  CONSTRAINT `Tickets_ibfk_1` FOREIGN KEY (`TicketCategoryId`) REFERENCES `TicketCategories` (`TicketCategoryId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
