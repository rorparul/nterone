class PlannedSubjectsController < ApplicationController
  def index
    @planned_subjects = current_user.planned_subjects.where(active: true)
    current_user.planned_subjects.where(active: true).update_all(read: true)
    @my_plan_count = current_user.new_my_plan_count
    @activities = PublicActivity::Activity.where("owner_id = ? OR recipient_id = ?", current_user.id, current_user.id).order(created_at: :desc)
  end

  def toggle
    planned_subject = PlannedSubject.where(planned_subject_params).first
    if current_user.member?
      notice = "Successfully added! Please navigate to #{view_context.link_to('My Plan', planned_subjects_path)} to manage and request a formal quote.".html_safe
    else
      notice = "Successfully added!"
    end
    if planned_subject == nil
      flash[:success] = notice
      @action = 'add'
      @planned_subject = PlannedSubject.create(planned_subject_params).subject
    else
      if planned_subject.active == false
        flash[:success] = notice
        @action = 'add'
        planned_subject.update_attributes(active: true)
        @planned_subject = planned_subject.subject
      else
        flash[:success] = "Successfully removed!"
        @action = 'remove'
        planned_subject.update_attributes(active: false, read: false)
        @planned_subject = planned_subject.subject
      end
    end

    @grand_total = User.find(planned_subject_params[:user_id]).my_plan_grand_total

    if current_user.member?
      @my_plan_count = current_user.new_my_plan_count
    end

    redirect_to :back
  end

  private

  def planned_subject_params
    params.require(:planned_subject).permit(:user_id, :subject_id, :status)
  end
end
