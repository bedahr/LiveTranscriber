$(document).ready(function() {

  $("#welcome #url_toggle").click( function() {
    $(this).hide();
    $("form.url_upload").show();
    $("input.url").focus().animate({width: "600px"}, 1000);
    return(false);
  });

  $('#welcome #fileupload').fileupload({
       dataType: 'json',

       done: function (e, data) {
         console.log("Upload succeeded");
         window.location = data.result.url;
       },

       progressall: function (e, data) {
           var progress = parseInt(data.loaded / data.total * 100, 10);
           $('#progress').show();
           $('#progress .bar').css(
               'width',
               progress + '%'
           );
       }
   });

});
