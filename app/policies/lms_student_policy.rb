class LmsStudentPolicy < Struct.new(:user, :lms_student)
  def index?
    user.lms_manager?
  end

  def show?
    user.lms_student? || user.lms_manager? || user.lms_business?
  end
end
