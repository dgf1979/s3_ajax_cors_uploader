## S3 AJAX+CORS Uploader for GrowerSpace ##

This prototype was built to demonstrate direct uploading of photos to S3.

The code is based on Rails 3.2/Ruby 1.9 and uses the versions of Bootstrap, jQuery, and the various gems that are present on the production Sustainable Harvest GrowerSpace portal in order to remain compatible with that application.

### Description ###

The code has a demo 'photos' MVC with a single 'image' attribute for storing the file name. CarrierWave is used for image processing as it is in the current GrowerSpace app.

### Author(s) ###

Andrew Finstrom

### Requirements ###
```
    PostgreSQL
    AWS Environment variables (with appropriate values) as follows:
      AWS_BUCKET=some-bucket
      AWS_SECRET_ACCESS_KEY=asdfsdummmykey
      AWS_REGION=us-east-1
      AWS_ACCESS_KEY_ID=DREFADSFDUMMYKEY

    Optionally 'NEW_RELIC_LICENSE_KEY' can be used if using the newrelic_rpm gem
```

### Setup ###
```
    bundle
    rake db:create
    rake db:migrate
```

### Production Migration Steps ##

The following steps are anticipated to be required to move the prototype code into he GrowerSpace production app:

1.) Add and bundle the AWS SDK 2.0 gem - e.g. in the gemfile add:
```
  # AWS SDK (for Amazon S3 helpers)
  gem 'aws-sdk', '~> 2'
```

2.) Migrate these files:
```
  /app/assets/images/ajax-loader.gif (or replace with any desired 'spinner' gif)
  /app/assets/upload_ajax.js
  /app/assets/upload_ajax.css
  /app/models/ajax_image_upload_s3.rb
  /views/shared/_upload_ajax.html.erb
```

3.) Modify any existing models with a CarrierWave uploader mounted have the remote_image_url accessible, e.g.:
```
  attr_accessible :remote_image_url
```

4a.) In you controller methods Create an instance of AjaxImageUploadS3, and generate post data by giving a path where the uploaded files will be saved in S3
```
  ex:
  upload_path = 'dev/temp/images'
  s3_uploader = AjaxImageUploadS3.new()
  @s3_post_data = s3_uploader.post_data(upload_path) (this exact instance variable name is expected in the _upload_ajax partial)
```

4b.) In the controller you will also need to collect the URL(s) from the param 'remote_image_urls', which is returned as an array of 0 or more URL's to S3 image locations - e.g.:
```
  image_urls = params[:remote_image_urls] || []
  image_urls.each do |url|
  @example.photos.create(remote_image_url: url)
end
```
See app/controllers/photos_controller.rb for example.

5.) Render the upload_ajax partial in the view where the uploads will be taking place. NOTE: you only need to render this ONCE per view - it is designed to re-use the same modal even if you are adding multiple uploaders.
```
  # new.html.erb
  <%= render 'shared/upload_ajax' %>
```
See app/photos/\_form.html.erb for example

6.) Create:
  a.) button to trigger the modal
  b.) div to contain the image(s) (this will also be used to target 'loading' spinners)

Each of the above must have a custom data attribute that groups them as a single 'set' of elements; this is how the jQuery code know which elements are in the same group when more than one uploader is on a page. The value of the attribute can be text or numbers - it doesn't matter, as long as it is the same for each group of button/div/inputs that belong together, and unique from any other uploader groups of elements on the page.
```
  <div data-ajax-img-upload-group='demo1'><img src="<%= @model.image %>" /></div>
  <button type="button" class="btn btn-info" data-ajax-img-upload-group='demo1'>Upload Image</button>
```
See app/photos/\_form.html.erb for an example that includes two forms, each with its own uploader group (in this case the form is for the same model, which makes no sense in practice - it's only for demonstration purposes.)


### License ###
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
