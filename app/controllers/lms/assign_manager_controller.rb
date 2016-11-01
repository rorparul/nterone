class Lms::AssignManagerController < Lms::BaseController
  before_action :authenticate_user!

  def index
    @managers = User.lms_managers_all
  end

  def create
    lms_managed_student = LmsManagedStudent.new(
      user: current_user,
      manager_id: assign_manager_params[:manager_id]
    )

    if lms_managed_student.save
      flash[:success] = "you were successfully assigned to #{lms_managed_student.manager.full_name}"
      redirect_to lms_student_path(current_user)
    else
      flash[:alert] = 'could not assign to manager'
      redirect_to :back
    end
  end

  private
  
  def assign_manager_params
    params.require(:assign_manager).permit(:manager_id)
  end
end
