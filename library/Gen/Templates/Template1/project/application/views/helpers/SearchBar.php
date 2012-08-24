<?php

class Zend_View_Helper_SearchBar extends Zend_View_Helper_Abstract
{
    

    public function searchBar ($typeSearchs = null, $filters = null, $buttons = null, $params = null)
    {
        $front = Zend_Controller_Front::getInstance();

        if(!$params){
            $params = $front->getRequest()->getParams();
        }

        if(!$typeSearchs){
            $typeSearchs = array(
                'none' => 'All'
            );
        }

        if(!$filters){
            $filters = array(
    
            );
        }

        if(!$buttons){
            $buttons = array(
    
            );
        }

        $actionUrl = "/{$params['controller']}/{$params['action']}";
        $keywordsValue = isset($params['keywords'])?$params['keywords'] : '';
        
        $selectElement = new Zend_Form_Element_Select('fieldsearch');
        $selectElement->addMultiOptions($typeSearchs);
        $selectElement->setAttrib('class', 'input-medium');
        $selectElement->setDecorators(array('ViewHelper'));     
        $selectElement->setValue($params['fieldsearch']);

        $filterElements = implode("\n",$filters);
        $buttonElements = implode("\n",$buttons);


        $variables = array(
            '%%ACTION_URL%%'           => $actionUrl,
            '%%KEYWORDS%%'             => $keywordsValue,
            '%%SELECT_ELEMENT%%'       => $selectElement,
            '%%FILTER_ELEMENTS%%'      => $filterElements,
            '%%BUTTONELEMENTS%%'       => $buttonElements,
        );
        $result = $this->getTemplate();
        $result = str_replace(array_keys($variables), array_values($variables), $result);
//        echo $result;die;
        return $result;
    }

    public function getTemplate(){
        $t = '
<div class="row-fluid show-grid">
    <div class="span12">    

       <form class="well form-search quick-search-v2" method="post" action="%%ACTION_URL%%" name="quick-search"  >

            <label class="control-label">Keyword:</label>

            <input type="text" value="%%KEYWORDS%%" name="keywords" class="input-medium search-query"/>

            <label class="control-label">Type: </label>

            %%SELECT_ELEMENT%%

            <button class="btn" type="submit">
                <i class="icon-search"></i> Search
            </button>

            <a class="btn btn-small" href="%%ACTION_URL%%">Clear</a>

            %%FILTER_ELEMENTS%%

            <div class="pull-right">
                %%BUTTONELEMENTS%%
            </div>    
        
        </form>        

    </div>
</div>




        ';
        return $t;
    }

}