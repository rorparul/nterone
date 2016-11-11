class LmsBusinessPolicy < Struct.new(:user, :lms_business)
  def index?
    user.lms_business?
  end
end
