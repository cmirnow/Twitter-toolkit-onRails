function call() {
    $('#btnSubmit').prop('disabled', true);
    var msg = $('#twitsform').serialize();
    $.ajax({
        type: 'GET',
        data: msg,
        cache: false,
        complete: function(data) {
            $('#btnSubmit').prop('disabled', false);
            var div = document.createElement('div');
            div.innerHTML =
                '<div class="alert alert-info" role="alert">' +
                data.responseText +
                '</div>';
            $('#flash-message').html(document.body.appendChild(div));
        }
    });
}
