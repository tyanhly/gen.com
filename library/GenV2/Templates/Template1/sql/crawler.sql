/*
SQLyog Enterprise - MySQL GUI v8.18 
MySQL - 5.5.22-0ubuntu1 : Database - crawler
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`crawler` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `crawler`;

/*Table structure for table `SiteLinkContents` */

DROP TABLE IF EXISTS `SiteLinkContents`;

CREATE TABLE `SiteLinkContents` (
  `SiteLinkContentId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `SiteLinkId` int(10) unsigned NOT NULL,
  `FilePath` varchar(255) NOT NULL,
  `ScanTimes` int(11) DEFAULT '0',
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SiteLinkContentId`),
  KEY `FK_SiteLinkContents_SiteLinks` (`SiteLinkId`),
  CONSTRAINT `FK_SiteLinkContents_SiteLinks` FOREIGN KEY (`SiteLinkId`) REFERENCES `SiteLinks` (`SiteLinkId`)
) ENGINE=InnoDB AUTO_INCREMENT=35155 DEFAULT CHARSET=latin1;

/*Table structure for table `SiteLinks` */

DROP TABLE IF EXISTS `SiteLinks`;

CREATE TABLE `SiteLinks` (
  `SiteLinkId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `SiteId` int(11) unsigned NOT NULL,
  `Url` varchar(255) NOT NULL,
  `ParentSiteLinkId` int(11) unsigned DEFAULT NULL,
  `ParentUrl` varchar(255) DEFAULT NULL,
  `IsError` tinyint(1) DEFAULT '0',
  `ErrorMessage` text,
  `ScanTimes` int(11) NOT NULL DEFAULT '0',
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SiteLinkId`),
  UNIQUE KEY `Url` (`Url`),
  UNIQUE KEY `NewIndex1` (`Url`,`ScanTimes`),
  KEY `FK_SiteLinks_ParentSiteLink` (`ParentSiteLinkId`),
  KEY `FK_SiteLinks_SItes` (`SiteId`),
  CONSTRAINT `FK_SiteLinks_ParentSiteLink` FOREIGN KEY (`ParentSiteLinkId`) REFERENCES `SiteLinks` (`SiteLinkId`),
  CONSTRAINT `FK_SiteLinks_SItes` FOREIGN KEY (`SiteId`) REFERENCES `Sites` (`SiteId`)
) ENGINE=InnoDB AUTO_INCREMENT=35694 DEFAULT CHARSET=latin1;

/*Table structure for table `Sites` */

DROP TABLE IF EXISTS `Sites`;

CREATE TABLE `Sites` (
  `SiteId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `SiteLoginLink` varchar(255) DEFAULT NULL,
  `SiteUrl` varchar(255) NOT NULL,
  `LandingUrl` varchar(255) DEFAULT NULL,
  `PostParamsString` varchar(255) DEFAULT NULL,
  `GetParamsString` varchar(255) DEFAULT NULL,
  `UserAgent` varchar(1024) DEFAULT NULL,
  `UrlFilterDontHave` varchar(255) DEFAULT NULL,
  `UrlFilterHave` varchar(255) DEFAULT NULL,
  `ScanDelay` int(11) DEFAULT '0',
  `ScanStatus` enum('Scanning','Stopped','Completed','New','Rescanning','Resuming','Error') DEFAULT 'New',
  `ScanTimes` int(11) NOT NULL DEFAULT '0',
  `ProxyHost` varchar(255) DEFAULT NULL,
  `ProxyPort` int(11) DEFAULT NULL,
  `ProxyUser` varchar(255) DEFAULT NULL,
  `ProxyPass` varchar(255) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SiteId`),
  UNIQUE KEY `NewIndex1` (`SiteUrl`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

/*Table structure for table `SystemConfigs` */

DROP TABLE IF EXISTS `SystemConfigs`;

CREATE TABLE `SystemConfigs` (
  `SystemConfigId` int(11) NOT NULL AUTO_INCREMENT,
  `Key` varchar(255) NOT NULL,
  `Value` varchar(255) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SystemConfigId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `SystemLanguagePage` */

DROP TABLE IF EXISTS `SystemLanguagePage`;

CREATE TABLE `SystemLanguagePage` (
  `Id` int(10) NOT NULL AUTO_INCREMENT,
  `TableNames` varchar(50) NOT NULL COMMENT '{"util":["readonly"]}',
  `Fields` varchar(255) NOT NULL COMMENT '{"util":["readonly"]}',
  `ValueFields` varchar(255) NOT NULL,
  `Hints` varchar(255) DEFAULT NULL,
  `Languages` enum('vi','en') NOT NULL DEFAULT 'en' COMMENT '{"enum":["vi","en"]}',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;

/*Table structure for table `UserAgentBots` */

DROP TABLE IF EXISTS `UserAgentBots`;

CREATE TABLE `UserAgentBots` (
  `UserAgentBotId` int(11) NOT NULL AUTO_INCREMENT,
  `Engine` varchar(255) DEFAULT NULL,
  `UserAgent` varchar(1024) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserAgentBotId`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
