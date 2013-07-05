<?php
/**
 * Helper will display field
 *
 * @author code generate
 */
class Zend_View_Helper_HelperDisplayTh extends Zend_View_Helper_Abstract
{
    /**
     *
     * @param type $nameDb
     * @param type $fieldSearch
     * @param type $order
     * @param type $config
     * @param type $option
     *
     * @return string
     */
    function helperDisplayTh($nameDb, $displayName = "", $option = "" ) {
        $zc = Zend_Controller_Front::getInstance();
        $params = $zc->getRequest()->getParams();
        $ascActive = $descActive = '';
        foreach ($params as $key => $value) {
            if (strstr($key, '_Sort') && $key == $nameDb.'_Sort') {
                $ascActive  = ($value == 'asc')  ? "icon-white" : '';
                $descActive = ($value == 'desc') ? "icon-white" : '';
                break;
            }
        }
        echo "<th>
                 <div class='row-fluid show-grid'>
                    <div class='span10'>
                        <span>". $this->view->text($nameDb)."</span>
                        $option
                    </div>
                    <div class='pull-right'>
                        <a class = 'icon-chevron-up $ascActive' href='" . $this->removeParams($nameDb, $ascActive ? '' : 'asc') . "'   title='Sort up'  ></a>
                        <a class = 'icon-chevron-down $descActive' href='" . $this->removeParams($nameDb, $descActive ? '' : 'desc') . "'  title='Sort down'  ></a>
                    </div>
                 </div></div>
            </th>";

    }
    /**
    * Order sort
    */
    function removeParams($nameDb, $ascOrDescActive){
        $_href = $this->view->url(array("{$nameDb}_Sort" => 'none' ));
        $_href = str_replace("/{$nameDb}_Sort/none", "", $_href);
        if($ascOrDescActive){
            return $_href . "/{$nameDb}_Sort/$ascOrDescActive";
        }
        return $_href;
    }

}