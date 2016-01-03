class DividersController < ApplicationController
  def new
    @platform = Platform.find(params[:platform_id])
    @divider  = Divider.new
  end

  def create
    @platform = Platform.find(params[:platform_id])
    @divider  = @platform.dividers.build(divider_params)
    if @divider.save
      flash[:success] = 'Divider successfully created!'
      render js: "window.location = '#{request.referrer}';"
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
      flash[:success] = 'Divider successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      @platform = Platform.find(params[:platform_id])
      render 'select_to_edit'
    end
  end

  def destroy
    divider = Divider.find(params[:id])
    if divider.destroy
      flash[:success] = 'Divider successfully deleted!'
    else
      flash[:alert] = 'Divider unsuccessfully updated!'
    end
    redirect_to :back
  end

  private

  def divider_params
    params.require(:divider).permit(:id, :content)
  end
end
