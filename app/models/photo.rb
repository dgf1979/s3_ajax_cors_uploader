# photo
class Photo < ActiveRecord::Base
  attr_accessible :image, :remote_image_url
  belongs_to :example
  validates :image, presence: true
  validates :remote_image_url, presence: true
  # carrierwave uploader
  mount_uploader :image, ImageUploader
end
