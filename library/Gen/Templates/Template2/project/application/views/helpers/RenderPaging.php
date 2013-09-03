<?php
/**
 * Helper will return string "Display form 1 to 15 out of 100 result"
 *
 */
class Zend_View_Helper_RenderPaging extends Zend_View_Helper_Abstract
{
    /**
     *
     * @param Zend_Paginator $paginator
     * @return string
     */
    function renderPaging($paginator) {
        $options = array(
            '5' => '5', '10' => '10', '20' => '20', '50' => '50',
            '100' => '100', '200' => '200',
        );
        $perpage = $paginator->getItemCountPerPage();
        if(!in_array($perpage,$options)){
            $perpage = NUMBER_OF_ITEM_PER_PAGE;
        }
        $itemNumber = $paginator->getCurrentItemCount();
        $first = $perpage * ($paginator->getCurrentPageNumber() - 1);
        if($itemNumber != 0) {
            $first++;
        }
        
        $selectElement = new Zend_Form_Element_Select('perpage');
        $selectElement->setAttrib('onchange', 'CommonV2.filter(this.value, \'perpage\');');
        $selectElement->setAttrib('class', 'input-mini');
        $selectElement->addMultiOptions($options);
        $selectElement->setDecorators(array('ViewHelper'));        
        $selectElement->setValue($perpage);
        
        $variables = array(
            '%%FIRST%%' => $first,
            '%%LAST%%' => $first + $itemNumber - 1,
            '%%TOTAL%%' => $paginator->getTotalItemCount(),
            '%%ELEMENT%%' => $selectElement,
        );
        $t = str_replace(array_keys($variables), $variables, $this->_getTemplate());
        return $t;
        
    }
    private function _getTemplate(){
        $t = '
            <tfoot>
                <tr>
                    <td  colspan="50">
                        Display form %%FIRST%% to %%LAST%% out of %%TOTAL%% result

                        <div class="pull-right">
                            Display&nbsp;
                            %%ELEMENT%%
                            &nbsp; record per page.
                        </div>
                    </td>
                </tr>
            </tfoot>
        ';
        return $t;
    }
}