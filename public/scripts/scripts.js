var CommonV2 = {
        /**
        * Page: Show all
        * Filter value by field (Use in list page)
        * Redirect when create link finished
        */    
        filter: function (val, field){
            
            var _href = window.location.href;    

            var _tab ='';
            
            indexOf = _href.indexOf("#");
            if(indexOf != -1){
                _tab = _href.substring(indexOf);
                _href = _href.substring(0,indexOf);                
            }
            
            _href = _href.replace(/(\/$)/,"") + "/";
            _href = _href.replace(new RegExp(field + '/[^/]+/', 'gi'),"");
        
            if ($.trim(val) != ''){
                _href = _href + field + '/' + val;
            }
            

            window.location = _href + _tab;
        },
        search: function (val, field){
            var _href = window.location.href;
            var _tab ='';
            
            indexOf = _href.indexOf("#");
            if(indexOf != -1){
                _tab = _href.substring(indexOf);
                _href = _href.substring(0,indexOf);                
            }
            
            _href = _href.replace(/(\/$)/,"") + "/";
            _href = _href.replace(/(keywords\/[^\/]*\/)|(fieldsearch\/[^\/]+\/)/ig,"");
            _href = _href + 'keywords/'+ encodeURIComponent(val) + '/fieldsearch/'+ field;
            
             window.location = _href + _tab;
        },
        /**
         * Page: Show all
         * Quick update 01 field
         */    
        quickUpadte: function (controller, id, field, obj) {
            if(CurrentElement.valueBefore != obj.value){
                newValue = (obj.value == 'NaN') ? null : obj.value;        
                $.post( "/" + controller + "/update-field" , { field: field, id: id, value: newValue },    function(data){
                    if(!$('.quick-update-box').html()){
                        $('body').append('<div class="quick-update-box"></div>');
                    }                
                    if(data.error){ 
                        $('<div class="quick-update-box-sub error">'+data.message+'</div>').appendTo('.quick-update-box').animate({ opacity : 1.0 }, 3000).fadeOut();;
                        $(obj).css('background', '#FBC2C4');
                    }else {
                        $('<div class="quick-update-box-sub success">'+data.message+'</div>').appendTo('.quick-update-box').animate({ opacity : 1.0 }, 3000).fadeOut();;
                        $(obj).css('background', '#C6D880');
                    }
                    
                },'json');
            }
        }    
     }



$(function(){
	/* Search */	
    $('form.quick-search-v2').submit(function() {
        $kw = $(this).find('input[name="keywords"]');
        if( "" == $.trim($kw.val())){
            $kw.css({border:"2px solid red"}).focus();
        } else {
            CommonV2.search($.trim($(this).find('input[name="keywords"]').val()), $(this).find('select[name="fieldsearch"]').val());
        }
        return false;
    });
    
	/* Translate */
    $('.edit-translate').dblclick( function () {
        $('span.hint').popover('hide');
        showFormEditTranslate($(this));
        
    });    
    $('.edit-translate-hints').dblclick( function () {
        $('span.hint').popover('hide');
        showFormEditTranslate($(this));
    });
    loadPopover();
});

function loadPopover(){
    $('span.hint').each(function(){
    	$(this).popover({
    		title:$(this).parent().find('span.edit-translate').html(),
    		content:$(this).attr('tooltip')
    	});
    });
}

var textTranslateCurrent = '';
var hintTranslateCurrent = '';
function showFormEditTranslate(obj) {
    $parent = obj.parent();
    $text = $parent.find('.edit-translate');
    $hint = $parent.find('.edit-translate-hints');
    if(typeof($parent.find('.edit-translate #editing-translate').val()) == 'undefined') {
        $hint.removeClass('hint');
        textTranslateCurrent = $.trim($text.html());
        hintTranslateCurrent = $.trim($hint.attr('tooltip'));
        
        $text.html('<div class="translate-small" style="font-size:11px; font-weight:normal">Text translate:</div>' + 
                '<input type="text" id="editing-translate" value="'+textTranslateCurrent+'"/>'
        );
        
        $hint.html('<div class="translate-small" style="font-size:11px; font-weight:normal">Text hints:</div>' + 
                    '<input type="text" id="editing-translate-hint" value="'+hintTranslateCurrent+'"/>' 
        );
        
        $parent.append('<button onclick="quickSaveTranslate(this); return false;" class="buttonQuickSaveTranslate" style="display:block">save</button>');
        
   }
}
function quickSaveTranslate(obj){
    $parent = $(obj).parent();
    $text = $parent.find('.edit-translate');
    $hint = $parent.find('.edit-translate-hints');
    
    valueText = $.trim($text.find('#editing-translate').val());
    valueHint = $.trim($hint.find('#editing-translate-hint').val());
    
    if(valueText == ''){
        valueText = textTranslateCurrent;
    }
    
        
    $.post("/system-language-page/rename",
    { 
        fields: $text.attr('fields'),
        page: $text.attr('page'),
        valueText: valueText,
        valueHint: valueHint
    }, 
    function (data) {
        if (!$('.quick-update-box').html()) {
            $('body').append('<div class="quick-update-box"></div>');
        }
        if(data.error == 0){
            $text.children('input').remove();
            $text.html(valueText);
            
            if (valueHint == '') {
                $hint.html('').removeClass('hint');
            } else {
                $hint.html("<i class='icon-question-sign'></i>").addClass('hint');
            }
            $hint.attr('title',valueHint);
            $hint.attr('tooltip',valueHint);
            
            $parent.find('.buttonQuickSaveTranslate').remove();
            
            $('<div class="quick-update-box-sub alert alert-success">'+data.message+'</div>').appendTo('.quick-update-box').animate({ opacity : 1.0 }, 3000).fadeOut();
        }else {
            $('<div class="quick-update-box-sub alert alert-error">'+data.message+'</div>').appendTo('.quick-update-box').animate({ opacity : 1.0 }, 3000).fadeOut();
            $(this).css('background', '#C6D880');
        }
    },'json');
    
    return false;
    
}

var CurrentElement = {
    valueBefore: ""
}