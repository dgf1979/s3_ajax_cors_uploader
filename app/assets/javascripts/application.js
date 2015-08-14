//= require jquery
//= require jquery_ujs
//= require_tree .

$.support.cors = true;
$(document).ready(function() {
  console.log("rock and roll");

  $('form.AjaxImageUploadS3').submit(function(event) {
    event.preventDefault();

    // collect form data from form
    var formData = new FormData($(this)[0]);

    console.log("submitting image upload..")
    $.ajax({
      // crossDomain : true,
      url         : $(this).attr('action'),
      type        : $(this).attr('method'),
      contentType: false,
      processData: false,
      data        : formData,
      success     : function( data ) {
                  alert('Submitted');
                },
      error       : function( xhr, err ) {
                  alert('Error');
                }
    });
    return false;
  });
});
