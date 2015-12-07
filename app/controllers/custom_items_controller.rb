class CustomItemsController < ApplicationController
  def new
    @platform    = Platform.find(params[:platform_id])
    @custom_item = CustomItem.new
  end

  def create
    @custom_item = Platform.find(params[:platform_id]).custom_items.build(custom_item_params)
    if @custom_item.save
      flash[:notice] = 'You have successfully created Custom Item.'
      redirect_to platform_path(params[:platform_id])
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
    if custom_item_params[:id] == 'none'
      redirect_to select_platform_custom_items_path(Platform.find(params[:platform_id]))
    else
      @platform    = Platform.find(params[:platform_id])
      @custom_item = CustomItem.find(custom_item_params[:id])
    end
  end

  def update
    @custom_item = CustomItem.find(params[:id])
    @custom_item.assign_attributes(custom_item_params)
    if @custom_item.save
      flash[:notice] = 'You have successfully updated Custom Item.'
      redirect_to platform_path(params[:platform_id])
    else
      render('edit')
    end
  end

  def destroy
    CustomItem.find(params[:id]).destroy
    flash[:notice] = 'Custom Item was successfully deleted.'
    redirect_to platform_path(params[:platform_id])
  end

  private

  def custom_item_params
    params.require(:custom_item).permit(:id, :content, :shortname, :url, :is_header)
  end
end
