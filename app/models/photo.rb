class Photo < ActiveRecord::Base
  attr_accessible :image
  validates :image, :presence => true
end
