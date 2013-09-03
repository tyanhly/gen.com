/*
SQLyog Enterprise - MySQL GUI v8.18 
MySQL - 5.5.22-0ubuntu1 : Database - permission
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`permission` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `permission`;

/*Table structure for table `ResourceGroupFilterRules` */

DROP TABLE IF EXISTS `ResourceGroupFilterRules`;

CREATE TABLE `ResourceGroupFilterRules` (
  `ResourceGroupFilterRuleId` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectName` varchar(50) NOT NULL,
  `ResourceGroupName` varchar(50) NOT NULL,
  `FilterPrefix` varchar(50) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`ResourceGroupFilterRuleId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Table structure for table `Resources` */

DROP TABLE IF EXISTS `Resources`;

CREATE TABLE `Resources` (
  `ResourceId` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectName` varchar(50) NOT NULL,
  `ResourceName` varchar(50) NOT NULL,
  `ControllerName` varchar(50) NOT NULL,
  `ActionName` varchar(50) NOT NULL,
  `ResourceGroupName` varchar(50) NOT NULL,
  PRIMARY KEY (`ResourceId`)
) ENGINE=InnoDB AUTO_INCREMENT=429 DEFAULT CHARSET=latin1;

/*Table structure for table `RolePrivilages` */

DROP TABLE IF EXISTS `RolePrivilages`;

CREATE TABLE `RolePrivilages` (
  `RolePrivilageId` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectName` varchar(50) NOT NULL,
  `RoleId` int(11) NOT NULL,
  `ControllerName` varchar(50) NOT NULL,
  `ActionName` varchar(50) NOT NULL,
  `CanAccess` tinyint(1) NOT NULL,
  PRIMARY KEY (`RolePrivilageId`)
) ENGINE=InnoDB AUTO_INCREMENT=423 DEFAULT CHARSET=latin1;

/*Table structure for table `UserGroups` */

DROP TABLE IF EXISTS `UserGroups`;

CREATE TABLE `UserGroups` (
  `UserGroupId` int(11) NOT NULL AUTO_INCREMENT,
  `UserGroup` varchar(50) NOT NULL,
  PRIMARY KEY (`UserGroupId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `UserPrivilages` */

DROP TABLE IF EXISTS `UserPrivilages`;

CREATE TABLE `UserPrivilages` (
  `UserPrivilageId` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectName` varchar(50) NOT NULL,
  `UserId` int(11) NOT NULL,
  `ControllerName` varchar(30) NOT NULL,
  `ActionName` varchar(50) NOT NULL,
  `RolePrivilageId` int(11) DEFAULT NULL,
  `CanAccess` tinyint(1) NOT NULL,
  `PrivilageFrom` enum('ROLE','CUSTOM') NOT NULL,
  PRIMARY KEY (`UserPrivilageId`)
) ENGINE=InnoDB AUTO_INCREMENT=5259 DEFAULT CHARSET=latin1;

/*Table structure for table `UserRolePrivilageDefaultMaps` */

DROP TABLE IF EXISTS `UserRolePrivilageDefaultMaps`;

CREATE TABLE `UserRolePrivilageDefaultMaps` (
  `UserId` int(11) NOT NULL,
  `RoleId` int(11) NOT NULL,
  `ProjectName` varchar(50) NOT NULL,
  PRIMARY KEY (`UserId`,`RoleId`,`ProjectName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `Users` */

DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
  `UserId` int(11) NOT NULL AUTO_INCREMENT,
  `UserGroupId` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(40) NOT NULL,
  PRIMARY KEY (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
