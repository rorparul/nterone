class UsersController < ApplicationController
  before_action :authenticate_user!

  def page
    @users = User.order(:last_name).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @planned_subjects = @user.planned_subjects.where(active: true)
    @user.planned_subjects.where(active: true).update_all(read: true)
    @my_plan_count = @user.new_my_plan_count
    @activities = PublicActivity::Activity.where("owner_id = ? OR recipient_id = ?", @user.id, @user.id).order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def edit_from_my_queue
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      flash[:success] = 'User successfully updated!'
    else
      flash[:alert] = 'User unsuccessfully updated!'
    end
    redirect_to :back
  end

  def toggle_archived
    user = User.find(params[:id])
    user.toggle(:archived)
    if user.save
      flash[:success] = "User successfully #{user.archived ? 'archived' : 'unarchived'}!"
    else
      flash[:alert] = "User unsuccessfully #{user.archived ? 'unarchived' : 'archived'}"
    end
    redirect_to :back
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      flash[:success] = 'User successfully deleted!'
    else
      flash[:alert] = 'User unsuccessfully deleted!'
    end
    redirect_to :back
  end

  private

  def user_params
    params.require(:user).permit(:company_id,
                                 :first_name,
                                 :last_name,
                                 :contact_number,
                                 :country,
                                 :street,
                                 :city,
                                 :daily_rate,
                                 :state,
                                 :zipcode,
                                 :archived,
                                 :same_addresses,
                                 :billing_company,
                                 :billing_first_name,
                                 :billing_last_name,
                                 :billing_street,
                                 :billing_city,
                                 :billing_state,
                                 :billing_zip_code,
                                 :shipping_company,
                                 :shipping_first_name,
                                 :shipping_last_name,
                                 :shipping_street,
                                 :shipping_city,
                                 :shipping_state,
                                 :shipping_zip_code,
                                 :status,
                                 roles_attributes: [:id,
                                                    :role,
                                                    :_destroy])
  end
end
