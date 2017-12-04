class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :cisco_self_paced]
  before_action :set_category,       only: [:show, :update, :destroy]

  def index
    @platform = Platform.find(params[:platform_id])
    @categories = @platform.categories.order(:id).eager_load(:parent, :children)
  end

  def show
    session[:last_category_url] = request.url

    @platform   = Platform.find(params[:platform_id])
    @categories = @platform.parent_categories.order(:position).includes(:children)
    @items = category_items(@category)

    render 'platforms/show'
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
    redirect_to platform_category_path(@category.platform, Category.parent_categories.first)
  end

  def cisco_self_paced
    session[:last_category_url] = request.url

    @platform   = Platform.active.find_by(title: "Cisco")
    @category   = @platform.categories.find_by(title: "Self-Paced")
    @categories = @platform.parent_categories.order(:position).includes(:children)
    @items      = category_items(@category)

    render 'platforms/show'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_items(category)
    items = category.items + category.children_items

    return items if current_user.try(:lms?)
    items.select { |item| item.class.name != 'VideoOnDemand' || !item.lms }
  end

  def category_params
    params.require(:category).permit(
      :id,
      :parent_id,
      :title,
      :page_title,
      :heading,
      :description,
      :meta_description,
      :position,
      :video
    )
  end
end
