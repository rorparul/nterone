class Admin::BaseController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  include SmartListingConcerns
  include MessageManager

  before_action :authenticate_user!
  before_action :validate_authorization

  layout 'admin'

  respond_to :json

  private

  def validate_authorization
    unless current_user.admin? || current_user.sales? || current_user.partner?
      redirect_to root_path
    end
  end
end
