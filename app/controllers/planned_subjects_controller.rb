class PlannedSubjectsController < ApplicationController
  before_action :authenticate_user!
  
  def toggle
    planned_subject = PlannedSubject.where(planned_subject_params).first
    if current_user.member?
      notice = "Successfully added! Please navigate to #{view_context.link_to('My Plan', my_account_plan_path)} to manage and request a formal quote.".html_safe
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

    @grand_total = view_context.formatted_price_or_range_of_my_plan_for(User.find(planned_subject_params[:user_id]))

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
