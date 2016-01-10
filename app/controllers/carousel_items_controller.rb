class CarouselItemsController < ApplicationController
  before_action :redirect_if_not_permitted, only: [:new, :edit]
  before_action :set_carousel_item, except: [:new, :create, :page]

  def new
    @carousel_item = CarouselItem.new
    @carousel_item.build_image
  end

  def page
    @carousel_items = CarouselItem.page(params[:page])
  end

  def create
    @carousel_item = CarouselItem.new(carousel_item_params)
    @carousel_item.set_image(url_param: params['carousel_item'], for: :image)
    if @carousel_item.save
      flash[:success] = "Carousel Item successfully created!"
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def edit
    @carousel_item.build_image unless @carousel_item.image.present?
  end

  def update
    @carousel_item.assign_attributes(carousel_item_params)
    @carousel_item.set_image(url_param: params['carousel_item'], for: :image)
    if @carousel_item.save
      flash[:notice] = 'Carousel Item successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'edit'
    end
  end

  def destroy
    if @carousel_item.destroy
      flash[:success] = "Carousel Item successfully deleted!"
    else
      flash[:alert] = "Carousel Item unsuccessfully deleted!"
    end
    redirect_to :back
  end

  private

  def carousel_item_params
    params.require(:carousel_item).permit(:caption, :active, :url)
  end

  def set_carousel_item
    @carousel_item = CarouselItem.find(params[:id])
  end

  def redirect_if_not_permitted
    redirect_to root_path if !user_signed_in? || !current_user.admin?
  end
end
