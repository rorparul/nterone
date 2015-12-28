class PagesController < ApplicationController
  # def new
  #   @page = Page.new
  # end
  #
  # def create
  #   @page = Page.new(page_params)
  #   if @page.save
  #     flash[:success] = "Page successfully created!"
  #     render js: "window.location = '#{my_admin_website_path}';"
  #   else
  #     render 'new'
  #   end
  # end
  #
  # def index
  #
  # end
  #
  # def show
  #
  # end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(page_params)
      flash[:success] = "Page successfully updated!"
      render js: "window.location = '#{my_admin_website_path}';"
    else
      render 'edit'
    end
  end

  # def destroy
  #
  # end

  private

  def page_params
    params.require(:page).permit(:title, :content)
  end
end
