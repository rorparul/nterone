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

  def  select_to_edit
    if category_params[:id] == 'none'
      redirect_to select_platform_categories_path(Platform.find(params[:platform_id]))
    else
      @platform = Platform.find(params[:platform_id])
      @category = Category.find(category_params[:id])
    end
  end

  def create
    @category = Platform.find(params[:platform_id]).categories.build(category_params)
    if @category.save
      flash[:notice] = 'You have successfully created category.'
      redirect_to platform_path(params[:platform_id])
    else
      render 'new'
    end
  end

  def update
    @category.assign_attributes(category_params)
    if @category.save
      flash[:notice] = 'You have successfully updated category.'
      redirect_to platform_path(params[:platform_id])
    else
      render('edit')
    end
  end

  def destroy
    if params['remove_child'] == 'yes'
      @category.children.destroy_all
    else
      @category.children.update_all(parent_id: nil)
    end
    @category.destroy
    flash[:notice] = 'Category was successfully deleted.'
    redirect_to platform_path(params[:platform_id])
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
