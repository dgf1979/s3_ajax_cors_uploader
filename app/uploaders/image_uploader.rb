# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if ENV['AWS_ACCESS_KEY_ID']
    storage :fog
  else
    storage :file
  end

  def store_dir
    "demo_uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process :resize_to_limit => [148, 98]
  end

  version :search_results do
    process :resize_to_limit => [110, 74]
  end

  version :large do
    process :resize_to_limit => [840, 556]
  end

  version :feature do
    process :resize_to_fill => [958, 356]
  end

  version :inline do
    process :resize_to_limit => [208, 269]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
