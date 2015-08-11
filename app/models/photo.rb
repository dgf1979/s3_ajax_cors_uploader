class Photo < ActiveRecord::Base
  attr_accessible :image
  validates :image, :presence => true
  #carrierwave uploader
  mount_uploader :image, ImageUploader
end
