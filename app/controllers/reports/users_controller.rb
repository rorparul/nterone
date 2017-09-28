class Reports::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def new
    @owners = User.active_sales
  end

  def create
    @users = User.where(clean_params(report_params))
  end

  private

  def authorize_user
    authorize [:reports, :user]
  end

  def report_params
    permitted_params = params.require(:report).permit(
      :parent_id,
      :source_name,
      :status,
      :do_not_email,
      :do_not_call,
      :company_id,
      :state
    )
  end
end
