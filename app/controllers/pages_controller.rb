class PagesController < ApplicationController
  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(page_params)
      flash[:success] = "Page successfully updated!"
      # render js: "window.location = '#{my_admin_website_path}';"
      redirect_to my_admin_website_path
    else
      render 'edit'
    end
  end

  private

  def page_params
    params.require(:page).permit(:title, :content, :bootsy_image_gallery_id, :page_title)
  end
end
