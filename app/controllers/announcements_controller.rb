class AnnouncementsController < ApplicationController
  def create
    @announcement = Announcement.create(announcement_params)
    case @announcement.audience
    when 'Members'
      BrandUser.where(brand_id: brand.id, role: 1).each do |brand_user|
        brand_user.user.messages.create(announcement_id: @announcement.id)
      end
    when 'Sales Managers'
      BrandUser.where(brand_id: brand.id, role: 3).each do |brand_user|
        brand_user.user.messages.create(announcement_id: @announcement.id)
      end
    when 'Sales'
      BrandUser.where(brand_id: brand.id, role: 2).each do |brand_user|
        brand_user.user.messages.create(announcement_id: @announcement.id)
      end
    when 'All'
      BrandUser.where(brand_id: brand.id).each do |brand_user|
        brand_user.user.messages.create(announcement_id: @announcement.id)
      end
    when 'Members & Sales'
      BrandUser.where(brand_id: brand.id, role: [2, 3]).each do |brand_user|
        brand_user.user.messages.create(announcement_id: @announcement.id)
      end
    end
  end

  def index
    if current_user.sales_manager?
      @announcements = brand.announcements.where(poster: 'Sales Manager').order('created_at DESC')
    else
      @announcements = brand.announcements.order('created_at DESC')
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(announcement_params[:id])
    if !announcement_params[:content]
      @announcement.status = announcement_params[:status]
      @announcement.save
      render nothing: true
    else
      @announcement.content = announcement_params[:content]
      @announcement.save
    end
  end

  def destroy
    announcement = Announcement.find(params[:id])
    if announcement.destroy
      flash[:success] = "Successfully deleted announcement!"
    else
      flash[:alert] = "Failed to delete announcement!"
    end
    redirect_to :back
  end

  private

  def announcement_params
    params.require(:announcement).permit(:id, :brand_id, :content, :audience, :status, :poster)
  end
end
