class MyAccountController < ApplicationController
  include MessageManager

  before_action :authenticate_user!
  before_action :validate_authorization

  def plan
    @planned_subjects = current_user.planned_subjects.where(active: true)
    current_user.planned_subjects.where(active: true).update_all(read: true)
    @my_plan_count = current_user.new_my_plan_count
    @activities = PublicActivity::Activity.where("owner_id = ? OR recipient_id = ?", current_user.id, current_user.id).order(created_at: :desc)
    @courses = current_user.assigned_vods
  end

  def messages
    @messages = Message.active(current_user)
    mark_messages_read(current_user)
    get_alert_counts
  end

  private

  def validate_authorization
    unless current_user.member?
      redirect_to root_path
    end
  end
end
