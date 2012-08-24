<?php

defined('APPLICATION_ENV')
        || define("APPLICATION_ENV", $_SERVER['argv'][1]);

defined('ROOT_PATH')
    || define('ROOT_PATH', realpath(dirname(__FILE__) . '/../../../'));
    
defined('APPLICATION_PATH')
        || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../../../application'));

//echo realpath(dirname(__FILE__));die;

require_once APPLICATION_PATH . '/configs/constants.php';
//echo APPLICATION_PATH;die;
// Ensure library/ is on include_path
set_include_path(implode(PATH_SEPARATOR, array(
    realpath(APPLICATION_PATH . '/../library'),
    ZF_DEBUG_LIBRARY_PATH,
    get_include_path(),
)));


/** Zend_Application */
require_once 'Zend/Application.php';

// Create application, bootstrap, and run
$application = new Zend_Application(
    APPLICATION_ENV,
    APPLICATION_PATH . '/configs/application.ini'
);
Zend_Db_Table::setDefaultAdapter(getDb());

///////////////////////////////////////////////////////////////////////////////

echo "start cron\n";

$vouchers = getVouchersToSendExpirationNotificationInMonth();

sendMails($vouchers);

echo "end cron\n";


function sendMails($vouchers){
    

    require_once  APPLICATION_PATH . '/controllers/helpers/SendMail.php';
    $helperSendMail = new Zend_Controller_Action_Helper_SendMail();
    
    $emailTemplateModel = new Application_Model_Email_EmailTemplates();
    $emailTemplate = $emailTemplateModel->getEmailTemplate(Application_Model_Email_EmailTemplates::EMAIL_EXPIRATION_NOTIFICATION_ONE_MONTH);
    
    
    foreach($vouchers as $voucher) {
        Zend_Debug::dump($voucher);
        $searchKeys = array(
            "%%LASTNAME%%",
            "%%FIRSTNAME%%",
            "%%TITLELONG%%",
            "%%VOUCHER_NUMBER%%",
            "%%IS_SENT_AS_GIFT%%",
        
        );
        $replaceValues = array(
            $voucher['Lastname'],
            $voucher['Firstname'],
            $voucher['TitleLong'],
            $voucher['VoucherNumber'],
            $voucher['IsSentAsGift'],
        );

        $body = str_replace($searchKeys,$replaceValues, $emailTemplate->Body);
        $subject = str_replace($searchKeys,$replaceValues, $emailTemplate->Subject);

        $dataMail = array(
            "EmailTo"        => $voucher['Email'],
            "EmailSubject"   => $subject,
            "EmailBody"      => $body,
            "Priority"       => 5,
        );

        if (!$helperSendMail->direct($dataMail)) {
            return 0;
        }
    
    }
    return 1;
}

function getVouchersToSendExpirationNotificationInMonth(){
    $db = getDb();
    $columns = array(
        'Vouchers.VoucherId',
        'Vouchers.VoucherNumber',
        'Deals.DateExpired',
        'Deals.TitleLong',
        'IF(Vouchers.IsSentAsGift = 0, Users.Email, GiftVouchers.RecipientEmail) AS Email',
        'IF(Vouchers.IsSentAsGift = 0, Users.Firstname, RUsers.Firstname) AS Firstname',
        'IF(Vouchers.IsSentAsGift = 0, Users.Lastname, RUsers.Lastname) AS Lastname',
        'Vouchers.IsSentAsGift'
     );
    $columns = implode(', ', $columns);
    $select = "SELECT $columns FROM Vouchers 
               JOIN Deals 
                 ON Deals.DealId = Vouchers.DealId
               JOIN Users 
                 ON Vouchers.UserId = Users.UserId
                   AND Users.IsDisabled = 0
               LEFT JOIN GiftVouchers
                 ON Vouchers.VoucherId = GiftVouchers.VoucherId 
                   AND GiftVouchers.IsCancelled = 0
                   AND GiftVouchers.IsUsed = 0
               LEFT JOIN Users as RUsers
                 ON GiftVouchers.RecipientUserId = RUsers.UserId
                   AND RUsers.IsDisabled = 0
               WHERE (Vouchers.IsUsed = 0 OR (Vouchers.IsSentAsGift = 1 AND GiftVouchers.IsUsed = 0))
                 AND Vouchers.IsCancelled = 0
                 AND CurDate() = Deals.DateExpired + INTERVAL 1 MONTH
               ";
//    die($select);
    $vouchers = $db->fetchAll($select);
//    Zend_Debug::dump($vouchers);die;
    return $vouchers;
    
    
}


function getDb(){
    
    $config = new Zend_Config_Ini(APPLICATION_PATH . '/configs/application.ini', APPLICATION_ENV);
//    Zend_Debug::dump($config->toArray());die;
    $db = new Zend_Db_Adapter_Pdo_Mysql(array(
                'host' => $config->resources->db->params->host,
                'username' => $config->resources->db->params->username,
                'password' => $config->resources->db->params->password,
                'dbname' => $config->resources->db->params->dbname
            ));
//    Zend_Debug::dump($db);die;
    return $db;
} 
