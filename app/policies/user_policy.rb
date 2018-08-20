class UserPolicy < ApplicationPolicy
  def index?
    @user.admin?
  end

  def people?
    @user.admin? || @user.sales?
  end

  def members?
    @user.admin? || @user.sales?
  end

  def students?
    @user.admin? || @user.sales?
  end

  def instructors?
    @user.admin? || @user.sales?
  end

  def get_users_by_role?
    @user.admin? || @user.sales?
  end

  def sales_reps?
    @user.admin? || @user.sales?
  end

  def show_as_lead?
    # @user.admin? || (@user.sales? && @user.children.find_by(id: @record.id))
    @user.admin? || @user.sales?
  end

  def show_as_contact?
    # @user.admin? || (@user.sales? && @user.children.find_by(id: @record.id))
    @user.admin? || @user.sales?
  end

  def show_as_sales_rep?
    # @user.admin? || (@user.sales? && @user.children.find_by(id: @record.id))
    @user.admin? || @user.sales?
  end

  def edit_from_sales?
    # @user.admin? || (@user.sales? && @user.children.find_by(id: @record.id))
    @user.admin? || @user.sales?
  end

  def assign?
    @user.admin? || @user.sales_manager?
  end

  def update?
    # @user.admin? || (@user.sales? && @user.children.find_by(id: @record.id))
    @user.admin? || @user.sales? || (@user == @record)
  end

  def mass_edit?
    mass_update?
  end

  def mass_update?
    @user.admin? || @user.sales_manager?
  end

  def mark_customers_type?
    @user.admin? || @user.sales_manager? || @user.sales?
  end

  def destroy?
    @user.admin? || (@user.sales? && @user.children.find_by(id: @record.id))
  end

  def leads_unsubscribe_new?
    user.has_any_role?(%i(admin sales_rep sales_manager))
  end

  def leads_unsubscribe?
    user.has_any_role?(%i(admin sales_rep sales_manager))
  end

end
