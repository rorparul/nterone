class ApplicationController < ActionController::Base
  include Pundit
  include PublicActivity::StoreController
  include CurrentCart

  before_action :prepare_exception_notifier
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :record_user_activity
  before_action :set_cart
  before_action :get_alert_counts
  before_action :update_request_urls
  after_filter  :store_location

  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def forem_user
    current_user
  end
  helper_method :forem_user

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def authenticate_admin!
    if current_user.blank? || !current_user.admin?
      redirect_to root_path, alert: 'you are not authorized'
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |user|
      user.permit(:first_name,
                  :last_name,
                  :email,
                  :password,
                  :password_confirmation,
                  interest_attributes: [:id,
                                        :data_center,
                                        :collaboration,
                                        :network,
                                        :security,
                                        :associate_level_certification,
                                        :professional_level_certification,
                                        :expert_level_certification,
                                        :other])
    end

    devise_parameter_sanitizer.for(:account_update) do |user|
      user.permit(:email,
                  :current_password,
                  :password,
                  :password_confirmation)
    end
  end

  def parse_date_select(params, name)
    parts = (1..6).map do |e|
      params["#{name}(#{e}i)"].to_i
    end

    # remove trailing zeros
    parts = parts.slice(0, parts.rindex{|e| e != 0}.to_i + 1)
    return nil if parts[0] == 0  # empty date fields set

    Date.new(*parts)
  end

  private

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      host:         request.host,
      current_user: current_user.inspect
    }
  end

  def set_locale
    case request.host
    when "www.nterone.la"
      I18n.locale = :es
    when "www.nterone.com"
      I18n.locale = :en
    else
      I18n.locale = :en
    end
  end

  def store_location
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

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
