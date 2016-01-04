class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :autocomplete
  # before_action :authorize_category, except: :autocomplete
  # after_action  :verify_authorized,  except: :autocomplete

  def index
    @platform = Platform.find(params[:platform_id])
    @categories = @platform.categories.order(:id).eager_load(:parent, :children)
  end

  def show
  end

  def new
    @platform = Platform.find(params[:platform_id])
    @category = @platform.categories.build
  end

  def select
    @platform   = Platform.find(params[:platform_id])
    @category   = @platform.categories.build
    @categories = Category.where(platform_id: Platform.find(params[:platform_id]))
  end

  def select_to_edit
    if category_params[:id] == 'none'
      redirect_to select_platform_categories_path(Platform.find(params[:platform_id]))
    else
      @platform = Platform.find(params[:platform_id])
      @category = Category.find(category_params[:id])
    end
  end

  def create
    @platform = Platform.find(params[:platform_id])
    @category = @platform.categories.build(category_params)
    if @category.save
      flash[:success] = 'Category successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def update
    @platform = Platform.find(params[:platform_id])
    if @category.update_attributes(category_params)
      flash[:success] = 'Category successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'select_to_edit'
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = 'Category successfully deleted!'
    else
      flash[:alert] = 'Category unsuccessfully deleted!'
    end
    redirect_to :back
  end

  private

    def set_category
      @category = Category.includes(:platform).find(params[:id])
    end

    def category_params
      params.require(:category).permit(:id, :title, :parent_id)
    end

    def authorize_category
      @category ||= Category.new
      authorize @category
    end
end
