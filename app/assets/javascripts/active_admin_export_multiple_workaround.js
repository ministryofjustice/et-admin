$(document).ready(function() {
    $('a.active-admin-export-multiples-uploaded-file').on('click', function(event){
        var message;
        event.stopPropagation(); // prevent Rails UJS click event
        event.preventDefault();
        if ((message = $(this).data('confirm'))) {
            var me = this;
            ActiveAdmin.modal_dialog(message, $(this).data('inputs'), function(inputs) {
                $(me).trigger('confirm:complete', inputs);
            });
        } else {
            $(this).trigger('confirm:complete');
        }
    });
    $('a.active-admin-export-multiples-uploaded-file').on('confirm:complete', function(event, inputs){
        var href, form, hiddenInput;
        formData = Object.assign({}, inputs);
        formData[$('meta[name="csrf-param"]').attr('content')] = $('meta[name="csrf-token"]').attr('content');
        href = $(this).attr('href');
        form = $('<form method="POST">');
        form.attr('action', href);
        for(attr in formData) {
            hiddenInput = $("<input type='hidden'>");
            hiddenInput.attr('name', attr);
            hiddenInput.attr('value', formData[attr]);
            form.append(hiddenInput);
        }
        $('body').append(form);
        form.submit();
    });

});