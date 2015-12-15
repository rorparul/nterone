class PlatformsController < ApplicationController
  before_action :set_platform, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  # before_action :authorize_platform, except: [:index, :show]
  # after_action  :verify_authorized,  except: [:index, :show]

  def index
    @platforms = Platform.all.eager_load(:image)
  end

  def show
    respond_to do |format|
      format.html do
        @categories = @platform.parent_categories.order(updated_at: :asc).includes(:children)
      end
      format.js do
        if params['type'] == 'all'
          @subjects = Category.find(params['cat']).children_subjects
        else
          @subjects = Category.find(params['cat']).subjects
        end
      end
    end
  end

  def new
    @platform = Platform.new
    @platform.build_image
  end

  def edit
    @platform.build_image unless @platform.image.present?
    # @platform = @platform
  end

  def create
    @platform = Platform.new(platform_params)
    @platform.set_image(url_param: params['platform'], for: :image)
    if @platform.save
      flash[:success] = "Platform successfully created!"
      redirect_to :back
    else
      flash[:alert] = "Platform unsuccessfully created!"
      render('new')
    end
  end

  def update
    @platform.assign_attributes(platform_params)
    @platform.set_image(url_param: params['platform'], for: :image)
    if @platform.save
      flash[:notice] = 'Platform successfully updated!'
      redirect_to(root_path)
    else
      flash[:alert] = 'Platform unsuccessfully updated!'
      render 'edit'
    end
  end

  def destroy
    if @platform.destroy
      flash[:success] = "Platform successfully deleted!"
    else
      flash[:alert] = "Platform unsuccessfully deleted!"
    end
    redirect_to :back
  end

  private

  def set_platform
    @platform = Platform.find(params[:id])
  end

  def platform_params
    params.require(:platform).permit(:title, :url)
  end

  def authorize_platform
    @platform ||= Platform.new
    authorize @platform
  end
end
