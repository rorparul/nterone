class Users::InvitationsController < Devise::InvitationsController
  def create
    if not_invited?
      super
      Role.create(user_id: @user.id)
      if current_user.sales_manager?
        Lead.create(buyer_id: @user.id)
      elsif current_user.sales?
        Lead.create(seller_id: current_user.id, status: 'assigned')
      end

      flash[:success] = 'Successfully Saved!' if skip_invitation?
    else
      flash[:alert] = 'User with specified email is already invited'
      redirect_to :back
    end
  end

  def resend
    if params[:id].present?
      user = User.find_by(id: params[:id])
      user.invite! if user.present?
      flash[:success] = 'Invitation resent!' if user.present?
    end

    redirect_to admin_people_path
  end

  def after_invite_path_for(resource)
    admin_people_path
  end

  private

  # this is called when creating invitation
  # should return an instance of resource class
  def invite_resource
    ## skip sending emails on invite
    super do |u|
      u.skip_invitation = skip_invitation?
    end
  end

  def not_invited?
    if invite_params[:email].present?
      !User.where(email: invite_params[:email]).present?
    end
  end

  def skip_invitation?
    params[:skip_invitation] == 'true' ? true : false
  end

  def invite_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end
end
