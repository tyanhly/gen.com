<?php

class Application_Service_Acl extends Zend_Controller_Plugin_Abstract
{
    protected $_acl;
    protected $_userPrivilagesModel;
    protected $_resourcesModel;
    protected $_auth;

    public function __construct() {
        $this->_userPrivilagesModel = new Application_Model_Permission_UserPrivilages();
        $this->_resourcesModel      = new Application_Model_Permission_Resources();
        $this->_auth                = Zend_Auth::getInstance()->getIdentity();

        $this->_acl = new Zend_Acl();
        $this->_setRole('permission');

        return $this->_acl;
    }

    public function getAcl($userId = null) {
        if ($userId) {
            $this->_setPermissions($userId);
        }
        return $this->_acl;
    }

    /**
     * Is allow
     * @param string $controller
     * @param string $actionName
     * @param int $userId
     */
    public function isAllow($controllerName, $actionName) {
        if ($this->_auth->StaffId == $this->_userPrivilagesModel->configs->superAdminId) return true;

        $this->_setPermissions($this->_auth->StaffId);

        return $this->_acl->isAllowed('permission', "$controllerName.$actionName");
    }

    /**
     * Set permission for user
     * @param int $userId
     * @return ACL object
     */
    private function _setPermissions($userId) {
        if ($userId == $this->_userPrivilagesModel->configs->superAdminId) {
            $resources  = $this->_resourcesModel->getResourceForAccessControllerList();

            $this->_setResources($resources);

            foreach ($resources as $controllerName => $actionNames) {
                foreach ($actionNames as $actionName) {
                    $this->_acl->allow("permission", "$controllerName.$actionName");
                }
            }
        } else {
            if ($this->_userPrivilagesModel->configs->useLivePermissions || ! isset($this->_auth->permissions)) {
                $this->_setLivePermissions($userId);
            } else {
                $this->_setSessionPermission();
            }
        }

        return $this->_acl;

    }

    /**
     * Set live permission for user
     * @param int $userId
     * @param
     */
    private function _setLivePermissions($userId) {
        $resources  = $this->_resourcesModel->getResourceForAccessControllerList();
        $privilages = $this->_userPrivilagesModel->getPrivilageByUserId($userId);

        $this->_setResources($resources);

        foreach ($privilages as $controllerName => $actionNames) {
            foreach ($actionNames as $actionName => $isAllowed) {
                if ($isAllowed) {
                    $this->_acl->allow("permission", "$controllerName.$actionName");
                } else {
                    $this->_acl->deny("permission", "$controllerName.$actionName");
                }
            }
        }

        return $this->_acl;
    }

    /**
     * Set session permission
     */
    private function _setSessionPermission() {
        $resources  = $this->_auth->permissions['resources'];
        $privilages = $this->_auth->permissions['privilages'];

        $this->_setResources($resources);

        foreach ($privilages as $controllerName => $actionNames) {
            foreach ($actionNames as $actionName => $isAllowed) {
                if ($isAllowed) {
                    $this->_acl->allow("permission", "$controllerName.$actionName");
                } else {
                    $this->_acl->deny("permission", "$controllerName.$actionName");
                }
            }
        }
    }

    /**
     * Set resources
     * @param array $resources
     */
    private function _setResources($resources) {
        foreach ($resources as $controllerName => $actionNames) {
            foreach ($actionNames as $actionName) {
//                echo "$controllerName.$actionName<br />";
                $this->_acl->addResource(new Zend_Acl_Resource("$controllerName.$actionName"));
            }
        }
    }

    /**
     * Set role
     * @param string $roleName
     */
    private function _setRole($roleName){
        $this->_acl->addRole($roleName);
    }
}