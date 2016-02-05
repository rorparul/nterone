class PressReleasesController < ApplicationController
  def new
    @press_release = PressRelease.new
  end

  def create
    @press_release = PressRelease.new(press_releases_params)
    if @press_release.save(press_releases_params)
      flash[:success] = "Press Release successfully added."
      # render js: "window.location = '#{my_admin_website_path}';"
      redirect_to my_admin_website_path
    else
      render 'new'
    end
  end

  def page
    @press_releases = PressRelease.page(params[:page]).per(5)
  end

  def show
    @press_release = PressRelease.find(params[:id])
  end

  def edit
    @press_release = PressRelease.find(params[:id])
  end

  def update
    @press_release = PressRelease.find(params[:id])
    if @press_release.update_attributes(press_releases_params)
      flash[:success] = "Press Release successfully updated."
      # render js: "window.location = '#{my_admin_website_path}';"
      redirect_to my_admin_website_path
    else
      render 'edit'
    end
  end

  def destroy
    if PressRelease.find(params[:id]).destroy
      flash[:success] = "Press Release successfully deleted."
    else
      flash[:alert] = "Press Release failed to delete."
    end
    redirect_to :back
  end

  private

  def press_releases_params
    params.require(:press_release).permit(:page_title, :title, :content)
  end
end
