class PeoplePolicy < Struct.new(:user, :people)

  def save?
    user.admin? || user.sales_manager? || user.sales_rep?
  end

  def show?
    user.admin? || user.sales_manager? || user.sales_rep?
  end

end
