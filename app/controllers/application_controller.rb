class ApplicationController < ActionController::Base
  include Pundit
  include PublicActivity::StoreController

  before_filter      :configure_permitted_parameters, if: :devise_controller?
  before_filter      :check_brand
  before_action      :redirect_if_not_signed_in, except: [:new, :create]
  skip_before_action :redirect_if_not_signed_in, if: :devise_controller?
  before_action      :get_badge_counts
  before_action      :record_user_activity
  before_action      :set_mailer_host # TODO: Create a more fail-proof way of getting this to the Devise mailers
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def brand
    @b ||= Brand.includes(:logo).find_by(url: request.host)
  end
  helper_method :brand

  def set_mailer_host
    if Brand.all.collect{|b| b.url}.include?(request.host)
      ActionMailer::Base.default_url_options[:host] = request.host
      # ActionMailer::Base.default_url_options[:port] = request.port
    end
  end

  def check_brand
    render(file: "#{Rails.root}/public/404.html", layout: false, status: 404) unless brand.present?
  end

  private

  def record_user_activity
    if user_signed_in?
      current_user.touch(:last_active_at)
    end
  end

  def get_badge_counts
    if user_signed_in?
      @message_count = current_user.new_message_count
      if current_user.sales_manager? || current_user.any_admin?
        @lead_count = Lead.where(brand_id: brand.id, status: 'unassigned', seller_id: [nil, 0]).count
      elsif current_user.sales?
        @lead_count = Lead.where(brand_id: brand.id, status: 'assigned', seller_id: current_user.id).count
      elsif current_user.member?
        @my_plan_count = current_user.planned_subjects.where(active: true, read: false).count
      end
    end
  end

  def redirect_if_not_signed_in
    unless user_signed_in?
      redirect_to new_user_session_path
    end
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
    @pu ||= BrandUser.includes(:user).find_by(user_id: current_user.id, brand_id: brand.id) || current_user
  end
end
