class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_page,           only: [:edit, :update, :destroy]
  before_action :authorize_page,     only: [:new, :create, :edit, :update, :destroy]

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
    @page = Page.find(params[:id])
  end

  def edit
    @page
  end

  def update
    if @page.update_attributes(page_params)
      flash[:success] = "Page successfully updated!"
      redirect_to admin_marketing_path
    else
      render 'edit'
    end
  end

  def destroy
    if @page.destroy
      flash[:success] = "Page successfully deleted!"
    else
      flash[:alert] = "Page failed to delete!"
    end
    redirect_to :back
  end

  def cisco_learning_credits
    @page = Page.current_region.find_by(title: __method__.to_s.titleize)
  end

  private

  def set_page
    @page = Page.unscoped.find(params[:id])
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
