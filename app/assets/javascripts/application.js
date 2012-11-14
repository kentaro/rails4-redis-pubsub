//= require jquery
//= require jquery_ujs

$(function () {
    var result = $('#result');
    var notice = function (message) {
        result.append('<span class="notice">' + message + "</span>");
    };
    var error  = function (message) {
        result.append('<span class="error">' + message + "</span>");
    };
    var line   = function (message) {
        result.append(message + "\n");
    };

    $('#enqueue').click(function () {
        $.ajax({
            type: 'POST',
            url:  '/enqueue'
        }).done(function (res) {
            var source = new EventSource('/dequeue?job_id=' + res['job_id']);

            source.addEventListener('open', function(event) {
                notice("Connected to server...");
            }, false);

            source.addEventListener('message', function(event) {
                line(event.data);
            }, false);

            // On closed explicitely by close event
            source.addEventListener('close', function(event) {
                source.close();
                notice("Server emitted close event.");
            }, false);

            // On server closed connection
            source.addEventListener('error', function(event) {
                source.close();
                notice("<span class='notice'>Connection closed.");
            }, false);
        }).fail(function () {
            notice('Failed to connect server.');
        });
    });
});
