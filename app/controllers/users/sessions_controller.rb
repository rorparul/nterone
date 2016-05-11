class Users::SessionsController < Devise::SessionsController
  def create
    super

    if lms_path? && lms_role_not_exists?
      Role.create(user: @user, role: 6)
    end
  end


  private

  def lms_role_not_exists?
    @user.present? && !Role.exists?(user: @user, role: 6)
  end

  def lms_path?
    request.referer.present? && request.referer.include?('/lms')
  end
end
