class FroalaImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :aws

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{Rails.env}/uploads/editor"
  end

  def filename
    "#{DateTime.now.strftime("%Y-%m-%d-%s")}-#{model[:original_filename]}"
  end
end
