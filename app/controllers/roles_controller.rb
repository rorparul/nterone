class RolesController < ApplicationController
  respond_to :html

  # def roles
  #   @user = User.joins(:user_info).where(id:params[:id]).first
  #   @brand_user = BrandUser.where(user_id:params[:id], brand_id:brand.id).first
  #   if !@brand_user
  #     @brand_user = BrandUser.new
  #     @brand_user.brand_id = brand.id
  #     @brand_user.user_id = current_user.id
  #     @brand_user.save
  #   end
  # end

  def change_role
    role = Role.find_by(user_id: role_params[:user_id])
    if role.update_attributes(role_params)
      flash[:success] = "Role successfully changed!"
    else
      flash[:alert] = "Role unsuccessfully changed!"
    end
    redirect_to :back
  end

  private

  def role_params
    params.require(:role).permit(:id, :user_id, :role)
  end
end
