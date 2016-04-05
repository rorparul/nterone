class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    Role.create(user_id: @user.id)
    CustomMailer.welcome(@user).deliver_now
  end

  protected

  def after_update_path_for(resource)
    main_app.edit_user_registration_path
  end
end
