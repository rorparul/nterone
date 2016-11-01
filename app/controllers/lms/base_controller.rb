class Lms::BaseController < ApplicationController
  before_action :authenticate_lms
  layout 'lms'

  private
  
  def authenticate_lms
    redirect_to root_path if !lms_path?
  end

  def lms_path?
    path = request.referer || request.path
    path.include?('/lms')
  end
end
