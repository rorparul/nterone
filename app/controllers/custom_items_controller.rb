class CustomItemsController < ApplicationController
  def new
    @platform    = Platform.find(params[:platform_id])
    @custom_item = @platform.custom_items.build
  end

  def create
    @platform    = Platform.find(params[:platform_id])
    @custom_item = @platform.custom_items.build(custom_item_params)
    if @custom_item.save
      flash[:success] = 'Custom Item successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def select
    @platform     = Platform.find(params[:platform_id])
    @custom_item  = @platform.custom_items.build
    @custom_items = CustomItem.where(platform_id: @platform.id, is_header: false)
  end

  def  select_to_edit
    @platform     = Platform.find(params[:platform_id])
    if custom_item_params[:id] == 'none'
      @custom_item  = @platform.custom_items.build
      @custom_items = CustomItem.where(platform_id: @platform.id, is_header: false)
    else
      @custom_item = CustomItem.find(custom_item_params[:id])
    end
  end

  def update
    @custom_item = CustomItem.find(params[:id])
    @custom_item.assign_attributes(custom_item_params)
    if @custom_item.save
      flash[:success] = 'Custom Item successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      @platform = Platform.find(params[:platform_id])
      render 'select_to_edit'
    end
  end

  def destroy
    custom_item = CustomItem.find(params[:id])
    if custom_item.destroy
      flash[:success] = 'Custom Item successfully deleted!'
    else
      flash[:alert] = 'Custom Item unsuccessfully deleted!'
    end
    redirect_to :back
  end

  private

  def custom_item_params
    params.require(:custom_item).permit(:id, :content, :shortname, :url, :is_header, :bootsy_image_gallery_id)
  end
end
