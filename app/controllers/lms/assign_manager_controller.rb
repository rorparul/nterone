class Lms::AssignManagerController < Lms::BaseController
  before_action :authenticate_user!

  def index
    @managers = User.lms_managers_all
  end

  def create
    binding.pry
  end

private
  def assign_manager_params
    params.require(:assign_manager).permit(:manager_id)
  end
end
