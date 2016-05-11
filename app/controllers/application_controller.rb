class ApplicationController < ActionController::Base
  include Pundit
  include PublicActivity::StoreController
  include CurrentCart

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :record_user_activity
  before_action :set_cart
  before_action :get_alert_counts
  before_action :update_request_urls
  after_filter  :store_location

  helper_method :forem_user, :resource_name, :resource, :devise_mapping

  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def forem_user
    current_user
  end

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  private

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def update_request_urls
    session[:previous_request_url] = session[:current_request_url]
    session[:current_request_url]  = request.referrer
  end

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
