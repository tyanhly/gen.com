<?php

class Zend_View_Helper_RenderFormElement extends Zend_View_Helper_Abstract
{
    public function renderFormElement($element) {
        if ($element->hasErrors()) {
            $t = '<div class="error"> '
               .     '<div class="control-group error">' 
               .         $element
               .         implode(', ',$element->getMessages())
               .     '</div> '
               . '<div>';
        } else {
            return $element;
        }
    }
}