$(document).ready(function(){
     $("#select_action").change(function(){
        var value = $(this).val();
         if(value=="follow" || value=="unfollow")
         {
             $("#Input").hide();
            $("#Textarea").hide();
         }
         else if(value=="posting")
         {
         $("#Input").hide();
         $("#Textarea").show();
         }
         else 
         {
            $("#Input").show();
         $("#Textarea").hide();
         }
     });
   });
 
