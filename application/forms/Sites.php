<?php
/**
 * Form Application_Form_Sites
 *  
 * @version $Id$
 */
class Application_Form_Sites extends Zend_Form 
{
    /**
     * Variable table name
     */
    private $_tableName = "Sites";
    
    /**
     * @author code generate
     * @return mixed
     */    
    public function __construct($option = array())
    {
        

        /** Textbox for IdentifyValue */
        $this->addElement('text', 'Site', array('label' => 'Site')); 
        $this->getElement('Site')
        
             ->addValidator("stringLength", true, array(0,100,'messages'=>array(
                Zend_Validate_StringLength::TOO_SHORT=>'Identify Value must be at least %min% characters.',
                Zend_Validate_StringLength::TOO_LONG=>'Identify Value must be shorter than %max% characters.')))
             ->addFilter('StringTrim')
             ->setDecorators(array('ViewHelper'));


        /** Textbox for CredentialField */
        $this->addElement('text', 'DatabaseHost', array('label' => 'DatabaseHost'));
         
        $this->getElement('DatabaseHost')
             ->addValidator("stringLength", true, array(0,100,'messages'=>array(
                Zend_Validate_StringLength::TOO_SHORT=>'Credential Field must be at least %min% characters.',
                Zend_Validate_StringLength::TOO_LONG=>'Credential Field must be shorter than %max% characters.')))
             ->addFilter('StringTrim')
             ->setDecorators(array('ViewHelper'));

        /** Textbox for CredentialField */
        $this->addElement('text', 'DatabaseName', array('label' => 'DatabaseName'));
         
        $this->getElement('DatabaseName')        
             ->addValidator("stringLength", true, array(0,100,'messages'=>array(
                Zend_Validate_StringLength::TOO_SHORT=>'Credential Field must be at least %min% characters.',
                Zend_Validate_StringLength::TOO_LONG=>'Credential Field must be shorter than %max% characters.')))
             ->addFilter('StringTrim')
             ->setDecorators(array('ViewHelper'));


        /** Textbox for CredentialValue */
        $this->addElement('text', 'DatabaseUsername', array('label' => 'DatabaseUsername'));
         
        $this->getElement('DatabaseUsername')        
             ->addValidator("stringLength", true, array(0,100,'messages'=>array(
                Zend_Validate_StringLength::TOO_SHORT=>'Credential Value must be at least %min% characters.',
                Zend_Validate_StringLength::TOO_LONG=>'Credential Value must be shorter than %max% characters.')))
             ->addFilter('StringTrim')
             ->setDecorators(array('ViewHelper'));


        /** Textbox for SiteUrl */
        $this->addElement('password', 'DatabasePassword', array('label' => 'DatabasePassword'));
         
        $this->getElement('DatabasePassword')        
             ->addValidator("stringLength", true, array(0,100,'messages'=>array(
                Zend_Validate_StringLength::TOO_SHORT=>'Site Url must be at least %min% characters.',
                Zend_Validate_StringLength::TOO_LONG=>'Site Url must be shorter than %max% characters.')))
             ->addFilter('StringTrim')
             ->setDecorators(array('ViewHelper'));
             
        
        /** Textbox for CredentialField */
        $this->addElement('text', 'Schema', array('label' => 'Schema'));
         
        $this->getElement('Schema')        
             ->addValidator("stringLength", true, array(0,100,'messages'=>array(
                Zend_Validate_StringLength::TOO_SHORT=>'Credential Field must be at least %min% characters.',
                Zend_Validate_StringLength::TOO_LONG=>'Credential Field must be shorter than %max% characters.')))
             ->addFilter('StringTrim')
             ->setValue('Core')
             ->setDecorators(array('ViewHelper'));

        /*button*/
        $this->addElement('Submit', 'Submit', array('ignore' => true));        
        $this->getElement('Submit')->setAttrib('class', 'btn blue')->setDecorators(array('ViewHelper'));

    }
}