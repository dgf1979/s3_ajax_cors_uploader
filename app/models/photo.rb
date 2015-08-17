class Photo < ActiveRecord::Base
  attr_accessible :image, :remote_image_url
  validates :image, :presence => true
  validates :remote_image_url, :presence => true
  #carrierwave uploader
  mount_uploader :image, ImageUploader
end
