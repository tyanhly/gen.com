<?php
if(APPLICATION_ENV == 'production'){
    define('STATIC_SERVER', '');
}else{
    define('STATIC_SERVER', '');
}

define('NUMBER_OF_ITEM_PER_PAGE', 20);