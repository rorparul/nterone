class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :delete]
  before_action :set_page,           only: [:show, :edit, :update, :delete]
  before_action :authorize_page,     only: [:new, :create, :edit, :update, :delete]

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to admin_marketing_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
    @page
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
      :origin_region,
      :title,
      active_regions: []
    )
  end

  def authorize_page
    @page ||= Page.new
		authorize @page
  end
end
