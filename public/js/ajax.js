
 	function call() {
 	$('#btnSubmit').prop('disabled', true);
 	  var msg   = $('#twitsform').serialize();
        $.ajax({
          type: 'GET',
          url: '/tweets',
          data: msg,
          success: function(data) {
          $('#btnSubmit').prop('disabled', false);
          },
          error:  function(xhr, str){
          $('#btnSubmit').prop('disabled', false);
          }
        });
    }

