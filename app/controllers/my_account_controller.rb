class MyAccountController < ApplicationController
  def plan
    @planned_subjects = current_user.planned_subjects.where(active: true)
    current_user.planned_subjects.where(active: true).update_all(read: true)
    @my_plan_count = current_user.new_my_plan_count
    @activities = PublicActivity::Activity.where("owner_id = ? OR recipient_id = ?", current_user.id, current_user.id).order(created_at: :desc)
  end

  def messages
    @messages = Message.active(current_user)
  end

  def settings
    @user = current_user
  end
end
