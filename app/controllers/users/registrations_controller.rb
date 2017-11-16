class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]

  def new
    @special_event = params[:special_event]
    super
  end

  def create
    super

    if @user.persisted?
      Role.create(user_id: @user.id)

      if @cart.source_name && @cart.source_user_id
        @user.update_attributes(source_name: @cart.source_name, source_user_id: @cart.source_user_id)
      end

      if @user.source_name == "experts-exchange"
        CustomMailer.welcome_experts_exchange(@user).deliver_now
      else
        CustomMailer.welcome(@user, params['M360-Source']).deliver_now
      end

      if params[:poker_chip_number]
        @user.settings.poker_chip_number = params[:poker_chip_number]
      end

      # if @user.interest
      #   Lead.create(buyer_id: @user.id, status: 'unassigned')
      # end
    end

    if @user.persisted? && lms_path?
      Role.create(user: @user, role: 6)
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if @cart.order_items.any?
      main_app.new_order_path
    else
      main_app.welcome_path
    end
  end

  def after_update_path_for(resource)
    main_app.edit_user_registration_path
  end

  private

  def check_captcha
    if verify_recaptcha
      true
    else
      self.resource = resource_class.new sign_up_params
      respond_with_navigational(resource) { render :new }
    end
  end

  def lms_path?
    request.referer.present? && request.referer.include?('/lms')
  end
end
