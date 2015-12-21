class AnnouncementsController < ApplicationController
  def create
    @announcement = Announcement.create(announcement_params)
    case @announcement.audience
    when 'Members'
      Role.where(role: 4).each do |role|
        role.user.messages.create(announcement_id: @announcement.id)
      end
    when 'Sales Managers'
      Role.where(role: 2).each do |role|
        role.user.messages.create(announcement_id: @announcement.id)
      end
    when 'Sales'
      Role.where(role: 3).each do |role|
        role.user.messages.create(announcement_id: @announcement.id)
      end
    when 'All'
      User.all.each do |user|
        user.messages.create(announcement_id: @announcement.id)
      end
    when 'Members & Sales'
      Role.where(role: [2, 3]).each do |role|
        role.user.messages.create(announcement_id: @announcement.id)
      end
    end
    redirect_to :back
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(announcement_params[:id])
    if !announcement_params[:content]
      @announcement.status = announcement_params[:status]
      @announcement.save
    else
      @announcement.content = announcement_params[:content]
      @announcement.save
    end
    redirect_to :back
  end

  def destroy
    announcement = Announcement.find(params[:id])
    if announcement.destroy
      flash[:success] = "Announcement successfully deleted!"
    else
      flash[:alert] = "Announcement unsuccessfully deleted!"
    end
    redirect_to :back
  end

  private

  def announcement_params
    params.require(:announcement).permit(:id, :content, :audience, :status, :poster)
  end
end
