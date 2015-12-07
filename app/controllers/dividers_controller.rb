class DividersController < ApplicationController
  def new
    @platform = Platform.find(params[:platform_id])
    @divider  = Divider.new
  end

  def create
    @divider = Platform.find(params[:platform_id]).dividers.build(divider_params)
    if @divider.save
      flash[:notice] = 'You have successfully created Divider.'
      redirect_to platform_path(params[:platform_id])
    else
      render 'new'
    end
  end

  def select
    @platform = Platform.find(params[:platform_id])
    @divider  = @platform.dividers.build
    @dividers = Divider.where(platform_id: @platform.id)
  end

  def  select_to_edit
    if divider_params[:id] == 'none'
      redirect_to select_platform_dividers_path(Platform.find(params[:platform_id]))
    else
      @platform = Platform.find(params[:platform_id])
      @divider  = Divider.find(divider_params[:id])
    end
  end

  def update
    @divider = Divider.find(params[:id])
    @divider.assign_attributes(divider_params)
    if @divider.save
      flash[:notice] = 'You have successfully updated Divider.'
      redirect_to platform_path(params[:platform_id])
    else
      render('edit')
    end
  end

  def destroy
    Divider.find(params[:id]).destroy
    flash[:notice] = 'Divider was successfully deleted.'
    redirect_to platform_path(params[:platform_id])
  end

  private

  def divider_params
    params.require(:divider).permit(:id, :content)
  end
end
