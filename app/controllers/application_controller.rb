class ApplicationController < ActionController::Base
  include Pundit
  include PublicActivity::StoreController
  include CurrentCart

  before_action :prepare_exception_notifier
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :record_user_activity
  before_action :get_external_source_values
  before_action :set_cart
  before_action :get_alert_counts
  before_action :update_request_urls
  before_action :set_gon

  after_action  :store_location

  helper_method :forem_user, :resource_name, :resource, :devise_mapping

  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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
                  :source_name,
                  :source_user_id,
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
    parts = parts.slice(0, parts.rindex{ |e| e != 0}.to_i + 1)

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
    when 'www.nterone.com'
      I18n.locale = :en
    when 'www.nterone.la'
      I18n.locale = :es
    else
      I18n.locale = :en
    end
  end

  def store_location
    session[:previous_url] = request.fullpath unless skip_path_store?
  end

  def skip_path_store?
    path = request.fullpath
    path =~ /\/users/ || path =~ /\/lms\/signup/ || path =~ /\/lms$/ || path =~ /\/checkout\/lab_rental/ || path =~ /\/time_select\/lab_course_time_blocks/
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

  def get_external_source_values
    if true?(params[:external_source])
      cookies[:cart_id] = params[:cart_id]
    end
  end

  def true?(string)
    string == 'true'
  end

  def set_gon
    gon.logo_10_years = ActionController::Base.helpers.image_url("locales/#{I18n.locale}/logo-with-tagline-small.png")
    gon.logo_base = ActionController::Base.helpers.image_url("locales/#{I18n.locale}/archive/logo-with-tagline-small.png")
  end
end
