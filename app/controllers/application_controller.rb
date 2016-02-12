class ApplicationController < ActionController::Base
  include Pundit
  include PublicActivity::StoreController
  include CurrentCart

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :record_user_activity
  before_action :set_cart
  before_action :get_alert_counts

  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def get_alert_counts
    if user_signed_in?
      @new_message_count = current_user.new_message_count
      @total_alert_count = @new_message_count
    end
  end

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
      user.permit(:email,
                  :current_password,
                  :password,
                  :password_confirmation)
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
