class ApiUserPolicy < Struct.new(:user, :api_user)
  def show?
    user.admin?
  end
end
