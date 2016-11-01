class Lms::StudentCoursesController < Lms::BaseController
  before_action :authenticate_user!
  before_action :set_student, only: [:show]
  before_action :set_course, only: [:show]

  def show
    authorize :lms_student_course, :show?

    @attempts = @course.exam_attempts_for(@student).order('created_at DESC')
  end

  private

  def set_student
    @student = User.find(params[:student_id])
  end

  def set_course
    @course = VideoOnDemand.find(params[:id])
  end
end
