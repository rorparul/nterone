class PlatformsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_platform, only: [:show, :edit, :update, :destroy]

  def index
    @page      = Page.find_by(title: 'Vendor Index')
    @platforms = Platform.order(:title).eager_load(:image)
  end

  def show
    redirect_to session[:last_category_url]
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

  private

  def set_platform
    @platform = Platform.find(params[:id])
  end

  def platform_params
    params.require(:platform).permit(:title, :url, :page_title, :page_description)
  end
end
