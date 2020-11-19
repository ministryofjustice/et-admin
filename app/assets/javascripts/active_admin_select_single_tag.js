$(document).ready(function() {
    $('select.select-single-tag').each(function(i, el){
        var selectConfig = {
            placeholder: '',
            width: '80%',
            allowClear: true,
            tags: true
        };
        $(el).select2(selectConfig);
    });
});
