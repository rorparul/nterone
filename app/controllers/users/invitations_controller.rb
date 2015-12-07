class Users::InvitationsController < Devise::InvitationsController
  def create
    super
    BrandUser.create(brand_id: brand.id, user_id: @user.id)
    if current_user.sales_manager?
      brand.leads.create(buyer_id: @user.id)
    elsif current_user.sales?
      brand.leads.create(seller_id: current_user.id, buyer_id: @user.id, status: 'assigned')
    end
  end

  def after_invite_path_for(resource)
    leads_path
  end
end
