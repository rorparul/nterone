class PlatformsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_platform, only: [:show, :edit, :update, :destroy]

  def index
    @page      = Page.find_by(title: 'Vendor Index')
    @platforms = Platform.active.current_region.order(:title)
  end

  def show
    redirect_to session[:last_category_url] || root_path
  end

  def new
    @platform = Platform.new
    @platform.build_image
  end

  def edit
    @platform.build_image unless @platform.image.present?
  end

  def create
    @platform = Platform.new(platform_params)
    @platform.set_image(url_param: params['platform'], for: :image)
    if @platform.save
      flash[:success] = 'Platform successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def update
    @platform.assign_attributes(platform_params)
    @platform.set_image(url_param: params['platform'], for: :image)
    if @platform.save
      flash[:success] = 'Platform successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'edit'
    end
  end

  def destroy
    if @platform.destroy
      flash[:success] = 'Platform successfully deleted!'
    else
      flash[:alert] = 'Platform unsuccessfully deleted!'
    end
    redirect_to :back
  end

  def new_import
  end

  def import
    Platform.import(platform_params[:file])
    redirect_to :back
  end

  def export
    @platform = Platform.find(params[:platform_id])

    begin
      temp_csv = Tempfile.new("temp_csv")
      temp_zip = Tempfile.new("temp_zip.zip")
      Zip::OutputStream.open(temp_zip) { |zos| }

      temp_csv.write(@platform.export)
      Zip::File.open(temp_zip.path, Zip::File::CREATE) do |zipfile|
        zipfile.add("data.csv", temp_csv)
        @platform.contained_images.each do |image|
          image_path = image.file.path

          if File.directory?(image_path)
            zipfile.add(image.file.url.split('/').last, image_path)
          end
        end
      end

      send_data(File.read(temp_zip.path), type: "application/zip", filename: "platform_export_#{@platform.title.downcase}.zip")
    ensure
      temp_csv.close
      temp_zip.close
    end
  end

  private

  def set_platform
    @platform = Platform.find(params[:id])
  end

  def platform_params
    params.require(:platform).permit(
      :title,
      :url,
      :page_title,
      :page_description,
      :file,
      :satellite_viewable,
      :origin_region,
      :archived,
      active_regions: []
    )
  end
end
