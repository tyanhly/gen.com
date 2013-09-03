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
                 <div class='' style='position:relative; '>
                    <div style='height:42px; line-height:42px; vertical-align:middle;'>
                        <span>". $this->view->text($nameDb)."</span>
                        $option
                    </div>
                    <div class='pull-right' style='position:absolute; right:0px; top:0px; width:15px;'>
                        <a class = '$ascActive' href='" . $this->removeParams($nameDb, $ascActive ? '' : 'asc') . "'   title='Sort up'  >
                            <span class='glyphicon glyphicon-chevron-up'></span>
                        </a>
                        <a class = '$descActive' href='" . $this->removeParams($nameDb, $descActive ? '' : 'desc') . "'  title='Sort down'  >
                            <span class='glyphicon glyphicon-chevron-down'></span>
                        </a>
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