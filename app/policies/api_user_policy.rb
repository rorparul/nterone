class ApiUserPolicy < Struct.new(:user, :api_user)
  def show?
    user.admin? || user.sales_rep?
  end

end
