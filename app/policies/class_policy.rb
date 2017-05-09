class ClassPolicy < Struct.new(:user, :class)

  def report?
    user.admin? || user.sales_manager? || user.sales_rep?
  end

  def save?
    user.admin? || user.sales_manager? || user.sales_rep?
  end

  def show?
    user.admin? || user.sales_manager? || user.sales_rep?
  end

end
