class RolesController < ApplicationController
  respond_to :html

  def roles
    @user = User.joins(:user_info).where(id:params[:id]).first
    @brand_user = BrandUser.where(user_id:params[:id], brand_id:brand.id).first
    if !@brand_user
      @brand_user = BrandUser.new
      @brand_user.brand_id = brand.id
      @brand_user.user_id = current_user.id
      @brand_user.save
    end
  end

  def change_role
    brand_user = BrandUser.find_by(user_id: brand_user_params[:user_id])
    if brand_user.update_attributes(brand_user_params)
      flash[:success] = "Role successfully changed!"
    else
      flash[:alert] = "Role unsuccessfully changed!"
    end
    redirect_to :back
  end

  private

  def brand_user_params
    params.require(:brand_user).permit(:id, :brand_id, :user_id, :role)
  end
end
