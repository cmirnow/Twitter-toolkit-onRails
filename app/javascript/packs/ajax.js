window.call = function () {
    $('#btnSubmit').prop('disabled', true);
    var msg = $('#twitsform').serialize();
    $.ajax({
        type: 'GET',
        data: msg,
        cache: false,
        complete: function(data) {
            $('#btnSubmit').prop('disabled', false);
            var div = document.createElement('div');

            if (data.responseText.includes('The task is queued')) {
                var alert_style = '<div class="alert alert-info alert-dismissible fade show" role="alert">';
            } else {
                var alert_style = '<div class="alert alert-warning alert-dismissible fade show" role="alert">';
            }

            div.innerHTML =
                alert_style +
                '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                data.responseText +
                '</div>';
            $('#flash-message').html(document.body.appendChild(div));
        }
    });
}