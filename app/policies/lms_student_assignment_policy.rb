class LmsStudentAssignmentPolicy < Struct.new(:user, :lms_student_assignment)
  def index?
    user.lms_manager?
  end

  def assign?
    user.lms_student?
  end
end
