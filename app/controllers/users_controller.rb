class UsersController < ApplicationController
  def index
    unless params[:filter] == 'archived'
      @filter               = 'none'
      @users                = brand.users.where(archived: false).order(created_at: :asc)
      @users_count          = @users.count
      @archived_users_count = brand.users.where(archived: true).count
    else
      @filter      = 'archived'
      @users       = brand.users.where(archived: true).order(created_at: :asc)
      @users_count = @users.count
    end
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
    if user.update_without_password(user_params)
      flash[:success] = "User successfully updated!"
      redirect_to :back
    else
      flash[:alert] = "User failed to update!"
      redirect_to :back
    end
  end

  def toggle_archived
    user = User.find(params[:id])
    user.toggle(:archived)
    if user.save
      flash[:success] = "User successfully #{user.archived ? 'archived' : 'unarchived'}!"
    else
      flash[:alert] = "User failed to archive!"
    end
    redirect_to :back
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      flash[:success] = "User successfully deleted!"
    else
      flash[:alert] = "User failed to delete!"
    end
    redirect_to :back
  end

  private

  def user_params
    params.require(:user).permit(:company_name,
                                 :first_name,
                                 :last_name,
                                 :email,
                                 :contact_number,
                                 :country,
                                 :street,
                                 :city,
                                 :state,
                                 :zipcode,
                                 :archived)
  end
end
