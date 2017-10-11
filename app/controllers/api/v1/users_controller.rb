class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!

  def show
    @user = current_user
    respond_with @user
  end

end
