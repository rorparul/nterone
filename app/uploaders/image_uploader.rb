class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  #
  # # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    if default_img_name = model.imageable.try(:default_img_name)
      ActionController::Base.helpers.asset_path("defaults/#{version_name}_#{default_img_name}")
    end
  end

  version :processed_image, if: :carousel_item? do
    # process resize_to_fill: [1280, 720]
    process resize_to_fill: [745, 330]
  end

  version :platform_icon, if: :platform? do
    process resize_to_limit: [200, 150]
  end

  version :subject_icon, if: :subject? do
    process resize_to_fill: [62, 62]
  end

  version :subject_small_icon, if: :subject? do
    process resize_to_fill: [40, 40]
  end

  private

  def carousel_item?(picture)
    model.imageable_type == 'CarouselItem'
  end

  def platform?(picture)
    model.imageable_type == 'Platform'
  end

  def subject?(picture)
    model.imageable_type == 'Subject'
  end
end
