class Photo < ActiveRecord::Base
  attr_accessible :image
  validates :image, :presence => true
  #carrierwave uploader
  mount_uploader :image, ImageUploader

  def self.cors_config
    if !(ENV['AWS_BUCKET'] && ENV['AWS_SECRET_ACCESS_KEY'] && ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_REGION']) then
      raise Exception.new("Missing AWS or S3 Bucket config in ENV")
    end

    s3_resource = Aws::S3::Resource.new

    if (s3_resource.bucket(ENV['AWS_BUCKET'])) then
      #s3_bucket = s3_resource.bucket(ENV['AWS_BUCKET'])
      s3_bucket = s3_resource.bucket('cors-dev-test')

      s3_bucket.cors.put({
        cors_configuration: {
          cors_rules: [
            {
              allowed_headers: ["*"],
              allowed_methods: ["POST", "GET", "HEAD"],
              allowed_origins: ["http://*", "https://*"],
              expose_headers: ["Host", "Access-Control-Allow-Origin"],
              max_age_seconds: 300,
            },
          ],
        }
      })
      return s3_bucket.cors.cors_rules
    else
      raise Exception.new("Unable to contact S3 bucket named '#{ENV['AWS_BUCKET']}' in region '#{ENV['AWS_REGION']}'")
    end
  end
end
