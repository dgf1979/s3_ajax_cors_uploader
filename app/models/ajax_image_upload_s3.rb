class AjaxImageUploadS3
  @@s3_buckets = []
  @s3_bucket = nil

  def initialize(bucket_name=ENV['AWS_BUCKET'])
    # if it already exists, use it.
    bucket_index = @@s3_buckets.find_index{|bucket| bucket.name == bucket_name}
    if bucket_index == nil then
      # make sure environment is a-ok
      if !(ENV['AWS_SECRET_ACCESS_KEY'] && ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_REGION']) then
        raise Exception.new("Missing AWS region, key or secret in ENV")
      end
      # get the bucket from the arguments or ENV
      s3_resource = Aws::S3::Resource.new
      if (s3_resource.bucket(bucket_name)) then
        @s3_bucket = s3_resource.bucket(bucket_name)
        @@s3_buckets.push(@s3_bucket)
      else
        raise Exception.new("Unable to mount S3 bucket named '#{bucket_name}'; check passed bucket name or AWS_BUCKET ENV.")
      end
      # set the CORS policy on the bucket if the current one is no bueno
      if !aws_cors_policy_set? then
        raise Exception.new("Missing CORS config on '#{bucket_name}' - run AjaxImageUploadS3.cors_config(['http://host.domain:port'])")
      end
      if !aws_cors_policy_valid? then
        raise Exception.new("CORS config on '#{bucket_name}' does not appear to have valid settings to allow uploading to S3 - run AjaxImageUploadS3.cors_config(['http://host.domain:port'])")
      end
    else
      @s3_bucket = @@s3_buckets[bucket_index]
    end
  end

  # generate the object used to build a pre-ath'd upload form
  def post_data(image_upload_path) # image path e.g. 'demo_uploads/'
    post_data = @s3_bucket.presigned_post(:key_starts_with => image_upload_path)
    post_data.content_type_starts_with('image/')
    post_data.acl('public-read')
    post_data.key(image_upload_path + '/${filename}')
    post_data.content_type('image/')
    return post_data
  end

  # validate that CORS policy is set on the bucket
  def aws_cors_policy_set?
    begin
      rules = @s3_bucket.cors.cors_rules
    rescue Aws::S3::Errors::NoSuchCORSConfiguration
      return false
    end
    return true
  end

  # validate that CORS policy will allow uploader to function
  def aws_cors_policy_valid?
    return false if !aws_cors_policy_set?
    @s3_bucket.cors.cors_rules.each do |rule|
      has_post = rule.allowed_methods.include?('POST')
      has_location = rule.expose_headers.include?('Access-Control-Allow-Origin')
      has_allow_origin = rule.expose_headers.include?('Location')
      if has_post && has_location && has_allow_origin then
        return true
      end
    end
    return false
  end

  # set a CORS policy on the bucket
  def self.cors_config(origins)
    allowed_origins = []
    if origins.class == 'Array' then
      origin.each do |origin|
        if valid_origin(origins) then
          allowed_origins.push(origin)
        end
      end
    elsif origins.class == 'String' then
      if valid_origin(origins) then
        allowed_origins.push(origins)
      end
    end

    if allowed_origins.length > 0 then
      @s3_bucket.cors.put({
        cors_configuration: {
          cors_rules: [{
              allowed_headers: ["*"],
              allowed_methods: ["POST", "GET", "HEAD"],
              allowed_origins: allowed_origins,
              expose_headers: ["x-amz-request-id", "Access-Control-Allow-Origin", "Location"],
              max_age_seconds: 300}]
          }
        })
      else
        raise Exception.new("invalid URI(s) passed to CORS allowed_origins. No policy created on bucket '#{@s3_bucket.bucket_name}'")
      end
  end

  private
    def valid_origin(uri_string)
      begin
        host = URI.parse
        if host.scheme == 'http' || host.scheme == 'https'
          return true
        else
          return false
        end
      rescue URI::InvalidURIError
        return false
      end
    end
end
