class Lms::ExportController < Lms::BaseController
  before_action :authenticate_user!

  def grades
    authorize :lms_export, :grades?
    render json: { sucess: true }
  end

  def progress
    authorize :lms_export, :progress?
    render json: { sucess: true }
  end
end
