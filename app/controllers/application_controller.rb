class ApplicationController < ActionController::Base
  include Pundit
  include PublicActivity::StoreController

  protect_from_forgery with: :exception
  before_filter        :configure_permitted_parameters, if: :devise_controller?
  before_action        :record_user_activity

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def record_user_activity
    current_user.touch(:last_active_at) if user_signed_in?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |user|
      user.permit(:first_name,
                  :last_name,
                  :email,
                  :password,
                  :password_confirmation)
    end

    devise_parameter_sanitizer.for(:account_update) do |user|
      user.permit(:company_name,
                  :first_name,
                  :last_name,
                  :email,
                  :password,
                  :password_confirmation,
                  :contact_number,
                  :country,
                  :street,
                  :city,
                  :state,
                  :zipcode)
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def pundit_user
    # @pu ||= BrandUser.includes(:user).find_by(user_id: current_user.id, brand_id: brand.id) || current_user
  end
end
