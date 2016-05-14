class Lms::StudentAssigmentsController < Lms::BaseController
  before_action :authenticate_user!
  before_action :set_student, only: [:index]

  def index
    authorize :lms_student_assigment, :index?

    @assigments = @student.assigned_vods
    @assignable_courses = VideoOnDemand.lms - @student.assigned_vods
  end

private

  def set_student
    @student = User.find(params[:student_id])
  end
end
