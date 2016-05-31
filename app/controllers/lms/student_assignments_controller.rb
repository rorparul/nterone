class Lms::StudentAssignmentsController < Lms::BaseController
  before_action :authenticate_user!, except: :assign
  before_action :set_student, except: :assign
  before_action :set_assignment, only: :destroy

  def index
    authorize :lms_student_assignment, :index?

    @assignments = @student.assigned_items
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

  def destroy
    if @assignment.destroy
      flash[:success] = 'assignment was destroyed successfully'
    else
      flash[:alert] = 'could not destroy assignment'
    end

    redirect_to :back
  end

  def assign
    return redirect_to lms_path unless user_signed_in?
    authorize :lms_student_assignment, :assign?

    vod = VideoOnDemand.friendly.find(params[:item_id])
    assignment = Assignment::CreateService.new(nil, current_user, vod).call

    if assignment.success?
      flash[:success] = 'assigned successfully'
    else
      flash[:alert] = 'could not create assignment'
    end

    redirect_to lms_student_path(current_user)
  end

private

  def set_student
    @student = User.find(params[:student_id])
  end

  def set_assignment
    @assignment = AssignedItem.find(params[:id])
  end

  def assigned_item_params
    params.require(:assigned_item).permit(:course_id)
  end
end
