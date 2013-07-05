<?php
/**
 * Application Plugin set global authentication
 *
 */
class Application_Plugin_Initializer extends Zend_Controller_Plugin_Abstract
{
    public function routeStartup(Zend_Controller_Request_Abstract $request)
    {

    }

    public function routeShutdown(Zend_Controller_Request_Abstract $request)
    {

    }

    public function dispatchLoopStartup(
        Zend_Controller_Request_Abstract $request)
    {


    }

    public function preDispatch(Zend_Controller_Request_Abstract $request)
    {
        /**
         *  Autoload languages
         */
        $filename = $this->getRequest()->getControllerName();
        $modelSysLanguagePage = new Application_Model_Crawler_SystemLanguagePage();
        $languagues = $modelSysLanguagePage->fetchAll("TableNames = '$filename' AND Languages = 'en'");
        $arrLanguage = array();
        $arrHintLanguage = array();
        if ($languagues->count() > 0) {
            foreach ($languagues as $v) {
                $arrLanguage[$v['Fields']] = $v['ValueFields'];
                $arrHintLanguage[$v['Fields']] = array($v['ValueFields'],$v['Hints']);
            }
            Zend_Registry::set("language", $arrHintLanguage);
            $translate = new Zend_Translate("Array", $arrLanguage, "en_US");
            Zend_Registry::set("translate", $translate);
        } else {
            $arrLanguage = array(
                'TableNames' => '',
                'Fields' => '',
                'Value' => '',
                'Language' => '',
            );
            Zend_Registry::set("language", $arrHintLanguage);
            $translate = new Zend_Translate("Array", $arrLanguage, "en_US");
            Zend_Registry::set("translate", $translate);

        }
    }

    public function postDispatch(Zend_Controller_Request_Abstract $request)
    {

    }

    public function dispatchLoopShutdown()
    {
    }
}
