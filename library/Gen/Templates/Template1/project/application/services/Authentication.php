<?php


/**
 * Enter description here ...
 * @author tyanhly
 *
 */
class Application_Service_Authentication
{

    protected $_authAdapter;

    protected $_userModel;

    protected $_auth;

    public function __construct(Application_Model_User_Users $userModel = null)
    {
        $this->_userModel = null === $userModel ? new Application_Model_User_Users() : $userModel;
    }

    /**
     * @author Tung Ly
     * @param unknown_type $credentials
     * @return boolean
     */
    public function authenticate($credentials)
    {
//        Zend_Debug::dump($credentials);die;
        $adapter = $this->getAuthAdapter($credentials);
//        Zend_Debug::dump($adapter);die;
        $auth    = $this->getAuth();


        $result  = $auth->authenticate($adapter);

        if (!$result->isValid()) {
            return false;
        }

        $user = $this->_userModel->getUserByEmail($credentials['Email']);
        $auth->getStorage()->write($user);

        return true;
    }

    /**
     * Enter description here ...
     * @param unknown_type $userId
     * @param unknown_type $token
     * @return boolean
     * @author Tung Ly
     */
    public function authenticateByLink($userId, $token){

        $time = Zend_Date::now()->toString('yyyy-MM-dd hh');

        if($token && $userId && sha1($time . $userId) == $token){

            $userTable = new Application_Model_DbTable_Core_Users();

            $user = $userTable->find($userId)->current();
            if($user){
                $auth    = $this->getAuth();
                $auth->getStorage()->write($user);
                return true;
            }
        }
        return false;
    }
    
	/**
     * Enter description here ...
     * @param unknown_type $userId
     * @param unknown_type $token
     * @return boolean
     * @author Tung Ly
     */
    public function authenticateByUser($user){
        $auth    = $this->getAuth();
        return $auth->getStorage()->write($user);
    }

    /**
     * @author Tung Ly
     * @return Zend_Auth
     */
    public function getAuth()
    {
        if (null === $this->_auth) {
            $this->_auth = Zend_Auth::getInstance();
        }
        return $this->_auth;
    }

    /**
     * @author Tung Ly
     * @return Ambigous <mixed, NULL>|boolean
     */
    public function getIdentity()
    {
        $auth = $this->getAuth();
        if ($auth->hasIdentity()) {
            return $auth->getIdentity();
        }
        return false;
    }

    /**
     * Clear any authentication data
     */
    public function clear()
    {

        $this->getAuth()->clearIdentity();
    }

    /**
     * Set the auth adpater.
     *
     * @param Zend_Auth_Adapter_Interface $adapter
     */
    public function setAuthAdapter(Zend_Auth_Adapter_Interface $adapter)
    {
        $this->_authAdapter = $adapter;
    }

    /**
     * Get and configure the auth adapter
     *
     * @param  array $value Array of user credentials
     * @return Zend_Auth_Adapter_DbTable
     */
    public function getAuthAdapter($values)
    {
//        Zend_Debug::dump(Zend_Db_Table_Abstract::getDefaultAdapter());die;
//        Zend_Debug::dump($values);die;
        $model = new Application_Model_User_Users();
        $user = $model->getUserByEmail($values['Email']);

        if (null === $this->_authAdapter) {
            $authAdapter = new Zend_Auth_Adapter_DbTable(
                Zend_Db_Table_Abstract::getDefaultAdapter(),
                'Users',
                'Email',
                'Password',
                '?'
            );

            $this->setAuthAdapter($authAdapter);

            $this->_authAdapter->setIdentity($values['Email']);
            if(count($user)){
                $this->_authAdapter->setCredential(sha1($values['Password'].$user->Salt));
            }else {
                $this->_authAdapter->setCredential(sha1($values['Password']));
            }
        }
        return $this->_authAdapter;
    }
}
