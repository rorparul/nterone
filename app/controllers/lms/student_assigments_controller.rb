class Lms::StudentAssigmentsController < Lms::BaseController
  before_action :authenticate_user!
  before_action :set_student, only: [:index]

  def index
    authorize :lms_student_assigment, :index?

    @courses = VideoOnDemand.lms
  end

private

  def set_student
    @student = User.find(params[:student_id])
  end
end
