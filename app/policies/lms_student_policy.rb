class LmsStudentPolicy < Struct.new(:user, :lms_student)
  def index?
    user.lms_manager?
  end

  def show?
    user.lms_manager?
  end
end
