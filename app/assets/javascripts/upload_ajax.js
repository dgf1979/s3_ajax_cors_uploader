// ajax uploading to S3

$.support.cors = true;

$(document).ready(function() {

  // trigger on file select
  $(document).on('change', '.btn-file :file', function() {
    console.log('firing trigger for file select');
    var input = $(this);
    var numFiles = input.get(0).files ? input.get(0).files.length : 1;
    var label = input.val().replace(/\\/g, '/').replace(/.*\//, '');

    $("#s3-image-uploader-filename").val(label);
    if (label === '') {
      $('#s3-image-uploader-submit-btn').prop('disabled', true);
    } else {
      $('#s3-image-uploader-submit-btn').prop('disabled', false);
    }
    console.log('done firing trigger for file select');
  });

  // toggle the modal and collect the upload-group
  $("button[data-ajax-img-upload-group]").on('click', function() {
    var uploadGroup = $(this).attr('data-ajax-img-upload-group');
    console.log("setting upload group to: " + uploadGroup);
    $("#upload-group.s3-ajax-uploader").val(uploadGroup);
    // trigger modal
    jQuery.noConflict();
    $('#ajax-img-upload').modal('show');
  });

  $('form.s3-ajax-uploader').submit(function(event) {
    event.preventDefault();
    // dismiss modal
    $('#ajax-img-upload').modal('hide');
    // collect data from the image fields
    var uploadGroup = $("#upload-group.s3-ajax-uploader").val();
    console.log("got upload group: " + uploadGroup);
    var imgContainerDiv = $("div[data-ajax-img-upload-group='" + uploadGroup + "']");
    var imgUrlInput = $("input[data-ajax-img-upload-group='" + uploadGroup + "']");
    // collect form data from form
    var formData = new FormData($(this)[0]);
    // set the image to a loading spinner
    imgContainerDiv.html('<img src="/assets/ajax-loader.gif" alt="loading.." />');
    console.log("submitting image upload..")
    var startTimer = new Date();
    var jqxhr = $.ajax({
      url         : $(this).attr('action'),
      type        : $(this).attr('method'),
      contentType: false,
      processData: false,
      data        : formData})
    .done(function( data, textStatus, jqXHR ) {
      console.log('AJAX image upload done');
      var image_name = $('#s3-image-uploader-filename').val();
      var image_path = decodeURIComponent(jqXHR.getResponseHeader('Location'));
      imgContainerDiv.html('<img src="' + image_path + '" alt="' + image_name + '" />');
      console.log('URL to image: ' + image_path);
      imgUrlInput.val(image_path);
      var stopTimer = new Date();
      console.log("upload took approx. " + (stopTimer - startTimer) / 1000 + " seconds.");
      // clear the uploader
      $('#s3-image-uploader-filename').val("");
    })
    .fail(function( jqXHR, textStatus, errorThrown ) {
      alert('AJAX image upload error');
      console.log(textStatus + "\n" + errorThrown);
    })
    .always(function( jqXHR, textStatus, errorThrown ) {
      console.log('AJAX image upload complete');
      $('input[type="submit"][value="Upload Image"]').prop('disabled', true);
    });
    return false;
  });
});
