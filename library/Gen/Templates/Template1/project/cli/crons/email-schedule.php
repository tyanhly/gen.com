<?php

defined('APPLICATION_ENV')
        || define("APPLICATION_ENV", $_SERVER['argv'][1]);

defined('ROOT_PATH')
    || define('ROOT_PATH', realpath(dirname(__FILE__) . '/../../'));
    
defined('APPLICATION_PATH')
        || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../../application'));

//echo realpath(dirname(__FILE__));die;
//echo APPLICATION_PATH;die;
require_once APPLICATION_PATH . '/configs/constants.php';

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
switch (APPLICATION_ENV) {
    case 'development':
        define('FRONTEND_LINK', 'http://dev.tung.ly.hippon.com.au:8888');
        
        define('EMAIL_SUBJECT', 'DAILY SEND MAIL - DEVELOPMENT');
    break;
    case 'staging':   
        define('FRONTEND_LINK', 'http://staging.hippon.com.au');
        define('EMAIL_SUBJECT', 'DAILY SEND MAIL - STAGING');
    break;
    default:
        define('FRONTEND_LINK', 'http://hippon.com.au');
        define('EMAIL_SUBJECT', 'DAILY SEND MAIL - PRODUCTION');
    break;
}



echo "start cron\n";

$schedules = getEmailSchedules();
$mailChimp = new Mail_MailChimp_Function();

foreach($schedules as $schedule){
    echo '================Start======================';
    //update status sending
    $data['EmailScheduleId'] = $schedule['EmailScheduleId']; 
    $data['Status'] = 'SENDING';    
    updateSchedule($data);
    
    // send campaign
    $mailChimp->setEmailListByCity(strtolower($schedule['DealCityName']));
    $bodyHtml = file_get_contents(FRONTEND_LINK . 
                                  '/email/schedule/id/' .
                                  $schedule['EmailScheduleId'] . 
                                  '?kiss=lovelyday');
//    die($bodyHtml);
    $result = $mailChimp->createCampaign(
        EMAIL_SUBJECT, 
        EMAIL_SUPPORT_TICKET, 
        SUBJECT_SUPPORT_TICKET, 
        $bodyHtml);
    
    Zend_Debug::dump($schedule);
    Zend_Debug::dump($result);
    
    if($result['status']){
        $r = $mailChimp->scheduleCampaign($schedule['ScheduleTime'], $result['message']);
        Zend_Debug::dump($r);
        if($r['status']){
            $data['Status'] = 'COMPLETED';
        }else{
            $data['Status'] = 'ERROR';
        }
        
    }else{
        $data['Status'] = 'ERROR';
    }
    
    //update schedule
    updateSchedule($data);
    echo '================End======================';
}


echo "end cron\n";

function updateSchedule($data){
    $db = getDb();
    $where = $db->quoteInto('EmailScheduleId = ?', $data['EmailScheduleId']);
    return $db->update('EmailSchedules', $data, $where);
}

function getEmailSchedules(){
    $db = getDb();
    $columns = array(
        'EmailSchedules.EmailScheduleId',
        'DATE_SUB(DATE_ADD(EmailSchedules.ScheduleTime, 
                    interval DealCities.TimezoneOffsetMinutes MINUTE), 
           INTERVAL 10 HOUR) AS ScheduleTime',
        'EmailSchedules.DealCityId',
        'DealCities.DealCityName',
        'CustomEmailSubject',
        'CustomEmailBody',
    );
    $columns = implode(', ', $columns);
    $select = "SELECT $columns FROM EmailSchedules 
               JOIN DealCities 
                 ON DealCities.DealCityId = EmailSchedules.DealCityId
               WHERE
                 DATE(EmailSchedules.ScheduleTime) = CURDATE()
                 AND EmailSchedules.Status = 'PENDING'
               GROUP BY EmailSchedules.DealCityId
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













