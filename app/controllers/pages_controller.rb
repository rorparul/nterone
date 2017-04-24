class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :delete]
  before_action :set_page,           only: [:show, :edit, :update, :delete]

  def new
    authorize @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to admin_website_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
    authorize @page
  end

  def update
    if @page.update_attributes(page_params)
      flash[:success] = "Page successfully updated!"
      redirect_to admin_website_path
    else
      render 'edit'
    end
  end

  def delete
  end

  def cisco_learning_credits
    @page = Page.find_or_create_by(title: __method__.to_s.titleize, static: true)
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(
      :content,
      :page_description,
      :page_title,
      :theater,
      :title
    )
  end
end
