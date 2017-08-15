class AdminPolicy < Struct.new(:user, :admin)

  def admin?
    user.admin?
  end

  def partner?
    user.partner?
  end

  def sales_manager?
    user.sales_manager?
  end

  def sales_rep?
    user.sales_rep?
  end

  def show?
    user.admin?  || user.partner? || user.sales_manager? || user.sales_rep?
  end

  def save?
    user.admin? || user.sales_manager? || user.sales_rep?
  end

end
