class CarouselItemsController < ApplicationController
  before_action :set_carousel_item, except: [:new, :create, :page]

  def new
    @carousel_item = CarouselItem.new
    @carousel_item.build_image
  end

  def page
    @carousel_items = CarouselItem.page(params[:page]).per(5)
  end

  def create
    @carousel_item = CarouselItem.new(carousel_item_params)
    @carousel_item.set_image(url_param: params['carousel_item'], for: :image)
    if @carousel_item.save
      flash[:success] = "Carousel Item successfully created!"
      redirect_to :back
    else
      flash[:alert] = "Carousel Item unsuccessfully created!"
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
      redirect_to :back
    else
      flash[:alert] = "Carousel Item unsuccessfully updated!"
      render('edit')
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
    params.require(:carousel_item).permit(:caption, :active)
  end

  def set_carousel_item
    @carousel_item = CarouselItem.find(params[:id])
  end
end
