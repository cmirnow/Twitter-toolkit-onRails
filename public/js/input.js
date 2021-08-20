$(document).ready(function() {
    $("#select_action").change(function() {
        var value = $(this).val();
        if (value == "follow" || value == "unfollow" || value == "follow-hands" || value == "use-list-to-follow") {
            $("#Input").hide();
            $("#Textarea").hide();
        } else if (value == "posting") {
            $("#Input").hide();
            $("#Textarea").show();
            $("#Textarea").focus(function() {
                $(this).animate({
                    height: 200
                }, "normal");
            }).blur(function() {
                $(this).animate({
                    height: 50
                }, "normal");
            });
        } else {
            $("#Input").show();
            $("#Textarea").hide();
        }
    });
});
