class FroalaImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/froala"
  end

  # # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    if default_img_name = model.imageable.try(:default_img_name)
      ActionController::Base.helpers.asset_path("defaults/#{version_name}_#{default_img_name}")
    end
  end
end
