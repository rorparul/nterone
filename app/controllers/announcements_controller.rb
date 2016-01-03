class AnnouncementsController < ApplicationController
  def create
    announcement = Announcement.new(announcement_params)
    case announcement.audience
    when 'Members'
      Role.where(role: 4).each do |role|
        announcement.messages.build(user_id: role.user.id)
      end
    when 'Sales Managers'
      Role.where(role: 2).each do |role|
        announcement.messages.build(user_id: role.user.id)
      end
    when 'Sales'
      Role.where(role: 3).each do |role|
        announcement.messages.build(user_id: role.user.id)
      end
    when 'All'
      User.all.each do |user|
        announcement.messages.build(user_id: user.id)
      end
    when 'Members & Sales'
      Role.where(role: [2, 3]).each do |role|
        announcement.messages.build(user_id: role.user.id)
      end
    end

    if announcement.save
      flash[:success] = "Announcement successfully created!"
    else
      flash[:alert] = "Announcement unsuccessfully created!"
    end

    redirect_to :back
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(announcement_params[:id])
    if @announcement.update_attributes(announcement_params)
      flash[:success] = "Announcement successfully updated!"
      render js: "window.location = '#{request.referrer}';"
    else
      render 'edit'
    end
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
