class Lms::StudentsController < Lms::BaseController
  before_action :authenticate_user!
  before_action :set_student, only: [:show]

  def index
    authorize :lms_student, :index?
    @students = User.lms_students_all
  end

  def show
    authorize :lms_student, :show?
    @courses = @student.assigned_vods
  end

private

  def set_student
    @student = User.find(params[:id])
  end
end
