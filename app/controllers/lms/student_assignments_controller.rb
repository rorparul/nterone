class Lms::StudentAssignmentsController < Lms::BaseController
  before_action :authenticate_user!
  before_action :set_student

  def index
    authorize :lms_student_assignment, :index?

    @assignments = @student.assigned_vods
    @assignable_courses = VideoOnDemand.lms - @student.assigned_vods
  end

  def create
    item = VideoOnDemand.find(assigned_item_params[:course_id])
    assigned_item = AssignedItem.new(item: item, student: @student, assigner: current_user)

    if assigned_item.save
      flash[:success] = "#{item.title} was successfully assigned to #{@student.full_name}"
      redirect_to :back
    else
      flash[:alert] = 'could not assign item'
      redirect_to :back
    end
  end

private

  def set_student
    @student = User.find(params[:student_id])
  end

  def assigned_item_params
    params.require(:assigned_item).permit(:course_id)
  end
end
