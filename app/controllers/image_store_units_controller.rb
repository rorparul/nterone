class ImageStoreUnitsController < ApplicationController
  before_action :authenticate_user!,   only: [:new, :create, :edit, :update, :destroy]
  before_action :set_image_store_unit, only: [:show, :edit, :update, :destroy]

  def new
    @image_store_unit = ImageStoreUnit.new
    @image_store_unit.build_image
  end

  def create
    @image_store_unit = ImageStoreUnit.new(image_store_unit_params)
    @image_store_unit.set_image(url_param: params['image_store_unit'], for: :image)
    if @image_store_unit.save
      flash[:success] = "Image successfully created!"
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def edit
    @image_store_unit.build_image unless @image_store_unit.image.present?
  end

  def update
    @image_store_unit.assign_attributes(image_store_unit_params)
    @image_store_unit.set_image(url_param: params['image_store_unit'], for: :image)
    if @image_store_unit.save
      flash[:notice] = 'Image successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'edit'
    end
  end

  def destroy
    if @image_store_unit.destroy
      flash['success'] = 'Image successfully deleted!'
    else
      flash['alert'] = 'Image unsuccessfully deleted!'
    end
    redirect_to :back
  end

  def show
    render :layout => false
  end

  private

  def set_image_store_unit
    @image_store_unit = ImageStoreUnit.find(params[:id])
  end

  def image_store_unit_params
    params.require(:image_store_unit).permit(:id, :title)
  end
end
