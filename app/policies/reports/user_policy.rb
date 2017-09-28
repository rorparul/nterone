class Reports::UserPolicy < Struct.new(:user, :reports_user)
  def new?
    create?
  end

  def create?
    user.has_any_role?(%i(admin sales_manager sales_rep))
  end
end
