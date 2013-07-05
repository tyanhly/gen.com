<?php
/**
 * Controller Index
 *
 * @author      code generate
 * @package   	KiSS
 * @version     $Id$
 * @todo remove
 */
class ProjectInfosController extends Zend_Controller_Action
{
    /**
     * (non-PHPdoc)
     * @see Zend_Controller_Action::init()
     */
    public function init () {}
    /**
     * Home page - Main Panel
     *
     */
    public function indexAction() {
        
    }
    
    public function phpinfoAction(){
        phpinfo();die;
    }



}
