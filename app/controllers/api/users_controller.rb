class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :show

  def show
    authorize :api_user, :show?
    render json: @user
  end

private
  def set_user
    @user = User.find(params[:id])
  end
end
