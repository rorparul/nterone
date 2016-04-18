class RolesController < ApplicationController
  before_action :authenticate_user!

  respond_to :html

  def change_role
    role = Role.find_by(user_id: role_params[:user_id])
    if role.update_attributes(role_params)
      flash[:success] = 'Role successfully changed!'
    else
      flash[:alert] = 'Role unsuccessfully changed!'
    end
    redirect_to :back
  end

  private

  def role_params
    params.require(:role).permit(:id, :user_id, :role)
  end
end
