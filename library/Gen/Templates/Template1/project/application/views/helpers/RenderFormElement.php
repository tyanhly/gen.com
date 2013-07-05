<?php

class Zend_View_Helper_RenderFormElement extends Zend_View_Helper_Abstract
{
    /**
     * Enter description here ...
     * @param Zend_Form_Element $element
     * @author Tung Ly
     */
    public function renderFormElement($element) {

        switch ($element->getType()) {
            case 'Zend_Form_Element_Textarea':
                $element->setAttrib('class', 'input-xxlarge');
                $element->setAttrib('rows', 5);
                $element->setAttrib('cols', 80);
            break;
            case 'Zend_Form_Element_Hidden':
                return $element;
            default:
                ;
            break;
        }
        
        $error = '';
        if ($element->hasErrors()) {
            $error = 'error';
        }
        if($element->getType() == 'Zend_Form_Element_Textarea'){
            
        }
        $variables = array(
            '%%ERROR_CLASS%%' => $error,
            '%%ELEMENT_NAME%%' => $element->getName(),
            '%%ELEMENT_LABEL%%' => $element->getLabel(),
            '%%ELEMENT%%' => $element,
            '%%HELP_MESSAGE%%' => current($element->getMessages()),
        );
        $t = str_replace(array_keys($variables), $variables, $this->_getTemplate());
        return $t;
    }
    
    private function _getTemplate(){
        $t = '
            <div class="control-group %%ERROR_CLASS%%">
                <label for="%%ELEMENT_NAME%%" class="control-label">%%ELEMENT_LABEL%%</label>
                <div class="controls">
                    %%ELEMENT%%
                    <span class="help-inline">%%HELP_MESSAGE%%</span>
                </div>
            </div>
        ';
        return $t;
    }
}
/*
<div class="control-group error">
<label for="inputError" class="control-label">Input with error</label>
<div class="controls">
<input type="text" id="inputError">
<span class="help-inline">Please correct the error</span>
</div>
</div>
*/