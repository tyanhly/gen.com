<?php
/**
 * Helper will display field
 *
 * @author code generate
 */
class Zend_View_Helper_RenderTh extends Zend_View_Helper_Abstract
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
    function renderTh($nameDb, $displayName = "", $option = "" ) {
         $nameDbSort = $nameDb. '_Sort';
        $ascActive  = (strtolower($this->view->$nameDbSort) == 'asc')  ? "active" : '';
        $descActive = (strtolower($this->view->$nameDbSort) == 'desc') ? "active" : '';

        echo "<th>
                 <div class='row-fluid show-grid' style='position:relative; height:36px; vertical-align:middle; '>
                    <div style='margin-right:15px; margin-top:10px;'>
                        <span>". $this->view->text($nameDb)."</span>
                        $option
                    </div>
                    <div class='pull-right' style='position:absolute; right:0px; top:0px; width:15px;'>
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