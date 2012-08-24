<?php
count($_SERVER['argv']) == 3 or die("\nPlease insert params: logAccessId APPLICATION_ENV\n");

$accessLogFile = $_SERVER["argv"][1];

defined('APPLICATION_ENV')
        || define("APPLICATION_ENV", $_SERVER["argv"][2]);

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

$data = file_get_contents($accessLogFile);
//echo $data;
//die;


$modelLogAccesses = new Application_Model_DbTable_Log_LogAccesses();

//Zend_Debug::dump(unserialize($data));die;\
$t = $modelLogAccesses->fetchRow(22);
//Zend_Debug::dump($t);die;
$logAccessId = $modelLogAccesses->add(unserialize($data));

//echo $logAccessId;die;

if($logAccessId){
    echo `rm -f {$accessLogFile}`;
    echo 'Insert successfully - logAccessId = ' . $logAccessId;
    hookLogErrors($logAccessId);
    hookLogSQLQueries($logAccessId);
    
}



echo "end cron\n";


function hookLogErrors($logAccessId){
        $cmd = 'php ' . APPLICATION_PATH . '/../cli/hooks/log-errors.php ' . $logAccessId . ' ' . APPLICATION_ENV . ' > /dev/null 2> /dev/null &';

        $result = shell_exec($cmd);
    }

function hookLogSQLQueries($logAccessId){
        $cmd = 'php ' . APPLICATION_PATH . '/../cli/hooks/log-sql-queries.php ' . $logAccessId . ' ' . APPLICATION_ENV . ' > /dev/null 2> /dev/null &';
//        die($cmd);
        $result = shell_exec($cmd);
}