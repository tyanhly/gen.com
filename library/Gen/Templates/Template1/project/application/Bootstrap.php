<?php

class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
    
    public function _initLoadViewResource() {
        
        $this->bootstrap('view');
        $view = $this->getResource('view');

        $this->_setNavigation($view);
    }
//
    public function _setNavigation($view){

         $config = new Zend_Config_Ini(APPLICATION_PATH.'/layouts/navigation.ini', 'run');
         $navigation = new Zend_Navigation($config->navigation);
         $view = $view->navigation($navigation);

        
    }
}

