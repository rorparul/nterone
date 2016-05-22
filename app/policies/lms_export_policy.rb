class LmsExportPolicy < Struct.new(:user, :lms_export)
  def grades?
    user.lms_business? || user.lms_manager?
  end

  def progress?
    user.lms_business? || user.lms_manager?
  end
end
