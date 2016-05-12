class Users::InvitationsController < Devise::InvitationsController
  def create
    super
    Role.create(user_id: @user.id)
    if current_user.sales_manager?
      Lead.create(buyer_id: @user.id)
    elsif current_user.sales?
      Lead.create(seller_id: current_user.id, status: 'assigned')
    end
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
      u.skip_invitation = params[:skip_invitation] == 'true' ? true : false
    end
  end
end
