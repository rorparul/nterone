class LmsStudentAssignmentPolicy < Struct.new(:user, :lms_student_assignment)
  def index?
    user.lms_manager?
  end
end
