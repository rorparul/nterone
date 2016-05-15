class Lms::BusinessController < Lms::BaseController
  before_action :authenticate_user!

  def index
    authorize :lms_business, :index?
    @students = User.lms_students_all
  end
end
