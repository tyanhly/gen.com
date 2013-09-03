/*
SQLyog Enterprise - MySQL GUI v8.18 
MySQL - 5.5.22-0ubuntu1 : Database - hippon_core
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`hippon_core` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `hippon_core`;

/*Table structure for table `AddressPostCodes` */

DROP TABLE IF EXISTS `AddressPostCodes`;

CREATE TABLE `AddressPostCodes` (
  `AddressPostCodeId` int(11) NOT NULL AUTO_INCREMENT,
  `AddressPostCode` int(4) unsigned NOT NULL,
  `Suburb` varchar(45) NOT NULL,
  `State` varchar(4) NOT NULL,
  `Latitude` double NOT NULL DEFAULT '0',
  `Longitude` double NOT NULL DEFAULT '0',
  `IsInvisible` tinyint(1) DEFAULT '0',
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CreatedBy` int(11) DEFAULT '0',
  `IsProcessed` tinyint(4) DEFAULT '0',
  `TimeZone` varchar(250) DEFAULT NULL,
  `GoogleMap` varchar(250) DEFAULT NULL,
  `LatitudeByGoogleMap` double NOT NULL,
  `LongitudeByGoogleMap` double NOT NULL,
  `DifferencePosition` double DEFAULT NULL,
  `SuburbSearch` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`AddressPostCodeId`),
  KEY `idx_lon` (`Longitude`),
  KEY `idx_lat` (`Latitude`),
  KEY `post_code` (`AddressPostCode`),
  KEY `suburb` (`Suburb`),
  KEY `state` (`State`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `AnzTransactionLogs` */

DROP TABLE IF EXISTS `AnzTransactionLogs`;

CREATE TABLE `AnzTransactionLogs` (
  `AnzTransactionLogId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderId` int(11) NOT NULL,
  `CardName` varchar(100) NOT NULL,
  `CardType` varchar(20) NOT NULL,
  `CardNumberSuffix` char(4) NOT NULL,
  `AnzTransactionId` varchar(20) DEFAULT NULL,
  `Amount` int(11) NOT NULL,
  `Method` varchar(20) NOT NULL,
  `PostParams` text NOT NULL,
  `Responses` text NOT NULL COMMENT 'This is Json Encode',
  `ResponseMessage` varchar(255) NOT NULL,
  `CardHash` varchar(40) NOT NULL,
  `IpNumber` int(11) NOT NULL,
  `IsApproved` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`AnzTransactionLogId`),
  KEY `AnzTransactionLogs_OrderId_Orders_FK` (`OrderId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `BusinessAddresses` */

DROP TABLE IF EXISTS `BusinessAddresses`;

CREATE TABLE `BusinessAddresses` (
  `BusinessAddressId` int(11) NOT NULL AUTO_INCREMENT,
  `BusinessId` int(11) NOT NULL,
  `Address1` varchar(255) NOT NULL,
  `Address2` varchar(255) NOT NULL,
  `Suburb` varchar(20) NOT NULL,
  `State` varchar(20) NOT NULL,
  `Country` varchar(20) NOT NULL,
  `PhoneNumber` varchar(14) NOT NULL,
  `GoogleMapImageId` int(11) DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`BusinessAddressId`),
  KEY `BusinessAddresses_BusinessId_Businesses_FK` (`BusinessId`),
  KEY `BusinessAddresses_GoogleMapImageId_Files_FK` (`GoogleMapImageId`),
  CONSTRAINT `BusinessAddresses_BusinessId_Businesses_FK` FOREIGN KEY (`BusinessId`) REFERENCES `Businesses` (`BusinessId`),
  CONSTRAINT `BusinessAddresses_GoogleMapImageId_Files_FK` FOREIGN KEY (`GoogleMapImageId`) REFERENCES `Files` (`FileId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `BusinessBankAccounts` */

DROP TABLE IF EXISTS `BusinessBankAccounts`;

CREATE TABLE `BusinessBankAccounts` (
  `BusinessBankAccountId` int(11) NOT NULL AUTO_INCREMENT,
  `BusinessId` int(11) NOT NULL,
  `BranchNumber` char(7) NOT NULL,
  `BankName` varchar(250) DEFAULT NULL,
  `BranchAddress` varchar(255) DEFAULT NULL,
  `AccountNumber` varchar(10) NOT NULL,
  `AccountHolder` varchar(255) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`BusinessBankAccountId`),
  KEY `BusinessBankAccounts_BusinessId_Businesses_FK` (`BusinessId`),
  CONSTRAINT `BusinessBankAccounts_BusinessId_Businesses_FK` FOREIGN KEY (`BusinessId`) REFERENCES `Businesses` (`BusinessId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Table structure for table `BusinessContacts` */

DROP TABLE IF EXISTS `BusinessContacts`;

CREATE TABLE `BusinessContacts` (
  `BusinessContactId` int(11) NOT NULL AUTO_INCREMENT,
  `Firstname` varchar(50) NOT NULL,
  `Lastname` varchar(50) DEFAULT NULL,
  `Email` varchar(100) NOT NULL,
  `Company` varchar(100) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `Website` varchar(100) DEFAULT NULL,
  `Phone` varchar(20) NOT NULL,
  `DealDescription` text,
  `IsContacted` tinyint(1) DEFAULT '0',
  `DateContacted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`BusinessContactId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `BusinessIndustries` */

DROP TABLE IF EXISTS `BusinessIndustries`;

CREATE TABLE `BusinessIndustries` (
  `BusinessId` int(11) NOT NULL,
  `IndustryId` int(11) NOT NULL,
  PRIMARY KEY (`BusinessId`,`IndustryId`),
  KEY `BusinessIndustries_Industry_Industries_FK` (`IndustryId`),
  CONSTRAINT `BusinessIndustries_BusinessId_Businesses_FK` FOREIGN KEY (`BusinessId`) REFERENCES `Businesses` (`BusinessId`),
  CONSTRAINT `BusinessIndustries_Industry_Industries_FK` FOREIGN KEY (`IndustryId`) REFERENCES `Industries` (`IndustryId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `BusinessLogsVouchers` */

DROP TABLE IF EXISTS `BusinessLogsVouchers`;

CREATE TABLE `BusinessLogsVouchers` (
  `BusinessLogsVoucherId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `BusinessId` int(11) DEFAULT NULL,
  `VoucherId` int(11) DEFAULT NULL,
  `BusinessIsused` tinyint(1) DEFAULT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`BusinessLogsVoucherId`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;

/*Table structure for table `BusinessPaymentAdjustments` */

DROP TABLE IF EXISTS `BusinessPaymentAdjustments`;

CREATE TABLE `BusinessPaymentAdjustments` (
  `BusinessPaymentAdjustmentId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ContractId` int(11) DEFAULT NULL,
  `ContractItemId` int(11) DEFAULT NULL,
  `DealId` int(11) DEFAULT NULL,
  `BusinessPaymentId` int(11) unsigned DEFAULT NULL,
  `Amount` int(11) DEFAULT NULL,
  `Reason` varchar(255) DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`BusinessPaymentAdjustmentId`),
  KEY `BusinessPaymentAdjustments_ContractId_Contracts_FK` (`ContractId`),
  CONSTRAINT `BusinessPaymentAdjustments_ContractId_Contracts_FK` FOREIGN KEY (`ContractId`) REFERENCES `Contracts` (`ContractId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Table structure for table `BusinessPayments` */

DROP TABLE IF EXISTS `BusinessPayments`;

CREATE TABLE `BusinessPayments` (
  `BusinessPaymentId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `PaymentNumber` varchar(50) DEFAULT NULL,
  `BusinessId` int(11) NOT NULL,
  `ContractId` int(11) NOT NULL,
  `ContractItemId` int(11) DEFAULT NULL,
  `DealId` int(11) NOT NULL,
  `DueDay` date NOT NULL,
  `BusinessBankAccountId` int(11) DEFAULT NULL,
  `PercentPayment` double(4,2) NOT NULL,
  `TotalRevenue` int(11) NOT NULL DEFAULT '0',
  `PayableToBusiness` int(11) NOT NULL DEFAULT '0',
  `TotalRefunded` int(11) NOT NULL DEFAULT '0',
  `AdditionalSold` int(11) NOT NULL DEFAULT '0',
  `TotalAdjustment` int(11) NOT NULL DEFAULT '0',
  `PaymentInvoice` int(11) NOT NULL DEFAULT '0',
  `PaymentStatus` enum('PENDING','APPROVED') NOT NULL DEFAULT 'PENDING',
  `LastSendMailToBusiness` datetime DEFAULT NULL,
  `DatePaid` datetime DEFAULT '0000-00-00 00:00:00',
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`BusinessPaymentId`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=latin1;

/*Table structure for table `BusinessResetPasswords` */

DROP TABLE IF EXISTS `BusinessResetPasswords`;

CREATE TABLE `BusinessResetPasswords` (
  `BusinessResetPasswordId` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(100) NOT NULL,
  `SecretKey` varchar(100) NOT NULL,
  `IsUsed` tinyint(1) NOT NULL DEFAULT '0',
  `DateExpired` datetime NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`BusinessResetPasswordId`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

/*Table structure for table `Businesses` */

DROP TABLE IF EXISTS `Businesses`;

CREATE TABLE `Businesses` (
  `BusinessId` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedById` int(11) NOT NULL,
  `BusinessName` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(40) DEFAULT NULL,
  `Website` varchar(100) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `Info` text NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`BusinessId`),
  KEY `Businesses_CreatedById_Staffs_FK` (`CreatedById`),
  CONSTRAINT `Businesses_CreatedById_Staffs_FK` FOREIGN KEY (`CreatedById`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

/*Table structure for table `CampaignSurvey` */

DROP TABLE IF EXISTS `CampaignSurvey`;

CREATE TABLE `CampaignSurvey` (
  `CampaignSurveyId` int(11) NOT NULL AUTO_INCREMENT,
  `CampaignNameSurvey` varchar(255) NOT NULL,
  `Introduction` varchar(500) NOT NULL,
  `DateStart` datetime NOT NULL,
  `DateEnd` datetime NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL DEFAULT '0',
  `IsRandom` tinyint(1) NOT NULL DEFAULT '0',
  `IsGetEmaiSurveyed` tinyint(1) NOT NULL DEFAULT '0',
  `IsMustSurvey` tinyint(1) NOT NULL DEFAULT '0',
  `MessageThankYou` varchar(255) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CampaignSurveyId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `CategoryPhrases` */

DROP TABLE IF EXISTS `CategoryPhrases`;

CREATE TABLE `CategoryPhrases` (
  `CategoryPhraseId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `CategoryPhraseName` varchar(255) DEFAULT NULL,
  `Note` varchar(255) DEFAULT NULL,
  `IsInvisible` tinyint(1) DEFAULT NULL,
  `DateCreated` datetime DEFAULT NULL,
  PRIMARY KEY (`CategoryPhraseId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Table structure for table `ConditionCampaign` */

DROP TABLE IF EXISTS `ConditionCampaign`;

CREATE TABLE `ConditionCampaign` (
  `ConditionCampaignId` int(11) NOT NULL AUTO_INCREMENT,
  `CampaignSurveyId` int(11) NOT NULL,
  `TypeKey` enum('PARAM','SESSION','COOKIE') NOT NULL COMMENT '{"enum":[''PARAM'',''SESSION'',''COOKIE'']}',
  `Key` varchar(255) NOT NULL,
  `Comparison` enum('>','=','<','!=') NOT NULL DEFAULT '=' COMMENT '{"enum":[">","=","<","!="]}',
  `Value` varchar(255) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ConditionCampaignId`),
  KEY `CampaignSurveyId` (`CampaignSurveyId`),
  CONSTRAINT `ConditionCampaign_ibfk_1` FOREIGN KEY (`CampaignSurveyId`) REFERENCES `CampaignSurvey` (`CampaignSurveyId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `ConfigureSaleCommissions` */

DROP TABLE IF EXISTS `ConfigureSaleCommissions`;

CREATE TABLE `ConfigureSaleCommissions` (
  `ConfigureSalesCommissionId` int(11) NOT NULL AUTO_INCREMENT,
  `TotalMinRevenue` int(11) DEFAULT NULL,
  `TotalMaxRevenue` int(11) DEFAULT NULL,
  `Percentage` decimal(4,2) DEFAULT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ConfigureSalesCommissionId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

/*Table structure for table `ContractCustomInvoices` */

DROP TABLE IF EXISTS `ContractCustomInvoices`;

CREATE TABLE `ContractCustomInvoices` (
  `ContractCustomInvoiceId` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedById` int(11) NOT NULL,
  `ContractId` int(11) NOT NULL,
  `InvoiceBody` text NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ContractCustomInvoiceId`),
  KEY `ContractCustomInvoices_ContractId_Contracts_FK` (`ContractId`),
  KEY `ContractCustomInvoices_CreatedById_Staffs_FK` (`CreatedById`),
  CONSTRAINT `ContractCustomInvoices_ContractId_Contracts_FK` FOREIGN KEY (`ContractId`) REFERENCES `Contracts` (`ContractId`),
  CONSTRAINT `ContractCustomInvoices_CreatedById_Staffs_FK` FOREIGN KEY (`CreatedById`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `ContractItemContractItemOptionMaps` */

DROP TABLE IF EXISTS `ContractItemContractItemOptionMaps`;

CREATE TABLE `ContractItemContractItemOptionMaps` (
  `ContractItemId` int(11) NOT NULL,
  `ContractItemOptionId` int(11) NOT NULL,
  PRIMARY KEY (`ContractItemId`,`ContractItemOptionId`),
  KEY `ContractItemContractItemOpMaps_ContractItOpId_ContractItOps_FK` (`ContractItemOptionId`),
  CONSTRAINT `ContractItemContractItemOpMaps_ContractItOpId_ContractItOps_FK` FOREIGN KEY (`ContractItemOptionId`) REFERENCES `ContractItemOptions` (`ContractItemOptionId`),
  CONSTRAINT `ContractItemContractItOptionMaps_ContractItId_ContractIts_FK` FOREIGN KEY (`ContractItemId`) REFERENCES `ContractItems` (`ContractItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `ContractItemOptionGroups` */

DROP TABLE IF EXISTS `ContractItemOptionGroups`;

CREATE TABLE `ContractItemOptionGroups` (
  `ContractItemOptionGroupId` int(11) NOT NULL AUTO_INCREMENT,
  `ContractItemOptionGroup` varchar(50) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`ContractItemOptionGroupId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Table structure for table `ContractItemOptions` */

DROP TABLE IF EXISTS `ContractItemOptions`;

CREATE TABLE `ContractItemOptions` (
  `ContractItemOptionId` int(11) NOT NULL AUTO_INCREMENT,
  `ContractItemOptionGroupId` int(11) NOT NULL,
  `ContractItemOption` varchar(50) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`ContractItemOptionId`),
  KEY `ContractItemOps_ContractItemOpGroupId_ContractItemOpGroups_FK` (`ContractItemOptionGroupId`),
  CONSTRAINT `ContractItemOps_ContractItemOpGroupId_ContractItemOpGroups_FK` FOREIGN KEY (`ContractItemOptionGroupId`) REFERENCES `ContractItemOptionGroups` (`ContractItemOptionGroupId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

/*Table structure for table `ContractItems` */

DROP TABLE IF EXISTS `ContractItems`;

CREATE TABLE `ContractItems` (
  `ContractItemId` int(11) NOT NULL AUTO_INCREMENT,
  `ParentContractItemId` int(11) DEFAULT NULL,
  `ContractId` int(11) NOT NULL,
  `ContractItemTitle` varchar(255) NOT NULL,
  `PriceRetail` int(11) NOT NULL,
  `PriceSell` int(11) NOT NULL,
  `VolumeMin` int(11) NOT NULL,
  `VolumeMax` int(11) NOT NULL,
  `MaxPerPerson` int(11) NOT NULL,
  `TotalRefundedVouchers` int(11) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`ContractItemId`),
  KEY `Contracts_ContractId_Contracts_FK` (`ContractId`),
  KEY `ContractItems_ParentContractItemId_ContractItemId_FK` (`ParentContractItemId`),
  CONSTRAINT `ContractItems_ParentContractItemId_ContractItemId_FK` FOREIGN KEY (`ParentContractItemId`) REFERENCES `ContractItems` (`ContractItemId`),
  CONSTRAINT `Contracts_ContractId_Contracts_FK` FOREIGN KEY (`ContractId`) REFERENCES `Contracts` (`ContractId`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;

/*Table structure for table `ContractSummaries` */

DROP TABLE IF EXISTS `ContractSummaries`;

CREATE TABLE `ContractSummaries` (
  `ContractSummaryId` int(11) NOT NULL AUTO_INCREMENT,
  `ContractId` int(11) NOT NULL,
  `DealId` int(11) NOT NULL,
  `SaleId` int(11) NOT NULL,
  `TotalOrder` int(11) NOT NULL DEFAULT '0',
  `TotalVoucherSold` int(11) NOT NULL DEFAULT '0',
  `TotalOrderCancelled` int(11) NOT NULL DEFAULT '0',
  `TotalPrice` int(20) NOT NULL DEFAULT '0',
  `TotalCreditCashUsed` int(20) NOT NULL DEFAULT '0',
  `TotalCreditPromotionUsed` int(20) NOT NULL DEFAULT '0',
  `TotalPriceCancelled` int(20) NOT NULL DEFAULT '0',
  `TotalOurCommission` int(20) NOT NULL DEFAULT '0',
  `TotalSaleCommission` int(20) NOT NULL DEFAULT '0',
  `TotalReferralCommission` int(20) NOT NULL DEFAULT '0',
  `Date` date NOT NULL,
  PRIMARY KEY (`ContractSummaryId`),
  KEY `ContractSummaries_ContractId_Contracts_FK` (`ContractId`),
  KEY `ContractSummaries_DealId_Deals_FK` (`DealId`),
  KEY `ContractSummaries_SaleId_Staffs_FK` (`SaleId`),
  CONSTRAINT `ContractSummaries_ContractId_Contracts_FK` FOREIGN KEY (`ContractId`) REFERENCES `Contracts` (`ContractId`),
  CONSTRAINT `ContractSummaries_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `ContractSummaries_SaleId_Staffs_FK` FOREIGN KEY (`SaleId`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `Contracts` */

DROP TABLE IF EXISTS `Contracts`;

CREATE TABLE `Contracts` (
  `ContractId` int(11) NOT NULL AUTO_INCREMENT,
  `ParentContractId` int(11) DEFAULT NULL,
  `CreatedById` int(11) NOT NULL,
  `DealCategoryId` int(11) NOT NULL,
  `BusinessId` int(11) NOT NULL,
  `ContractFileId` int(11) DEFAULT NULL,
  `Title` varchar(255) NOT NULL,
  `ContractStatus` enum('TENTATIVE','SIGNED','MOCKED-UP','REVIEWED','READY','COMPLETED') NOT NULL,
  `DateStart` date NOT NULL,
  `DateEnd` date NOT NULL,
  `DateRedeemable` date DEFAULT NULL,
  `DateVoucherExpired` date DEFAULT NULL,
  `SaleId` int(11) DEFAULT NULL,
  `CommissionReferrer` double(4,2) NOT NULL,
  `CommissionSales` double(4,2) NOT NULL COMMENT 'CommissionSales',
  `CommissionOur` double(4,2) NOT NULL,
  `Conditions` text NOT NULL,
  `IsCompleted` tinyint(1) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ContractId`),
  KEY `Contracts_BusinessId_Businesses_FK` (`BusinessId`),
  KEY `Contracts_CategoryId_DealCategories_FK` (`DealCategoryId`),
  KEY `Contracts_ContractFileId_FileId_Files_FK` (`ContractFileId`),
  KEY `Contracts_CreatedById_Staffs_FK` (`CreatedById`),
  KEY `Contracts_SaleId_Staffs_FK` (`SaleId`),
  KEY `Contracts_ParentContractId_ContractId_FK` (`ParentContractId`),
  CONSTRAINT `Contracts_BusinessId_Businesses_FK` FOREIGN KEY (`BusinessId`) REFERENCES `Businesses` (`BusinessId`),
  CONSTRAINT `Contracts_CategoryId_DealCategories_FK` FOREIGN KEY (`DealCategoryId`) REFERENCES `DealCategories` (`DealCategoryId`),
  CONSTRAINT `Contracts_ContractFileId_FileId_Files_FK` FOREIGN KEY (`ContractFileId`) REFERENCES `Files` (`FileId`),
  CONSTRAINT `Contracts_CreatedById_Staffs_FK` FOREIGN KEY (`CreatedById`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `Contracts_ParentContractId_ContractId_FK` FOREIGN KEY (`ParentContractId`) REFERENCES `Contracts` (`ContractId`),
  CONSTRAINT `Contracts_SaleId_Staffs_FK` FOREIGN KEY (`SaleId`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;

/*Table structure for table `CreditCashAccounts` */

DROP TABLE IF EXISTS `CreditCashAccounts`;

CREATE TABLE `CreditCashAccounts` (
  `UserId` int(11) NOT NULL,
  `Amount` int(11) NOT NULL,
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserId`),
  CONSTRAINT `CreditCashAccounts_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `CreditCashLogs` */

DROP TABLE IF EXISTS `CreditCashLogs`;

CREATE TABLE `CreditCashLogs` (
  `CreditCashLogId` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `CreatedById` int(11) DEFAULT NULL,
  `DealId` int(11) DEFAULT NULL,
  `OrderId` int(11) DEFAULT NULL,
  `VoucherId` int(11) DEFAULT NULL,
  `Amount` int(11) NOT NULL,
  `Operation` varchar(20) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CreditCashLogId`),
  KEY `CreditCashLogs_StaffUserId_Users_FK` (`CreatedById`),
  KEY `CreditCashLogs_UserId_Users_FK` (`UserId`),
  KEY `CreditCashLogs_DealId_Deals_FK` (`DealId`),
  KEY `CreditCashLogs_OrderId_Orders_FK` (`OrderId`),
  KEY `CreditCashLogs_VoucherId_Vouchers_FK` (`VoucherId`),
  CONSTRAINT `CreditCashLogs_CreatedById_Staffs_FK` FOREIGN KEY (`CreatedById`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `CreditCashLogs_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `CreditCashLogs_OrderId_Orders_FK` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`OrderId`),
  CONSTRAINT `CreditCashLogs_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `CreditCashLogs_VoucherId_Vouchers_FK` FOREIGN KEY (`VoucherId`) REFERENCES `Vouchers` (`VoucherId`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;

/*Table structure for table `CreditPromotionAccounts` */

DROP TABLE IF EXISTS `CreditPromotionAccounts`;

CREATE TABLE `CreditPromotionAccounts` (
  `CreditPromotionAccountId` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `PromotionId` int(11) NOT NULL,
  `Amount` int(11) NOT NULL,
  `LimitPerOrder` int(11) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DateExpired` datetime NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CreditPromotionAccountId`),
  KEY `CreditPromotionAccounts_UserId_Users_FK` (`UserId`),
  CONSTRAINT `CreditPromotionAccounts_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Table structure for table `CreditPromotionLogs` */

DROP TABLE IF EXISTS `CreditPromotionLogs`;

CREATE TABLE `CreditPromotionLogs` (
  `CreditPromotionLogId` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) NOT NULL,
  `CreditPromotionAccountId` int(11) NOT NULL,
  `DealId` int(11) DEFAULT NULL,
  `OrderId` int(11) DEFAULT NULL,
  `VoucherId` int(11) DEFAULT NULL,
  `Amount` int(11) NOT NULL,
  `Operation` varchar(20) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CreditPromotionLogId`),
  KEY `CreditPromotionLogs_OrderId_Orders_FK` (`OrderId`),
  KEY `CreditPromotionLogs_DealId_Deals_FK` (`DealId`),
  KEY `CreditPromotionLogs_UserId_Users_FK` (`UserId`),
  KEY `CreditPromoLogs_CreditPromoAccountId_CreditPromoAccounts_FK` (`CreditPromotionAccountId`),
  KEY `CreditPromotionLogs_VoucherId_Vouchers_FK` (`VoucherId`),
  CONSTRAINT `CreditPromoLogs_CreditPromoAccountId_CreditPromoAccounts_FK` FOREIGN KEY (`CreditPromotionAccountId`) REFERENCES `CreditPromotionAccounts` (`CreditPromotionAccountId`),
  CONSTRAINT `CreditPromotionLogs_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `CreditPromotionLogs_OrderId_Orders_FK` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`OrderId`),
  CONSTRAINT `CreditPromotionLogs_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`),
  CONSTRAINT `CreditPromotionLogs_VoucherId_Vouchers_FK` FOREIGN KEY (`VoucherId`) REFERENCES `Vouchers` (`VoucherId`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;

/*Table structure for table `DealCategories` */

DROP TABLE IF EXISTS `DealCategories`;

CREATE TABLE `DealCategories` (
  `DealCategoryId` int(11) NOT NULL AUTO_INCREMENT,
  `DealCategory` varchar(50) NOT NULL,
  `DealCategoryPosition` int(11) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`DealCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

/*Table structure for table `DealCities` */

DROP TABLE IF EXISTS `DealCities`;

CREATE TABLE `DealCities` (
  `DealCityId` int(11) NOT NULL AUTO_INCREMENT,
  `State` enum('ACT','NSW','NT','QLD','SA','TAS','VIC','WA') DEFAULT NULL,
  `DealCityName` varchar(50) NOT NULL,
  `TimezoneOffsetMinutes` int(11) NOT NULL,
  `StartDealAtHour` int(11) NOT NULL,
  `Position` int(11) NOT NULL,
  `IsDefault` int(11) NOT NULL DEFAULT '0',
  `IsDisabled` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`DealCityId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

/*Table structure for table `DealImageFiles` */

DROP TABLE IF EXISTS `DealImageFiles`;

CREATE TABLE `DealImageFiles` (
  `DealImageFileId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `FileId` int(11) NOT NULL,
  `Height` int(11) NOT NULL,
  `Width` int(11) NOT NULL,
  `Position` int(11) NOT NULL,
  PRIMARY KEY (`DealImageFileId`),
  KEY `DealImageFiles_DealId_Deals_FK` (`DealId`),
  KEY `DealImageFiles_FileId_Files_FK` (`FileId`),
  CONSTRAINT `DealImageFiles_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `DealImageFiles_FileId_Files_FK` FOREIGN KEY (`FileId`) REFERENCES `Files` (`FileId`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=latin1;

/*Table structure for table `DealItemContractItemMaps` */

DROP TABLE IF EXISTS `DealItemContractItemMaps`;

CREATE TABLE `DealItemContractItemMaps` (
  `DealItemId` int(11) NOT NULL,
  `ContractItemId` int(11) NOT NULL,
  `DealId` int(11) NOT NULL,
  `ContractId` int(11) NOT NULL,
  PRIMARY KEY (`DealItemId`,`ContractItemId`),
  KEY `DealItemContractItemMaps_ContractItemId_ContractItems_FK` (`ContractItemId`),
  KEY `DealItemContractItemMaps_DealId_Deals_FK` (`DealId`),
  KEY `DealItemContractItemMaps_ContractId_Contracts_FK` (`ContractId`),
  CONSTRAINT `DealItemContractItemMaps_ContractId_Contracts_FK` FOREIGN KEY (`ContractId`) REFERENCES `Contracts` (`ContractId`),
  CONSTRAINT `DealItemContractItemMaps_ContractItemId_ContractItems_FK` FOREIGN KEY (`ContractItemId`) REFERENCES `ContractItems` (`ContractItemId`),
  CONSTRAINT `DealItemContractItemMaps_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `DealItemContractItemMaps_DealItemId_DealItems_FK` FOREIGN KEY (`DealItemId`) REFERENCES `DealItems` (`DealItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `DealItems` */

DROP TABLE IF EXISTS `DealItems`;

CREATE TABLE `DealItems` (
  `DealItemId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `DealItemTitle` varchar(255) NOT NULL,
  `PriceRetail` int(11) NOT NULL,
  `PriceSell` int(11) NOT NULL,
  `VolumeMin` int(11) NOT NULL,
  `VolumeMax` int(11) NOT NULL,
  `MaxPerPerson` int(11) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`DealItemId`),
  KEY `DealItems_DealId_Deals_FK` (`DealId`),
  CONSTRAINT `DealItems_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;

/*Table structure for table `DealPaymentMonthlyForSale` */

DROP TABLE IF EXISTS `DealPaymentMonthlyForSale`;

CREATE TABLE `DealPaymentMonthlyForSale` (
  `DealPaymentMonthlyForSaleId` int(11) NOT NULL AUTO_INCREMENT,
  `SalePaymentMonthlyId` int(11) NOT NULL,
  `DealId` int(11) NOT NULL,
  `DateCreated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`DealPaymentMonthlyForSaleId`),
  KEY `SalePaymentMonthlyId` (`SalePaymentMonthlyId`),
  CONSTRAINT `DealPaymentMonthlyForSale_SalePaymentMonthly_FK` FOREIGN KEY (`SalePaymentMonthlyId`) REFERENCES `SalePaymentMonthlyRemove` (`SalePaymentMonthlyId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `DealRevenueSummaryDaily` */

DROP TABLE IF EXISTS `DealRevenueSummaryDaily`;

CREATE TABLE `DealRevenueSummaryDaily` (
  `DealRevenueSummaryDailyId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `DealItemId` int(11) NOT NULL,
  `SaleId` int(11) NOT NULL,
  `VoucherSoldPersonal` int(11) NOT NULL,
  `VoucherGift` int(11) NOT NULL,
  `Revenue` int(11) NOT NULL,
  `CashUsed` int(11) NOT NULL DEFAULT '0',
  `CreditCashUsed` int(11) NOT NULL,
  `CreditPromotionUsed` int(11) NOT NULL,
  `CashRefunded` int(11) NOT NULL DEFAULT '0',
  `CreditCashRefunded` int(11) NOT NULL DEFAULT '0',
  `CreditPromotionRefunded` int(11) NOT NULL DEFAULT '0',
  `ReferrerCommissionAmount` int(11) NOT NULL DEFAULT '0',
  `NumberOfUsersBought` int(11) DEFAULT NULL,
  `NumberOfNewUsersBought` int(11) DEFAULT NULL,
  `DateSummary` date DEFAULT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`DealRevenueSummaryDailyId`),
  UNIQUE KEY `ContractItemId` (`SaleId`,`DateSummary`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20302 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

/*Table structure for table `DealRuntimes` */

DROP TABLE IF EXISTS `DealRuntimes`;

CREATE TABLE `DealRuntimes` (
  `DealRuntimeId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `DealCityId` int(11) NOT NULL,
  `RunDate` date NOT NULL,
  `DealPosition` int(11) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`DealRuntimeId`),
  UNIQUE KEY `DealRuntimes_DealId_DealCityId_RunDate_Unique` (`DealId`,`DealCityId`,`RunDate`),
  KEY `DealRuntimes_DealId_Deals_FK` (`DealId`),
  KEY `DealRuntimes_DealCityId_DealCities_FK` (`DealCityId`),
  CONSTRAINT `DealRuntimes_DealCityId_DealCities_FK` FOREIGN KEY (`DealCityId`) REFERENCES `DealCities` (`DealCityId`),
  CONSTRAINT `DealRuntimes_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`)
) ENGINE=InnoDB AUTO_INCREMENT=542 DEFAULT CHARSET=latin1;

/*Table structure for table `DealSummaries` */

DROP TABLE IF EXISTS `DealSummaries`;

CREATE TABLE `DealSummaries` (
  `DealSummaryId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `SaleId` int(11) NOT NULL,
  `TotalOrders` int(11) NOT NULL DEFAULT '0',
  `TotalVoucherSold` int(11) NOT NULL DEFAULT '0',
  `TotalOrderDelivered` int(11) NOT NULL DEFAULT '0',
  `TotalOrderCancelled` int(11) NOT NULL DEFAULT '0',
  `TotalPrices` int(20) NOT NULL DEFAULT '0',
  `TotalCreditUsed` int(20) NOT NULL DEFAULT '0',
  `TotalPriceDelivered` int(20) NOT NULL DEFAULT '0',
  `TotalPriceCancelled` int(20) NOT NULL DEFAULT '0',
  `TotalCommissions` int(20) NOT NULL DEFAULT '0',
  `TotalSaleCommissions` int(20) NOT NULL DEFAULT '0',
  `TotalReferralCommissions` int(20) NOT NULL DEFAULT '0',
  `Date` date NOT NULL,
  PRIMARY KEY (`DealSummaryId`),
  KEY `DealSummaries_DealId_Deals_FK` (`DealId`),
  KEY `DealSummaries_SaleId_Staffs_FK` (`SaleId`),
  CONSTRAINT `DealSummaries_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `DealSummaries_SaleId_Staffs_FK` FOREIGN KEY (`SaleId`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `Deals` */

DROP TABLE IF EXISTS `Deals`;

CREATE TABLE `Deals` (
  `DealId` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedById` int(11) NOT NULL,
  `DealCategoryId` int(11) NOT NULL,
  `DealStatus` enum('TENTATIVE','SIGNED','MOCKED-UP','REVIEWED','READY','COMPLETED') NOT NULL,
  `DateStart` date NOT NULL,
  `DateEnd` date NOT NULL,
  `DateExpired` date NOT NULL,
  `TitleShort` varchar(255) NOT NULL,
  `TitleLong` varchar(500) NOT NULL,
  `Description` text NOT NULL,
  `Highlights` text NOT NULL,
  `Conditions` text NOT NULL,
  `AboutBusinessTitle` varchar(255) DEFAULT NULL,
  `AboutBusiness` text,
  `AboutBusinessForMobile` text,
  `IsPostalAddressRequired` tinyint(1) NOT NULL,
  `IsDisableCredit` tinyint(1) NOT NULL DEFAULT '1',
  `IsDisabled` tinyint(1) NOT NULL DEFAULT '0',
  `IsGenerateContractSummaries` tinyint(1) NOT NULL DEFAULT '0',
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`DealId`),
  KEY `Deals_DealCategoryId_DealCategories_FK` (`DealCategoryId`),
  KEY `Deals_CreatedByUserId_Users_FK` (`CreatedById`),
  CONSTRAINT `Deals_CreatedById_Staffs_FK` FOREIGN KEY (`CreatedById`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `Deals_DealCategoryId_DealCategories_FK` FOREIGN KEY (`DealCategoryId`) REFERENCES `DealCategories` (`DealCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;

/*Table structure for table `DeliveryLocations` */

DROP TABLE IF EXISTS `DeliveryLocations`;

CREATE TABLE `DeliveryLocations` (
  `DeliveryLocationId` int(11) NOT NULL AUTO_INCREMENT,
  `CityId` int(11) NOT NULL,
  `CostPerKg` int(11) NOT NULL,
  `CostDetails` varchar(255) NOT NULL,
  `DeliveryTime` varchar(255) NOT NULL,
  `DeliveryDetails` text NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`DeliveryLocationId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `DeliveryOptions` */

DROP TABLE IF EXISTS `DeliveryOptions`;

CREATE TABLE `DeliveryOptions` (
  `DeliveryOptionId` int(11) NOT NULL AUTO_INCREMENT,
  `DeliveryOption` varchar(100) NOT NULL,
  `CostPerKg` int(11) NOT NULL,
  `CostDetails` varchar(255) NOT NULL,
  `DeliveryTime` varchar(255) NOT NULL,
  `DeliveryDetails` text NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`DeliveryOptionId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `EmailFriendships` */

DROP TABLE IF EXISTS `EmailFriendships`;

CREATE TABLE `EmailFriendships` (
  `EmailFriendshipId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Email` varchar(255) NOT NULL,
  `Fullname` varchar(255) DEFAULT NULL,
  `OpenidProvider` enum('google','yahoo','facebook','twitter','hotmail','email') DEFAULT NULL,
  `DayOfBirth` date DEFAULT NULL,
  `Profiles` tinytext,
  `IsBecomeUser` tinyint(1) unsigned DEFAULT '0',
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`EmailFriendshipId`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `EmailScheduleDeals` */

DROP TABLE IF EXISTS `EmailScheduleDeals`;

CREATE TABLE `EmailScheduleDeals` (
  `EmailScheduleDealId` int(11) NOT NULL AUTO_INCREMENT,
  `EmailScheduleId` int(11) NOT NULL,
  `DealId` int(11) NOT NULL,
  `TitleShort` varchar(255) NOT NULL,
  `TitleLong` varchar(255) NOT NULL,
  `DealPosition` int(11) NOT NULL,
  PRIMARY KEY (`EmailScheduleDealId`),
  KEY `EmailScheduleDeals_EmailScheduleId_EmailSchedules_FK` (`EmailScheduleId`),
  KEY `EmailScheduleDeals_DealId_Deals_FK` (`DealId`),
  CONSTRAINT `EmailScheduleDeals_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `EmailScheduleDeals_EmailScheduleId_EmailSchedules_FK` FOREIGN KEY (`EmailScheduleId`) REFERENCES `EmailSchedules` (`EmailScheduleId`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

/*Table structure for table `EmailScheduleTestLogs` */

DROP TABLE IF EXISTS `EmailScheduleTestLogs`;

CREATE TABLE `EmailScheduleTestLogs` (
  `EmailScheduleTestLogId` int(11) NOT NULL AUTO_INCREMENT,
  `EmailScheduleId` int(11) NOT NULL,
  `StaffId` int(11) NOT NULL,
  `EmailSendTest` varchar(255) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`EmailScheduleTestLogId`),
  KEY `EmailScheduleTestLogs_EmailScheduleId_EmailSchedules_FK` (`EmailScheduleId`),
  KEY `EmailScheduleTestLogs_StaffId_Staffs_FK` (`StaffId`),
  CONSTRAINT `EmailScheduleTestLogs_EmailScheduleId_EmailSchedules_FK` FOREIGN KEY (`EmailScheduleId`) REFERENCES `EmailSchedules` (`EmailScheduleId`),
  CONSTRAINT `EmailScheduleTestLogs_StaffId_Staffs_FK` FOREIGN KEY (`StaffId`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `EmailScheduleUpdateLogs` */

DROP TABLE IF EXISTS `EmailScheduleUpdateLogs`;

CREATE TABLE `EmailScheduleUpdateLogs` (
  `EmailScheduleUpdateLogId` int(11) NOT NULL AUTO_INCREMENT,
  `EmailScheduleId` int(11) NOT NULL,
  `StaffId` int(11) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`EmailScheduleUpdateLogId`),
  KEY `EmailScheduleUpdateLogs_EmailScheduleId_EmailSchedules_FK` (`EmailScheduleId`),
  KEY `EmailScheduleUpdateLogs_StaffId_Staffs_FK` (`StaffId`),
  CONSTRAINT `EmailScheduleUpdateLogs_EmailScheduleId_EmailSchedules_FK` FOREIGN KEY (`EmailScheduleId`) REFERENCES `EmailSchedules` (`EmailScheduleId`),
  CONSTRAINT `EmailScheduleUpdateLogs_StaffId_Staffs_FK` FOREIGN KEY (`StaffId`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `EmailSchedules` */

DROP TABLE IF EXISTS `EmailSchedules`;

CREATE TABLE `EmailSchedules` (
  `EmailScheduleId` int(11) NOT NULL AUTO_INCREMENT,
  `ScheduleTime` datetime NOT NULL,
  `DealCityId` int(11) NOT NULL,
  `EmailLayoutId` int(11) DEFAULT NULL,
  `CreatedById` int(11) NOT NULL,
  `CustomEmailSubject` varchar(255) DEFAULT NULL,
  `CustomEmailBody` text,
  `Status` enum('PENDING','SENDING','COMPLETED','ERROR') NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`EmailScheduleId`),
  KEY `EmailSchedules_DealCityId_DealCities_FK` (`DealCityId`),
  KEY `EmailSchedules_CreatedById_Staffs_FK` (`CreatedById`),
  CONSTRAINT `EmailSchedules_CreatedById_Staffs_FK` FOREIGN KEY (`CreatedById`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `EmailSchedules_DealCityId_DealCities_FK` FOREIGN KEY (`DealCityId`) REFERENCES `DealCities` (`DealCityId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Table structure for table `EmailTemplates` */

DROP TABLE IF EXISTS `EmailTemplates`;

CREATE TABLE `EmailTemplates` (
  `EmailTemplateId` int(11) NOT NULL AUTO_INCREMENT,
  `KeyName` varchar(50) CHARACTER SET latin1 NOT NULL,
  `Description` text CHARACTER SET latin1 NOT NULL,
  `Subject` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Body` text CHARACTER SET latin1 NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`EmailTemplateId`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

/*Table structure for table `EwayTransactionLogs` */

DROP TABLE IF EXISTS `EwayTransactionLogs`;

CREATE TABLE `EwayTransactionLogs` (
  `EwayTransactionLogId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderId` int(11) DEFAULT NULL,
  `CardName` varchar(100) NOT NULL,
  `CardType` varchar(20) NOT NULL,
  `CardNumberSuffix` char(4) NOT NULL,
  `EwayTransactionId` varchar(100) DEFAULT NULL,
  `Method` varchar(20) NOT NULL,
  `Amount` int(11) NOT NULL,
  `PostParams` text NOT NULL COMMENT 'serialize string',
  `Responses` text NOT NULL COMMENT 'serialize string',
  `ResponseMessage` varchar(255) NOT NULL,
  `IpNumber` int(11) NOT NULL,
  `IsApproved` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`EwayTransactionLogId`),
  KEY `EwayTransactionLogs_OrderId_Orders_FK` (`OrderId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `Faqs` */

DROP TABLE IF EXISTS `Faqs`;

CREATE TABLE `Faqs` (
  `FaqId` int(11) NOT NULL AUTO_INCREMENT,
  `Question` varchar(255) NOT NULL,
  `Answer` text NOT NULL,
  `Position` int(11) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL DEFAULT '1',
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`FaqId`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

/*Table structure for table `Files` */

DROP TABLE IF EXISTS `Files`;

CREATE TABLE `Files` (
  `FileId` int(11) NOT NULL AUTO_INCREMENT,
  `ParentFileId` int(11) DEFAULT NULL,
  `FileCategory` enum('IMAGE','DOC','SOFTWARE','THEME') NOT NULL,
  `Filename` varchar(50) NOT NULL,
  `Url` varchar(255) NOT NULL,
  `FilePath` varchar(255) NOT NULL,
  `FileSize` int(10) unsigned DEFAULT NULL,
  `Extension` varchar(5) NOT NULL,
  `Mimetype` varchar(50) NOT NULL,
  `Caption` varchar(255) DEFAULT NULL,
  `Sha1Hash` varchar(40) NOT NULL,
  `IsProcessed` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`FileId`),
  KEY `Files_ParentFileId_FileId_FK` (`ParentFileId`),
  CONSTRAINT `Files_ParentFileId_FileId_FK` FOREIGN KEY (`ParentFileId`) REFERENCES `Files` (`FileId`)
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=latin1;

/*Table structure for table `GiftVouchers` */

DROP TABLE IF EXISTS `GiftVouchers`;

CREATE TABLE `GiftVouchers` (
  `GiftVoucherId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `VoucherId` int(11) NOT NULL,
  `DealId` int(11) NOT NULL,
  `OrderId` int(11) NOT NULL,
  `DealItemId` int(11) NOT NULL,
  `ContractId` int(11) NOT NULL,
  `ContractItemId` int(11) NOT NULL,
  `OrderContractItemId` int(11) NOT NULL,
  `TransferUserId` int(11) NOT NULL,
  `TransferEmail` varchar(255) DEFAULT NULL,
  `RecipientUserId` int(11) DEFAULT NULL COMMENT 'allow null',
  `RecipientEmail` varchar(255) NOT NULL,
  `OccationId` int(11) unsigned DEFAULT NULL,
  `OccationName` varchar(255) DEFAULT NULL,
  `Subject` varchar(255) DEFAULT NULL,
  `Messages` varchar(500) DEFAULT NULL,
  `VoucherNumber` bigint(14) NOT NULL COMMENT 'Last 2 digits we don''t used it',
  `PriceRetail` int(11) NOT NULL,
  `PriceSell` int(11) NOT NULL,
  `CreditUsed` int(11) NOT NULL,
  `AmountRefunded` int(11) NOT NULL,
  `IsBusinessUsed` tinyint(1) DEFAULT '0',
  `IsUsed` tinyint(1) DEFAULT NULL,
  `IsGift` tinyint(1) DEFAULT NULL,
  `IsAdditional` tinyint(1) DEFAULT NULL,
  `IsCancelled` tinyint(1) DEFAULT NULL,
  `IsFullRefunded` tinyint(1) DEFAULT NULL,
  `DateRedeemable` date NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`GiftVoucherId`),
  KEY `OccationId` (`OccationId`),
  CONSTRAINT `GiftVouchers_ibfk_1` FOREIGN KEY (`OccationId`) REFERENCES `Occasions` (`OccasionId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Table structure for table `HippyEmails` */

DROP TABLE IF EXISTS `HippyEmails`;

CREATE TABLE `HippyEmails` (
  `HippyEmailId` int(11) NOT NULL AUTO_INCREMENT,
  `HippyHourId` int(11) DEFAULT NULL,
  `Email` varchar(50) NOT NULL,
  `UserId` int(11) DEFAULT NULL,
  `InvitedUserId` int(11) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`HippyEmailId`),
  UNIQUE KEY `NewIndex1` (`Email`,`HippyHourId`),
  UNIQUE KEY `NewIndex2` (`HippyHourId`,`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

/*Table structure for table `HippyHours` */

DROP TABLE IF EXISTS `HippyHours`;

CREATE TABLE `HippyHours` (
  `HippyHourId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `DateRun` date NOT NULL,
  `TimeRun` time NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`HippyHourId`),
  UNIQUE KEY `NewIndex1` (`DateRun`,`TimeRun`),
  UNIQUE KEY `NewIndex2` (`DateRun`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Table structure for table `Industries` */

DROP TABLE IF EXISTS `Industries`;

CREATE TABLE `Industries` (
  `IndustryId` int(11) NOT NULL AUTO_INCREMENT,
  `IndustryName` varchar(100) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`IndustryId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

/*Table structure for table `IpCountries` */

DROP TABLE IF EXISTS `IpCountries`;

CREATE TABLE `IpCountries` (
  `IpCountryId` int(11) NOT NULL AUTO_INCREMENT,
  `BeginNumber` int(11) NOT NULL,
  `EndNumber` int(11) NOT NULL,
  `CountryId` int(11) NOT NULL,
  PRIMARY KEY (`IpCountryId`)
) ENGINE=InnoDB AUTO_INCREMENT=160223 DEFAULT CHARSET=latin1;

/*Table structure for table `LazyHelps` */

DROP TABLE IF EXISTS `LazyHelps`;

CREATE TABLE `LazyHelps` (
  `LazyHelpId` int(11) NOT NULL AUTO_INCREMENT,
  `CodeSearch` varchar(500) NOT NULL,
  `Content` text,
  `RelativePosition` varchar(10) NOT NULL,
  `lhController` varchar(20) NOT NULL,
  `lhAction` varchar(20) NOT NULL,
  `ScanScope` varchar(255) NOT NULL DEFAULT '*',
  `Css` varchar(255) DEFAULT NULL,
  `IsInvisible` tinyint(1) DEFAULT '0',
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`LazyHelpId`),
  UNIQUE KEY `NewIndex1` (`CodeSearch`,`lhController`,`lhAction`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Table structure for table `OccasionThemes` */

DROP TABLE IF EXISTS `OccasionThemes`;

CREATE TABLE `OccasionThemes` (
  `OccasionThemeId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `OccasionId` int(11) unsigned NOT NULL,
  `Messages` varchar(255) DEFAULT NULL,
  `Templates` text,
  `FileThumbnails` int(11) DEFAULT NULL,
  `UrlThumbnails` varchar(255) DEFAULT NULL,
  `IsDisabled` tinyint(1) unsigned DEFAULT '0',
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`OccasionThemeId`),
  KEY `OccasionId` (`OccasionId`),
  CONSTRAINT `OccasionThemes_ibfk_1` FOREIGN KEY (`OccasionId`) REFERENCES `Occasions` (`OccasionId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Table structure for table `Occasions` */

DROP TABLE IF EXISTS `Occasions`;

CREATE TABLE `Occasions` (
  `OccasionId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `OccasionName` varchar(255) DEFAULT NULL,
  `IsDisabled` tinyint(1) unsigned DEFAULT '0',
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`OccasionId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Table structure for table `OrderContractItemGiftUsers` */

DROP TABLE IF EXISTS `OrderContractItemGiftUsers`;

CREATE TABLE `OrderContractItemGiftUsers` (
  `OrderContractItemGiftUserId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderContractItemId` int(11) NOT NULL,
  `Firstname` varchar(30) NOT NULL,
  `Lastname` varchar(30) NOT NULL,
  `Email` varchar(255) NOT NULL,
  PRIMARY KEY (`OrderContractItemGiftUserId`),
  KEY `OrderCtractItemGiftUsers_OrderCtractItemId_OrderCtractItems_FK` (`OrderContractItemId`),
  CONSTRAINT `OrderCtractItemGiftUsers_OrderCtractItemId_OrderCtractItems_FK` FOREIGN KEY (`OrderContractItemId`) REFERENCES `OrderContractItems` (`OrderContractItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `OrderContractItemOptionMaps` */

DROP TABLE IF EXISTS `OrderContractItemOptionMaps`;

CREATE TABLE `OrderContractItemOptionMaps` (
  `OrderContractItemOptionMapId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderContractItemId` int(11) NOT NULL,
  `ContractItemOptionId` int(11) NOT NULL,
  `ContractItemOption` varchar(50) NOT NULL,
  PRIMARY KEY (`OrderContractItemOptionMapId`),
  KEY `OrderCtractItemOpMaps_CtractItemOpId_CtractItemOps_FK` (`ContractItemOptionId`),
  KEY `OrderCtracttItemOptionMaps_OrderCtractItemId_OrderCtractItems_FK` (`OrderContractItemId`),
  CONSTRAINT `OrderCtractItemOpMaps_CtractItemOpId_CtractItemOps_FK` FOREIGN KEY (`ContractItemOptionId`) REFERENCES `ContractItemOptions` (`ContractItemOptionId`),
  CONSTRAINT `OrderCtracttItemOptionMaps_OrderCtractItemId_OrderCtractItems_FK` FOREIGN KEY (`OrderContractItemId`) REFERENCES `OrderContractItems` (`OrderContractItemId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `OrderContractItems` */

DROP TABLE IF EXISTS `OrderContractItems`;

CREATE TABLE `OrderContractItems` (
  `OrderContractItemId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderId` int(11) NOT NULL,
  `DealItemId` int(11) NOT NULL,
  `ContractId` int(11) NOT NULL,
  `ContractItemId` int(11) NOT NULL,
  `TotalVoucherPersonal` int(11) NOT NULL,
  `TotalVoucherGift` int(11) NOT NULL,
  `TotalPrice` int(11) NOT NULL,
  `QRCode` varchar(255) NOT NULL,
  PRIMARY KEY (`OrderContractItemId`),
  KEY `OrderContractItems_ContractItemId_ContractItems_FK` (`ContractItemId`),
  KEY `OrderContractItems_OrderId_Orders_FK` (`OrderId`),
  KEY `OrderContractItems_ContractId_Contracts_FK` (`ContractId`),
  CONSTRAINT `OrderContractItems_ContractId_Contracts_FK` FOREIGN KEY (`ContractId`) REFERENCES `Contracts` (`ContractId`),
  CONSTRAINT `OrderContractItems_ContractItemId_ContractItems_FK` FOREIGN KEY (`ContractItemId`) REFERENCES `ContractItems` (`ContractItemId`),
  CONSTRAINT `OrderContractItems_OrderId_Orders_FK` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`OrderId`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=latin1;

/*Table structure for table `OrderLogs` */

DROP TABLE IF EXISTS `OrderLogs`;

CREATE TABLE `OrderLogs` (
  `OrderLogId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderId` int(11) NOT NULL,
  `DealId` int(11) NOT NULL,
  `UserId` int(11) DEFAULT NULL,
  `OrderStatus` enum('PENDING','ERROR','COMPLETED','CANCELLED') NOT NULL,
  `TotalVoucherPersonal` int(11) NOT NULL,
  `TotalVoucherGift` int(11) NOT NULL,
  `TotalPrice` int(11) NOT NULL,
  `CreditCashUsed` int(11) NOT NULL,
  `CreditPromotionUsed` int(11) NOT NULL,
  `OrderChannel` varchar(20) NOT NULL COMMENT 'Website, Mobile, iPhone App, Android App',
  `NumberOfRetries` int(11) NOT NULL,
  `QRCode` varchar(255) NOT NULL,
  `IpNumber` int(11) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`OrderLogId`),
  KEY `OrderLogs_DealId_Deals_FK` (`DealId`),
  KEY `OrderLogs_UserId_Users_FK` (`UserId`),
  CONSTRAINT `OrderLogs_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `OrderLogs_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Table structure for table `OrderUserPostalAddresses` */

DROP TABLE IF EXISTS `OrderUserPostalAddresses`;

CREATE TABLE `OrderUserPostalAddresses` (
  `OrderUserPostalAddressId` int(11) NOT NULL AUTO_INCREMENT,
  `UserPostalAddressId` int(11) DEFAULT NULL,
  `OrderId` int(11) NOT NULL,
  `IsGift` int(11) NOT NULL,
  `Firstname` varchar(30) NOT NULL,
  `Lastname` varchar(30) NOT NULL,
  `PhoneNumber` varchar(50) NOT NULL,
  `Address1` varchar(255) NOT NULL,
  `Address2` varchar(255) NOT NULL,
  `Suburb` varchar(20) NOT NULL,
  `State` varchar(20) NOT NULL,
  `Postcode` char(4) NOT NULL,
  `DeliveryOptionId` int(11) DEFAULT NULL,
  `LastUpdated` datetime DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`OrderUserPostalAddressId`),
  KEY `OrderUserPostalAddresses_OrderId_Orders_FK` (`OrderId`),
  KEY `OrderUserPostalAddress_DeliveryOptionId_DeliveryOptions_FK` (`DeliveryOptionId`),
  KEY `OrderPostalAddresses_UserPostalAddressId_PostalAddresses_FK` (`UserPostalAddressId`),
  CONSTRAINT `OrderPostalAddresses_UserPostalAddressId_PostalAddresses_FK` FOREIGN KEY (`UserPostalAddressId`) REFERENCES `UserPostalAddresses` (`UserPostalAddressId`),
  CONSTRAINT `OrderUserPostalAddresses_OrderId_Orders_FK` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`OrderId`),
  CONSTRAINT `OrderUserPostalAddress_DeliveryOptionId_DeliveryOptions_FK` FOREIGN KEY (`DeliveryOptionId`) REFERENCES `DeliveryOptions` (`DeliveryOptionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `Orders` */

DROP TABLE IF EXISTS `Orders`;

CREATE TABLE `Orders` (
  `OrderId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `UserId` int(11) DEFAULT NULL,
  `OrderStatus` enum('PENDING','ERROR','COMPLETED','CANCELLED') NOT NULL,
  `TotalVoucherPersonal` int(11) NOT NULL,
  `TotalVoucherGift` int(11) NOT NULL,
  `TotalPrice` int(11) NOT NULL,
  `CashUsed` int(11) NOT NULL DEFAULT '0',
  `CreditCashUsed` int(11) NOT NULL,
  `CreditPromotionUsed` int(11) NOT NULL,
  `CashRefunded` int(11) NOT NULL DEFAULT '0',
  `CreditCashRefunded` int(11) NOT NULL DEFAULT '0',
  `CreditPromotionRefunded` int(11) NOT NULL DEFAULT '0',
  `ReferrerCommissionAmount` int(11) NOT NULL DEFAULT '0',
  `OrderChannel` varchar(20) NOT NULL COMMENT 'Website, Mobile, iPhone App, Android App',
  `NumberOfRetries` int(11) NOT NULL,
  `QRCode` varchar(255) NOT NULL,
  `IpNumber` int(11) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`OrderId`),
  KEY `Orders_UserId_Users_FK` (`UserId`),
  KEY `Orders_DealId_Deals_FK` (`DealId`),
  CONSTRAINT `Orders_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `Orders_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;

/*Table structure for table `PaymentProcessors` */

DROP TABLE IF EXISTS `PaymentProcessors`;

CREATE TABLE `PaymentProcessors` (
  `PaymentProcessorId` int(11) NOT NULL AUTO_INCREMENT,
  `PaymentProcessorName` varchar(30) NOT NULL,
  `FixedFee` int(11) NOT NULL,
  `TransferRate` float NOT NULL,
  PRIMARY KEY (`PaymentProcessorId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `PaymentTransactions` */

DROP TABLE IF EXISTS `PaymentTransactions`;

CREATE TABLE `PaymentTransactions` (
  `PaymentTransactionId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderId` int(11) NOT NULL,
  `UserId` int(11) DEFAULT NULL,
  `Type` enum('PREAUTH','CAPTURE','REFUND') NOT NULL,
  `Amount` int(11) NOT NULL,
  `CreditUsed` int(11) NOT NULL,
  `TransactionLogId` int(11) NOT NULL,
  `MerchantTransactionId` varchar(100) NOT NULL,
  `CardExpiryMonth` char(2) NOT NULL,
  `CardExpiryYear` char(4) NOT NULL,
  `PaymentGateway` enum('ANZ','WARRIOR','EWAY','PAYPAL','CREDIT') NOT NULL,
  `IpNumber` bigint(20) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PaymentTransactionId`),
  KEY `PaymentTransactions_OrderId_Orders_FK` (`OrderId`),
  KEY `PaymentTransactions_UserId_Users_FK` (`UserId`),
  CONSTRAINT `PaymentTransactions_OrderId_Orders_FK` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`OrderId`),
  CONSTRAINT `PaymentTransactions_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;

/*Table structure for table `PaypalOrderStatuses` */

DROP TABLE IF EXISTS `PaypalOrderStatuses`;

CREATE TABLE `PaypalOrderStatuses` (
  `PaypalOrderStatusId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderId` int(11) NOT NULL,
  `PaymentTransactionId` int(11) NOT NULL,
  `OrderStatus` varchar(30) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PaypalOrderStatusId`),
  KEY `PaypalOrderStatuses_OrderId_Orders_FK` (`OrderId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `Phrases` */

DROP TABLE IF EXISTS `Phrases`;

CREATE TABLE `Phrases` (
  `PhraseId` double NOT NULL AUTO_INCREMENT,
  `CategoryPhraseId` double DEFAULT NULL,
  `PhraseKey` varchar(765) DEFAULT NULL,
  `PhraseNewKey` varchar(765) DEFAULT NULL,
  `PhraseText` varchar(765) DEFAULT NULL,
  `Controller` varchar(765) DEFAULT NULL,
  `Language` varchar(6) DEFAULT NULL,
  `IsInvisible` tinyint(1) DEFAULT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PhraseId`)
) ENGINE=InnoDB AUTO_INCREMENT=345 DEFAULT CHARSET=latin1;

/*Table structure for table `Phrases-backup` */

DROP TABLE IF EXISTS `Phrases-backup`;

CREATE TABLE `Phrases-backup` (
  `PhraseId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `CategoryPhraseId` int(11) unsigned NOT NULL,
  `PhraseKey` varchar(255) NOT NULL,
  `PhraseNewKey` varchar(255) DEFAULT NULL,
  `PhraseText` varchar(255) NOT NULL,
  `Controller` varchar(255) NOT NULL,
  `Language` enum('EN','VI') NOT NULL DEFAULT 'EN' COMMENT '{"enum":["EN","VI"]}',
  `IsInvisible` tinyint(1) unsigned DEFAULT '0',
  `CreatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PhraseId`),
  UNIQUE KEY `PhraseKey` (`PhraseKey`),
  KEY `CategoryPhraseId` (`CategoryPhraseId`),
  CONSTRAINT `Phrases_CategoryPhrases_FK` FOREIGN KEY (`CategoryPhraseId`) REFERENCES `CategoryPhrases` (`CategoryPhraseId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `RefundedVoucherLogs` */

DROP TABLE IF EXISTS `RefundedVoucherLogs`;

CREATE TABLE `RefundedVoucherLogs` (
  `RefundedVoucherLogId` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedById` int(11) NOT NULL,
  `DealId` int(11) NOT NULL,
  `ContractId` int(11) NOT NULL,
  `VoucherId` int(11) NOT NULL,
  `Amount` int(11) NOT NULL,
  `CreditCashAmount` int(11) NOT NULL,
  `CreditPromotionAmount` int(11) NOT NULL,
  `RefundedReason` varchar(255) DEFAULT NULL,
  `EmailSentToCustomer` tinyint(1) NOT NULL,
  `EmailSentToBusiness` tinyint(1) NOT NULL,
  `TakeEntirelyFromHoldback` tinyint(1) NOT NULL,
  `IsApproved` tinyint(1) NOT NULL,
  `IsManualRefund` tinyint(1) NOT NULL,
  `BusinessPaymentId` int(11) DEFAULT NULL,
  `SalePaymentMonthlyId` int(11) DEFAULT NULL,
  `DateRefunded` datetime DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`RefundedVoucherLogId`),
  KEY `RefundedVoucherLogs_CreatedByUserId_Users_FK` (`CreatedById`),
  KEY `RefundedVoucherLogs_ContractId_Contracts_FK` (`ContractId`),
  KEY `RefundedVoucherLogs_DealId_Deals_FK` (`DealId`),
  KEY `RefundedVoucherLogs_VoucherId_Vouchers_FK` (`VoucherId`),
  KEY `RefundedVoucherLogs_SalePaymentMonthlyId_SalePaymentMonthly_FK` (`SalePaymentMonthlyId`),
  CONSTRAINT `RefundedVoucherLogs_ContractId_Contracts_FK` FOREIGN KEY (`ContractId`) REFERENCES `Contracts` (`ContractId`),
  CONSTRAINT `RefundedVoucherLogs_CreatedById_Staffs_FK` FOREIGN KEY (`CreatedById`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `RefundedVoucherLogs_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `RefundedVoucherLogs_SalePaymentMonthlyId_SalePaymentMonthly_FK` FOREIGN KEY (`SalePaymentMonthlyId`) REFERENCES `SalePaymentMonthlyRemove` (`SalePaymentMonthlyId`),
  CONSTRAINT `RefundedVoucherLogs_VoucherId_Vouchers_FK` FOREIGN KEY (`VoucherId`) REFERENCES `Vouchers` (`VoucherId`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;

/*Table structure for table `SaleBonusMonthly` */

DROP TABLE IF EXISTS `SaleBonusMonthly`;

CREATE TABLE `SaleBonusMonthly` (
  `SaleBonusMonthlyId` int(11) NOT NULL AUTO_INCREMENT,
  `SaleId` int(11) DEFAULT NULL,
  `TotalRevenue` int(11) DEFAULT NULL,
  `TotalRefunded` int(11) DEFAULT NULL,
  `Percentage` double(4,2) DEFAULT NULL,
  `TotalBonus` int(11) DEFAULT NULL,
  `ForMonth` varchar(7) DEFAULT NULL,
  `FromDate` datetime DEFAULT NULL,
  `ToDate` datetime DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SaleBonusMonthlyId`),
  UNIQUE KEY `SaleId_ForMonth` (`SaleId`,`ForMonth`) USING BTREE,
  KEY `SaleId` (`SaleId`) USING BTREE,
  CONSTRAINT `SaleBonusMonthly_ibfk_1` FOREIGN KEY (`SaleId`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

/*Table structure for table `SaleLeadOwnerLogs` */

DROP TABLE IF EXISTS `SaleLeadOwnerLogs`;

CREATE TABLE `SaleLeadOwnerLogs` (
  `SaleLeadOwnerLogId` int(11) NOT NULL AUTO_INCREMENT,
  `SaleLeadId` int(11) DEFAULT NULL,
  `SaleId` int(11) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SaleLeadOwnerLogId`),
  KEY `FK_SaleLeadOwerLogs` (`SaleLeadId`),
  KEY `FK_SaleLeadOwerLogs1` (`SaleId`),
  CONSTRAINT `FK_SaleLeadOwerLogs` FOREIGN KEY (`SaleLeadId`) REFERENCES `SaleLeads` (`SaleLeadId`),
  CONSTRAINT `FK_SaleLeadOwerLogs1` FOREIGN KEY (`SaleId`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;

/*Table structure for table `SaleLeadTranferLogs` */

DROP TABLE IF EXISTS `SaleLeadTranferLogs`;

CREATE TABLE `SaleLeadTranferLogs` (
  `SaleLeadTranferLogId` int(11) NOT NULL AUTO_INCREMENT,
  `FromSaleId` int(11) DEFAULT NULL,
  `ToSaleId` int(11) DEFAULT NULL,
  `SaleLeadId` int(11) DEFAULT NULL,
  `Comment` text,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SaleLeadTranferLogId`),
  KEY `FK_SaleLeadTranferLogs` (`ToSaleId`),
  KEY `FK_SaleLeadTranferLogs1` (`FromSaleId`),
  KEY `FK_SaleLeadTranferLogs2` (`SaleLeadId`),
  CONSTRAINT `FK_SaleLeadTranferLogs` FOREIGN KEY (`ToSaleId`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `FK_SaleLeadTranferLogs1` FOREIGN KEY (`FromSaleId`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `FK_SaleLeadTranferLogs2` FOREIGN KEY (`SaleLeadId`) REFERENCES `SaleLeads` (`SaleLeadId`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

/*Table structure for table `SaleLeadTransferQueues` */

DROP TABLE IF EXISTS `SaleLeadTransferQueues`;

CREATE TABLE `SaleLeadTransferQueues` (
  `SaleLeadTransferQueueId` int(11) NOT NULL AUTO_INCREMENT,
  `FromSaleId` int(11) DEFAULT NULL,
  `ToSaleId` int(11) DEFAULT NULL,
  `SaleLeadId` int(11) DEFAULT NULL,
  `Comment` text,
  `Status` enum('PENDING','RECEIVED','REFUSE') DEFAULT 'PENDING',
  `DateUpdated` datetime DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SaleLeadTransferQueueId`),
  KEY `FK_SaleLeadTransferQueues` (`ToSaleId`),
  KEY `FK_SaleLeadTransferQueues1` (`FromSaleId`),
  KEY `FK_SaleLeadTransferQueues2` (`SaleLeadId`),
  CONSTRAINT `FK_SaleLeadTransferQueues` FOREIGN KEY (`ToSaleId`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `FK_SaleLeadTransferQueues1` FOREIGN KEY (`FromSaleId`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `FK_SaleLeadTransferQueues2` FOREIGN KEY (`SaleLeadId`) REFERENCES `SaleLeads` (`SaleLeadId`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;

/*Table structure for table `SaleLeadUpdateLogs` */

DROP TABLE IF EXISTS `SaleLeadUpdateLogs`;

CREATE TABLE `SaleLeadUpdateLogs` (
  `SaleUpdateLogId` int(11) NOT NULL AUTO_INCREMENT,
  `SaleLeadId` int(11) DEFAULT NULL,
  `SaleId` int(11) DEFAULT NULL,
  `Data` text,
  `Comment` text,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SaleUpdateLogId`),
  KEY `SaleLeadId` (`SaleLeadId`),
  KEY `FK_SaleLeadContactLogs` (`SaleId`),
  CONSTRAINT `FK_SaleLeadContactLogs` FOREIGN KEY (`SaleId`) REFERENCES `Staffs` (`StaffId`),
  CONSTRAINT `SaleContactLogs_SaleLeads_FK` FOREIGN KEY (`SaleLeadId`) REFERENCES `SaleLeads` (`SaleLeadId`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1;

/*Table structure for table `SaleLeads` */

DROP TABLE IF EXISTS `SaleLeads`;

CREATE TABLE `SaleLeads` (
  `SaleLeadId` int(11) NOT NULL AUTO_INCREMENT,
  `SaleId` int(11) DEFAULT NULL,
  `SaleLeadStatus` enum('HOT-LEAD','COLD-LEAD','CALL-BACK','DEAD-LEAD','COMPLETED') NOT NULL COMMENT '{''enum'':''HOT-LEAD'',''COLD-LEAD'',''CALL-BACK'',''DEAD-LEAD'',''COMPLETED''}',
  `DateCalled` datetime DEFAULT NULL,
  `CallOn` datetime DEFAULT NULL,
  `IndustryId` int(11) DEFAULT NULL,
  `BusinessId` int(11) DEFAULT NULL,
  `BusinessClass` enum('A','B','C') DEFAULT 'A',
  `BusinessName` varchar(100) NOT NULL,
  `ContactName` varchar(50) NOT NULL,
  `ContactEmail` varchar(255) DEFAULT NULL,
  `ContactPhone` varchar(14) NOT NULL,
  `Address1` varchar(255) NOT NULL,
  `Address2` varchar(255) DEFAULT '',
  `Suburb` varchar(20) NOT NULL,
  `State` varchar(20) NOT NULL,
  `Website` varchar(100) DEFAULT NULL,
  `DealOffered` text,
  `Comment` varchar(255) DEFAULT NULL,
  `IsDisabled` tinyint(1) NOT NULL DEFAULT '0',
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SaleLeadId`),
  KEY `SaleLeads_BusinessId_Businesses_FK` (`BusinessId`),
  KEY `SaleId` (`SaleId`),
  CONSTRAINT `FK_SaleLeads` FOREIGN KEY (`SaleId`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

/*Table structure for table `SalePaymentMonthlyRemove` */

DROP TABLE IF EXISTS `SalePaymentMonthlyRemove`;

CREATE TABLE `SalePaymentMonthlyRemove` (
  `SalePaymentMonthlyId` int(11) NOT NULL AUTO_INCREMENT,
  `SaleId` int(11) DEFAULT NULL,
  `TotalRevenue` int(11) DEFAULT NULL,
  `TotalMinRevenue` int(11) DEFAULT NULL,
  `TotalMaxRevenue` int(11) DEFAULT NULL,
  `Percentage` decimal(4,2) DEFAULT NULL,
  `ForMonth` varchar(10) DEFAULT NULL,
  `TotalRefunedNextMonth` int(11) DEFAULT NULL,
  `TotalAdditionalNextMonth` int(11) DEFAULT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`SalePaymentMonthlyId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `SaleRevenueSummaryDaily` */

DROP TABLE IF EXISTS `SaleRevenueSummaryDaily`;

CREATE TABLE `SaleRevenueSummaryDaily` (
  `SaleRevenueSummaryDailyId` int(11) NOT NULL AUTO_INCREMENT,
  `SaleId` int(11) NOT NULL,
  `VoucherSoldPersonal` int(11) NOT NULL,
  `VoucherGift` int(11) NOT NULL,
  `Revenue` int(11) NOT NULL,
  `CashUsed` int(11) NOT NULL DEFAULT '0',
  `CreditCashUsed` int(11) NOT NULL,
  `CreditPromotionUsed` int(11) NOT NULL,
  `CashRefunded` int(11) NOT NULL DEFAULT '0',
  `CreditCashRefunded` int(11) NOT NULL DEFAULT '0',
  `CreditPromotionRefunded` int(11) NOT NULL DEFAULT '0',
  `ReferrerCommissionAmount` int(11) NOT NULL DEFAULT '0',
  `NumberOfUsersBought` int(11) DEFAULT NULL,
  `NumberOfNewUsersBought` int(11) DEFAULT NULL,
  `DateSummary` date DEFAULT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SaleRevenueSummaryDailyId`),
  UNIQUE KEY `ContractItemId` (`SaleId`,`DateSummary`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20225 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

/*Table structure for table `StaffGroupMaps` */

DROP TABLE IF EXISTS `StaffGroupMaps`;

CREATE TABLE `StaffGroupMaps` (
  `StaffId` int(11) NOT NULL,
  `StaffGroupId` int(11) NOT NULL,
  PRIMARY KEY (`StaffId`,`StaffGroupId`),
  KEY `StaffGroupMaps_StaffGroupId_StaffGroups_FK` (`StaffGroupId`),
  CONSTRAINT `StaffGroupMaps_StaffGroupId_StaffGroups_FK` FOREIGN KEY (`StaffGroupId`) REFERENCES `StaffGroups` (`StaffGroupId`),
  CONSTRAINT `StaffGroupMaps_StaffId_Staffs_FK` FOREIGN KEY (`StaffId`) REFERENCES `Staffs` (`StaffId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `StaffGroups` */

DROP TABLE IF EXISTS `StaffGroups`;

CREATE TABLE `StaffGroups` (
  `StaffGroupId` int(11) NOT NULL AUTO_INCREMENT,
  `StaffGroup` varchar(50) NOT NULL,
  `Rank` int(11) NOT NULL,
  PRIMARY KEY (`StaffGroupId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Table structure for table `Staffs` */

DROP TABLE IF EXISTS `Staffs`;

CREATE TABLE `Staffs` (
  `StaffId` int(11) NOT NULL AUTO_INCREMENT,
  `Firstname` varchar(50) NOT NULL,
  `Lastname` varchar(50) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` char(40) NOT NULL,
  `Salt` char(4) NOT NULL,
  `Signature` varchar(250) DEFAULT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` enum('MALE','FEMALE','OTHER') NOT NULL,
  `ContractCommissionRate` double(4,2) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  `DateJoined` datetime NOT NULL,
  PRIMARY KEY (`StaffId`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

/*Table structure for table `StaticContents` */

DROP TABLE IF EXISTS `StaticContents`;

CREATE TABLE `StaticContents` (
  `StaticContentId` int(11) NOT NULL AUTO_INCREMENT,
  `Title` text NOT NULL,
  `Content` text NOT NULL,
  `StaticContentKey` varchar(50) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`StaticContentId`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

/*Table structure for table `StaticContents-backup` */

DROP TABLE IF EXISTS `StaticContents-backup`;

CREATE TABLE `StaticContents-backup` (
  `StaticContentId` int(11) NOT NULL AUTO_INCREMENT,
  `Title` text NOT NULL,
  `Content` text NOT NULL,
  `StaticContentKey` varchar(50) NOT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`StaticContentId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `Subscriptions` */

DROP TABLE IF EXISTS `Subscriptions`;

CREATE TABLE `Subscriptions` (
  `SubscriptionId` int(11) NOT NULL AUTO_INCREMENT,
  `DealCityId` int(11) NOT NULL,
  `UserId` int(11) DEFAULT NULL,
  `Email` varchar(100) NOT NULL,
  `SessionId` char(32) NOT NULL,
  `Host` varchar(100) NOT NULL,
  `ReferrerUrl` varchar(255) NOT NULL,
  `LandingUrl` varchar(255) NOT NULL,
  `UserAgent` varchar(200) NOT NULL,
  `IpNumber` int(11) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SubscriptionId`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `UserId` (`UserId`),
  KEY `DealCityId` (`DealCityId`),
  CONSTRAINT `Subscriptions_ibfk_2` FOREIGN KEY (`DealCityId`) REFERENCES `DealCities` (`DealCityId`),
  CONSTRAINT `Subscriptions_ibfk_3` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

/*Table structure for table `SurveyAnswers` */

DROP TABLE IF EXISTS `SurveyAnswers`;

CREATE TABLE `SurveyAnswers` (
  `SurveyAnswerId` int(11) NOT NULL AUTO_INCREMENT,
  `SurveyQuestionId` int(11) DEFAULT NULL,
  `Answer` varchar(255) DEFAULT NULL,
  `StaffNote` varchar(255) DEFAULT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SurveyAnswerId`),
  KEY `pk_SurveyAnswers_SurveyQuestions` (`SurveyQuestionId`),
  CONSTRAINT `pk_SurveyAnswers_SurveyQuestions` FOREIGN KEY (`SurveyQuestionId`) REFERENCES `SurveyQuestions` (`SurveyQuestionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `SurveyQuestions` */

DROP TABLE IF EXISTS `SurveyQuestions`;

CREATE TABLE `SurveyQuestions` (
  `SurveyQuestionId` int(11) NOT NULL AUTO_INCREMENT,
  `CampaignSurveyId` int(11) NOT NULL,
  `Question` varchar(255) NOT NULL,
  `StaffNote` varchar(255) DEFAULT NULL,
  `IsMultiAnswer` tinyint(1) DEFAULT '0',
  `HasOtherAnswer` tinyint(1) DEFAULT '0',
  `OtherAnswerTypeInput` enum('text','email','url','date','number','digits') DEFAULT 'text' COMMENT '{"enum":[''text'',''email'',''url'',''date'',''number'',''digits'']}',
  `OtherAnswerMinLength` smallint(6) DEFAULT '255' COMMENT 'IsAnwserOther must is 1',
  `OtherAnswerMaxLength` smallint(6) DEFAULT NULL COMMENT 'IsAnwserOther must is 1',
  `OtherAnswerMessageError` varchar(255) DEFAULT NULL,
  `PositionQuestion` smallint(6) DEFAULT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SurveyQuestionId`),
  KEY `CampaignSurveyId` (`CampaignSurveyId`),
  CONSTRAINT `SurveyQuestions_ibfk_1` FOREIGN KEY (`CampaignSurveyId`) REFERENCES `CampaignSurvey` (`CampaignSurveyId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `SurveyResults` */

DROP TABLE IF EXISTS `SurveyResults`;

CREATE TABLE `SurveyResults` (
  `SurveyResultId` int(11) NOT NULL AUTO_INCREMENT,
  `CampaignSurveyId` int(11) NOT NULL,
  `SurveyQuestionId` int(11) NOT NULL,
  `SurveyAnswerId` int(11) DEFAULT NULL,
  `UserId` int(11) NOT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `OtherResult` varchar(255) DEFAULT NULL,
  `IpNumber` int(11) DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SurveyResultId`),
  KEY `CampaignSurveyId` (`CampaignSurveyId`),
  KEY `SurveyQuestionId` (`SurveyQuestionId`),
  KEY `SurveyAnswerId` (`SurveyAnswerId`),
  CONSTRAINT `SurveyResults_ibfk_1` FOREIGN KEY (`CampaignSurveyId`) REFERENCES `CampaignSurvey` (`CampaignSurveyId`),
  CONSTRAINT `SurveyResults_ibfk_2` FOREIGN KEY (`SurveyQuestionId`) REFERENCES `SurveyQuestions` (`SurveyQuestionId`),
  CONSTRAINT `SurveyResults_ibfk_3` FOREIGN KEY (`SurveyAnswerId`) REFERENCES `SurveyAnswers` (`SurveyAnswerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `SystemConfigs` */

DROP TABLE IF EXISTS `SystemConfigs`;

CREATE TABLE `SystemConfigs` (
  `SystemConfigId` int(11) NOT NULL AUTO_INCREMENT,
  `SystemName` varchar(50) NOT NULL,
  `SystemNameKey` varchar(50) NOT NULL,
  `Config` varchar(255) NOT NULL,
  `CanUpdateName` tinyint(1) NOT NULL,
  PRIMARY KEY (`SystemConfigId`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

/*Table structure for table `SystemFiles` */

DROP TABLE IF EXISTS `SystemFiles`;

CREATE TABLE `SystemFiles` (
  `SystemFileId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Sha1Hash` varchar(40) NOT NULL,
  `FileName` varchar(50) NOT NULL,
  `FileSize` int(10) unsigned DEFAULT NULL,
  `Extension` varchar(5) NOT NULL,
  `Mimetype` varchar(50) NOT NULL,
  PRIMARY KEY (`SystemFileId`)
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
) ENGINE=InnoDB AUTO_INCREMENT=1603 DEFAULT CHARSET=latin1;

/*Table structure for table `UserPostalAddresses` */

DROP TABLE IF EXISTS `UserPostalAddresses`;

CREATE TABLE `UserPostalAddresses` (
  `UserPostalAddressId` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` int(11) DEFAULT NULL,
  `Firstname` varchar(30) NOT NULL,
  `Lastname` varchar(30) NOT NULL,
  `PhoneNumber` varchar(14) NOT NULL,
  `Address1` varchar(255) NOT NULL,
  `Address2` varchar(255) NOT NULL,
  `Suburb` varchar(20) NOT NULL,
  `State` varchar(20) NOT NULL,
  `Postcode` char(4) NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `IpNumber` int(11) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserPostalAddressId`),
  KEY `UserPostalAddresses_UserId_Users_FK` (`UserId`),
  KEY `UserPostalAddresses_CityId_Country_Cities_FK` (`Suburb`),
  KEY `UserPostalAddresses_StateId_Country_States_FK` (`State`),
  CONSTRAINT `UserPostalAddresses_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `UserRelationships` */

DROP TABLE IF EXISTS `UserRelationships`;

CREATE TABLE `UserRelationships` (
  `UserRelationshipId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserId` int(11) DEFAULT NULL,
  `EmailFriendshipId` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`UserRelationshipId`),
  UNIQUE KEY `UserId_EmailFriendshipId` (`UserId`,`EmailFriendshipId`),
  KEY `UserRelationships_EmailFrinedship_FK` (`EmailFriendshipId`),
  KEY `UserRelationships_Users_FK` (`UserId`) USING BTREE,
  CONSTRAINT `UserRelationships_EmailFrinedship_FK` FOREIGN KEY (`EmailFriendshipId`) REFERENCES `EmailFriendships` (`EmailFriendshipId`),
  CONSTRAINT `UserRelationships_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `UserResetPasswords` */

DROP TABLE IF EXISTS `UserResetPasswords`;

CREATE TABLE `UserResetPasswords` (
  `UserResetPasswordId` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(100) NOT NULL,
  `SecretKey` varchar(100) NOT NULL,
  `IsUsed` tinyint(1) NOT NULL DEFAULT '0',
  `DateExpired` datetime NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserResetPasswordId`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

/*Table structure for table `UserSubscriptionCities` */

DROP TABLE IF EXISTS `UserSubscriptionCities`;

CREATE TABLE `UserSubscriptionCities` (
  `UserId` int(11) NOT NULL,
  `DealCityId` int(11) NOT NULL,
  PRIMARY KEY (`UserId`,`DealCityId`),
  KEY `UserSubscriptionCities_CityId_Cities_FK` (`DealCityId`),
  CONSTRAINT `UserSubscriptionCities_DealCityId_DealCities_FK` FOREIGN KEY (`DealCityId`) REFERENCES `DealCities` (`DealCityId`),
  CONSTRAINT `UserSubscriptionCities_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `UserTracking` */

DROP TABLE IF EXISTS `UserTracking`;

CREATE TABLE `UserTracking` (
  `UserId` int(11) NOT NULL AUTO_INCREMENT,
  `RegisteredSessionId` varchar(32) NOT NULL,
  `ReferrerUrl` varchar(255) NOT NULL,
  `LandingUrl` varchar(255) NOT NULL,
  `ReferredId` int(11) DEFAULT '0',
  `LastLogin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserId`),
  CONSTRAINT `UserTracking_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

/*Table structure for table `Users` */

DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
  `UserId` int(11) NOT NULL AUTO_INCREMENT,
  `Firstname` varchar(50) NOT NULL,
  `Lastname` varchar(50) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Password` char(40) NOT NULL,
  `Salt` char(4) NOT NULL,
  `Gender` enum('Male','Female','Other') NOT NULL,
  `Postcode` char(4) NOT NULL,
  `State` varchar(20) DEFAULT NULL,
  `ReferrerId` int(11) DEFAULT NULL,
  `BannedReason` varchar(255) NOT NULL,
  `IpNumber` int(11) NOT NULL,
  `DateJoined` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IsReceiveSubscribe` tinyint(1) DEFAULT '1',
  `HaveAcceptedVoucherNotification` tinyint(1) NOT NULL DEFAULT '0',
  `IsDisabled` tinyint(1) NOT NULL DEFAULT '0',
  `IsUserFacebook` tinyint(1) DEFAULT '0',
  `HasNotChangedPasswordOfFacebook` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`UserId`),
  KEY `Users_ReferrerUserId_UserId_FK` (`ReferrerId`),
  CONSTRAINT `Users_ReferrerId_UserId_FK` FOREIGN KEY (`ReferrerId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

/*Table structure for table `VoucherPool` */

DROP TABLE IF EXISTS `VoucherPool`;

CREATE TABLE `VoucherPool` (
  `VoucherPoolId` int(11) NOT NULL AUTO_INCREMENT,
  `VoucherParentId` int(11) NOT NULL,
  `VoucherNumber` bigint(12) NOT NULL,
  `DealId` int(11) NOT NULL,
  `DealItemId` int(11) NOT NULL,
  `ContractId` int(11) NOT NULL,
  `ContractItemId` int(11) NOT NULL,
  `OrderContractItemId` int(11) NOT NULL,
  `MasterKey` char(40) NOT NULL,
  `BuyKey` char(40) NOT NULL,
  `IsBought` tinyint(1) NOT NULL,
  `DateBought` datetime DEFAULT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`VoucherPoolId`),
  UNIQUE KEY `VoucherPool_BuyKey_Unique` (`BuyKey`),
  UNIQUE KEY `VoucherPool_VoucherNumber_Unique` (`VoucherNumber`),
  KEY `VoucherPool_ContractId_Contracts_FK` (`ContractId`),
  KEY `VoucherPool_ContractItemId_ContractItems_FK` (`ContractItemId`),
  KEY `VoucherPool_DealId_Deals_FK` (`DealId`),
  KEY `VoucherPool_DealItemId_DealItems_FK` (`DealItemId`),
  KEY `VoucherPool_OrderContractItemId_OrderContractItems_FK` (`OrderContractItemId`),
  KEY `VoucherPool_VoucherParentId_Vouchers_FK` (`VoucherParentId`),
  CONSTRAINT `VoucherPool_ContractId_Contracts_FK` FOREIGN KEY (`ContractId`) REFERENCES `Contracts` (`ContractId`),
  CONSTRAINT `VoucherPool_ContractItemId_ContractItems_FK` FOREIGN KEY (`ContractItemId`) REFERENCES `ContractItems` (`ContractItemId`),
  CONSTRAINT `VoucherPool_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `VoucherPool_DealItemId_DealItems_FK` FOREIGN KEY (`DealItemId`) REFERENCES `DealItems` (`DealItemId`),
  CONSTRAINT `VoucherPool_OrderContractItemId_OrderContractItems_FK` FOREIGN KEY (`OrderContractItemId`) REFERENCES `OrderContractItems` (`OrderContractItemId`),
  CONSTRAINT `VoucherPool_VoucherParentId_Vouchers_FK` FOREIGN KEY (`VoucherParentId`) REFERENCES `Vouchers` (`VoucherId`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

/*Table structure for table `VoucherRevenueSummaryDaily` */

DROP TABLE IF EXISTS `VoucherRevenueSummaryDaily`;

CREATE TABLE `VoucherRevenueSummaryDaily` (
  `VoucherRevenueSummaryDailyId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `DealItemId` int(11) NOT NULL,
  `TotalVoucherSold` int(11) NOT NULL,
  `TotalVoucherRefunded` int(11) DEFAULT NULL,
  `Revenue` int(11) NOT NULL,
  `TotalRefunded` int(11) NOT NULL DEFAULT '0',
  `DateSummary` date DEFAULT NULL,
  `DateCreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`VoucherRevenueSummaryDailyId`),
  UNIQUE KEY `ContractItemId` (`DateSummary`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20162 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

/*Table structure for table `VoucherTemplates` */

DROP TABLE IF EXISTS `VoucherTemplates`;

CREATE TABLE `VoucherTemplates` (
  `VoucherTemplateId` int(11) NOT NULL AUTO_INCREMENT,
  `ContractItemId` int(11) NOT NULL,
  `Template` longtext NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`VoucherTemplateId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Table structure for table `Vouchers` */

DROP TABLE IF EXISTS `Vouchers`;

CREATE TABLE `Vouchers` (
  `VoucherId` int(11) NOT NULL AUTO_INCREMENT,
  `DealId` int(11) NOT NULL,
  `OrderId` int(11) NOT NULL,
  `DealItemId` int(11) NOT NULL,
  `ContractId` int(11) NOT NULL,
  `ContractItemId` int(11) NOT NULL,
  `OrderContractItemId` int(11) NOT NULL,
  `UserId` int(11) NOT NULL,
  `VoucherNumber` bigint(14) NOT NULL COMMENT 'Last 2 digits we don''t used it',
  `PriceRetail` int(11) NOT NULL,
  `PriceSell` int(11) NOT NULL,
  `AmountRefunded` int(11) NOT NULL,
  `IsBusinessUsed` tinyint(1) DEFAULT '0',
  `IsUsed` tinyint(1) NOT NULL DEFAULT '0',
  `IsSentAsGift` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `IsAdditional` tinyint(1) NOT NULL,
  `IsCancelled` tinyint(1) NOT NULL,
  `IsFullRefunded` tinyint(1) NOT NULL,
  `SalePaymentMonthlyId` int(11) DEFAULT NULL,
  `AdditionalBusinessPaymentId` int(11) DEFAULT NULL,
  `InorgeFromPayment` tinyint(1) NOT NULL DEFAULT '0',
  `BusinessNoted` varchar(255) DEFAULT NULL,
  `DateRedeemable` date NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`VoucherId`),
  KEY `Vouchers_DealId_Deals_FK` (`DealId`),
  KEY `Vouchers_DealItemId_DealItems_FK` (`DealItemId`),
  KEY `Vouchers_ContractId_Contracts_FK` (`ContractId`),
  KEY `Vouchers_ContractItemId_ContractItems_FK` (`ContractItemId`),
  KEY `Vouchers_OrderDealItemId_OrderDealItems_FK` (`OrderContractItemId`),
  KEY `Vouchers_UserId_Users_FK` (`UserId`),
  KEY `Vouchers_OrderId_Orders_FK` (`OrderId`),
  KEY `Vouchers_SalePaymentMonthlyId_SalePaymentMonthly_FK` (`SalePaymentMonthlyId`),
  CONSTRAINT `Vouchers_ContractId_Contracts_FK` FOREIGN KEY (`ContractId`) REFERENCES `Contracts` (`ContractId`),
  CONSTRAINT `Vouchers_ContractItemId_ContractItems_FK` FOREIGN KEY (`ContractItemId`) REFERENCES `ContractItems` (`ContractItemId`),
  CONSTRAINT `Vouchers_DealId_Deals_FK` FOREIGN KEY (`DealId`) REFERENCES `Deals` (`DealId`),
  CONSTRAINT `Vouchers_DealItemId_DealItems_FK` FOREIGN KEY (`DealItemId`) REFERENCES `DealItems` (`DealItemId`),
  CONSTRAINT `Vouchers_OrderContractItemId_OrderContractItems_FK` FOREIGN KEY (`OrderContractItemId`) REFERENCES `OrderContractItems` (`OrderContractItemId`),
  CONSTRAINT `Vouchers_OrderId_Orders_FK` FOREIGN KEY (`OrderId`) REFERENCES `Orders` (`OrderId`),
  CONSTRAINT `Vouchers_SalePaymentMonthlyId_SalePaymentMonthly_FK` FOREIGN KEY (`SalePaymentMonthlyId`) REFERENCES `SalePaymentMonthlyRemove` (`SalePaymentMonthlyId`),
  CONSTRAINT `Vouchers_UserId_Users_FK` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=latin1;

/*Table structure for table `WarriorTransactionLogs` */

DROP TABLE IF EXISTS `WarriorTransactionLogs`;

CREATE TABLE `WarriorTransactionLogs` (
  `WarriorTransactionLogId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderId` int(11) DEFAULT NULL,
  `CardName` varchar(100) NOT NULL,
  `CardType` varchar(20) NOT NULL,
  `CardNumberSuffix` char(4) NOT NULL,
  `WarriorTransactionId` varchar(100) DEFAULT NULL,
  `Method` varchar(20) NOT NULL,
  `Amount` int(11) NOT NULL,
  `PostParams` text NOT NULL COMMENT 'serialize string',
  `Responses` text NOT NULL COMMENT 'serialize string',
  `ResponseMessage` varchar(255) NOT NULL,
  `IpNumber` int(11) NOT NULL,
  `IsApproved` tinyint(1) NOT NULL,
  `DateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`WarriorTransactionLogId`),
  KEY `WarriorTransactionLogs_OrderId_Orders_FK` (`OrderId`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;

/*Table structure for table `deal_users` */

DROP TABLE IF EXISTS `deal_users`;

CREATE TABLE `deal_users` (
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `city_id` int(10) unsigned NOT NULL,
  `create_date` varchar(25) NOT NULL,
  `user_status` varchar(40) NOT NULL,
  `mailout_status` varchar(40) NOT NULL,
  `promotion_id` int(10) unsigned DEFAULT NULL,
  `referer_user_id` int(10) unsigned DEFAULT NULL,
  `refer_link` varchar(50) NOT NULL,
  `visible` tinyint(4) NOT NULL,
  `post_code` char(4) DEFAULT NULL,
  `dmg_ymid` char(32) DEFAULT NULL,
  `temp` int(11) DEFAULT NULL,
  `zp_perm_usercol` varchar(45) DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `times_login` int(11) DEFAULT '0',
  `is_sync_with_inxmail` tinyint(1) DEFAULT '0',
  `user_notes` varchar(500) DEFAULT NULL,
  `is_post_code_promotion_accepted` tinyint(1) DEFAULT '0',
  `confirmed_post_code_date` date DEFAULT NULL,
  `have_join_mytable` tinyint(1) DEFAULT NULL,
  `NumberOfOrders` bigint(21) DEFAULT NULL,
  `NumberOfChildren` bigint(21) DEFAULT NULL,
  `City` varchar(255) DEFAULT NULL,
  `IsUsed` varchar(1) CHARACTER SET utf8 NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
