class LmsExportPolicy < Struct.new(:user, :lms_export)
  def grades?
    user.lms_business?
  end

  def progress?
    user.lms_business?
  end
end
