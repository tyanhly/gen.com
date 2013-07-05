/*
SQLyog Enterprise - MySQL GUI v8.18 
MySQL - 5.5.22-0ubuntu1 : Database - cron_management_dev
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`cron_management_dev` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `cron_management_dev`;

/*Table structure for table `CronCalendars` */

DROP TABLE IF EXISTS `CronCalendars`;

CREATE TABLE `CronCalendars` (
  `CronCalendarId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `CronCategoryId` int(11) DEFAULT NULL,
  `Owner` enum('root','www-data','null') DEFAULT 'www-data',
  `CronName` varchar(500) DEFAULT NULL,
  `StartTime` datetime NOT NULL,
  `EndTime` datetime DEFAULT NULL COMMENT 'not use, will upgrade later',
  `Minutes` varchar(10) NOT NULL,
  `Hours` varchar(10) NOT NULL,
  `DayOfMonth` varchar(10) NOT NULL,
  `Months` varchar(10) NOT NULL,
  `DayOfWeek` varchar(10) NOT NULL,
  `AbsoluteFileName` varchar(255) NOT NULL,
  `AbsoluteFileCleanUpName` varchar(255) DEFAULT NULL,
  `ParamsInput` varchar(255) DEFAULT NULL,
  `CleanUpParams` varchar(255) DEFAULT NULL,
  `RunningStatus` enum('PENDING','RUNNING','END') NOT NULL DEFAULT 'PENDING' COMMENT '{"enum":["PENDING","RUNNING","END"]}',
  `MaximumThreads` int(11) unsigned NOT NULL DEFAULT '1',
  `ThreadsPerExecution` int(11) unsigned NOT NULL DEFAULT '1' COMMENT 'field name old  is StartupThreads',
  `ExecutionTimeout` int(11) unsigned DEFAULT NULL,
  `NextExecutionTime` datetime DEFAULT NULL COMMENT 'field name old  is LastExecutedTime',
  `CreatedDate` timestamp NULL DEFAULT NULL COMMENT '{"util":"create time"}',
  `UpdatedDate` timestamp NULL DEFAULT NULL COMMENT '{"util":"update time"}',
  `NotifyEmails` varchar(250) DEFAULT NULL,
  `IsVisible` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`CronCalendarId`),
  KEY `CronCalendars_NextExecutionTime_Index` (`NextExecutionTime`),
  KEY `CronCalendars_RunningStatus_Index` (`RunningStatus`),
  KEY `FK_CronCalendars_CronCategoryId_CronCategories` (`CronCategoryId`),
  CONSTRAINT `FK_CronCalendars_CronCategoryId_CronCategories` FOREIGN KEY (`CronCategoryId`) REFERENCES `CronCategories` (`CronCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Table structure for table `CronCategories` */

DROP TABLE IF EXISTS `CronCategories`;

CREATE TABLE `CronCategories` (
  `CronCategoryId` int(11) NOT NULL AUTO_INCREMENT,
  `CronCategoryName` varchar(250) NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IsVisible` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`CronCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `CronLogs` */

DROP TABLE IF EXISTS `CronLogs`;

CREATE TABLE `CronLogs` (
  `CronLogId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `CronCalendarId` int(10) unsigned NOT NULL COMMENT 'Field Old CronScheduleId',
  `ExecutedScripts` varchar(500) DEFAULT NULL COMMENT 'execute script for only cron',
  `Responded` longtext COMMENT 'Field name old is Response',
  `EndTimeExecuted` datetime DEFAULT NULL,
  `StartTimeExecuted` datetime DEFAULT NULL,
  `CronQueueId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`CronLogId`),
  KEY `FK_CronLogs_CronQueues_CronQueueId` (`CronQueueId`),
  KEY `FK_CronLogs_CronCalendars_CronCalendarId` (`CronCalendarId`),
  CONSTRAINT `FK_CronLogs_CronCalendarId_CronCalendars` FOREIGN KEY (`CronCalendarId`) REFERENCES `CronCalendars` (`CronCalendarId`),
  CONSTRAINT `FK_CronLogs_CronQueueId_CronQueues` FOREIGN KEY (`CronQueueId`) REFERENCES `CronQueues` (`CronQueueId`)
) ENGINE=InnoDB AUTO_INCREMENT=150374 DEFAULT CHARSET=latin1;

/*Table structure for table `CronQueues` */

DROP TABLE IF EXISTS `CronQueues`;

CREATE TABLE `CronQueues` (
  `CronQueueId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `CronCalendarId` int(11) unsigned NOT NULL,
  `QueueStatus` enum('PENDING','RUNNING','COMPLETED','ERROR','EXPIRY','CANCELLED','KILL') NOT NULL DEFAULT 'PENDING',
  `CronRunType` enum('RUN','RUN-CLEAR-UP','RUN-TEST') NOT NULL DEFAULT 'RUN',
  `ExecutionTimeout` int(11) DEFAULT '0',
  `Hostname` varchar(100) NOT NULL,
  `KeyThreads` varchar(100) DEFAULT NULL,
  `Pid` int(11) DEFAULT NULL,
  PRIMARY KEY (`CronQueueId`),
  KEY `CronQueues_QueueStatus_Index` (`QueueStatus`),
  KEY `FK_CronQueues_CronCalendarId_CronCalendars` (`CronCalendarId`),
  CONSTRAINT `FK_CronQueues_CronCalendarId_CronCalendars` FOREIGN KEY (`CronCalendarId`) REFERENCES `CronCalendars` (`CronCalendarId`)
) ENGINE=InnoDB AUTO_INCREMENT=150366 DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
