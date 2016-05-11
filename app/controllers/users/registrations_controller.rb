class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]

  def create
    super

    if @user.persisted?
      Role.create(user_id: @user.id)
      CustomMailer.welcome(@user).deliver_now
    end
  end

  protected

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
end
