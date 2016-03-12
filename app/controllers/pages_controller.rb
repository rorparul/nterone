class PagesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_page, except: [:new, :create]

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to my_admin_website_path
    else
      render 'new'
    end
  end

  def show

  end

  def edit

  end

  def update
    if @page.update_attributes(page_params)
      flash[:success] = "Page successfully updated!"
      redirect_to my_admin_website_path
    else
      render 'edit'
    end
  end

  def delete

  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title,
                                 :content,
                                 :bootsy_image_gallery_id,
                                 :page_title,
                                 :page_description)
  end
end
