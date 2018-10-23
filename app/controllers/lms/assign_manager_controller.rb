class Lms::AssignManagerController < ApplicationController
  before_action :authenticate_user!

  def index
    @managers = User.lms_managers_all
  end

  def create
    lms_managed_student = LmsManagedStudent.new(assign_manager_params)

    if lms_managed_student.save
      flash[:success] = "You were successfully assigned to #{lms_managed_student.manager.full_name}."
      redirect_to lms_student_path(current_user)
    else
      flash[:alert] = 'Could not assign to manager.'
      redirect_to :back
    end
  end

  private

  def assign_manager_params
    params.require(:assign_manager).permit(:user_id, :manager_id)
  end
end
