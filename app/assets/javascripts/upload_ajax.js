// ajax uploading to S3

$.support.cors = true;

$(document).ready(function() {

  // trigger on file select
  $(document).on('change', '.btn-file :file', function() {
    console.log('firing trigger for file select');
    var input = $(this);
    var numFiles = input.get(0).files ? input.get(0).files.length : 1;
    if (numFiles > 1) {
      var label = numFiles + ' files selected for upload';
    } else {
      var label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    }
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
    $('#ajax-img-upload').modal('show');
  });

  // trigger upload(s)
  $('#s3-image-uploader-submit-btn').click(function(event) {
    // get each file to be uploaded
    var filesToUpload = $('#s3-ajax-html5-file-input-multiple').get(0).files;
    // collect data from the image fields
    var uploadGroup = $("#upload-group.s3-ajax-uploader").val();
    console.log("got upload group: " + uploadGroup);
    // dismiss modal
    $('#ajax-img-upload').modal('hide');
    for (var i = 0; i < filesToUpload.length; i++) {
      ajaxImgUpload(filesToUpload[i], uploadGroup);
    }
  });

  // create an ajax upload for each file
  function ajaxImgUpload(file, group) {
    var uploadForm = $('form.s3-ajax-uploader')[0];
    var imgContainerDiv = $("div[data-ajax-img-upload-group='" + group + "']");
    var imgLoad = $('<img src="/assets/ajax-loader.gif" alt="loading.." />');

    imgContainerDiv.append(imgLoad);

    // collect form data from form
    var formData = new FormData(uploadForm);
    formData.set('file', file);
    debugger;

    // set the image to a loading spinner
    console.log("submitting image upload..")
    var startTimer = new Date();
    var jqxhr = $.ajax({
      url         : $(uploadForm).attr('action'),
      type        : $(uploadForm).attr('method'),
      contentType: false,
      processData: false,
      data        : formData})
    .done(function( data, textStatus, jqXHR ) {
      console.log('AJAX image upload done');
      var image_name = $('#s3-image-uploader-filename').val();
      var image_path = decodeURIComponent(jqXHR.getResponseHeader('Location'));
      var imgTag = $('<img src="' + image_path + '" alt="' + file.name + '" />');
      imgLoad.remove();
      imgContainerDiv.append(imgTag);
      console.log('URL to image: ' + image_path);
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
  }

});
