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
    leads_path
  end
end
