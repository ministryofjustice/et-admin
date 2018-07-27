$(document).ready(function() {
    var iframe = $('.active-admin-sidekiq iframe');
    iframe.on('load', function(a, b, c) {
        iframe.height(iframe.contents().find('body').height())
    });
});