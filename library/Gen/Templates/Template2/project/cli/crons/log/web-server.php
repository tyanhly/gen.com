<?php

defined('APPLICATION_ENV')
        || define("APPLICATION_ENV", $_SERVER["argv"][1]);

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


///////////////////////////////////////////////////////////////////////////////

echo "start cron\n";

$time = date('D M d H:i:.. o');
//die($date);

$logFiles = array(
    'error' => '/var/log/apache2/error.log'
);

$command = "tail {$logFiles['error']} -c 10000000 | grep '$time'";
//die($command);
$records = `$command`;
$records = explode("\n", $records);

array_pop($records);


//Zend_Debug::dump($records);die;

$webServerErrorsModel = new Application_Model_DbTable_Log_WebServerErrors();
$webServerErrorsModel->insertData($records);


echo "end cron\n";

