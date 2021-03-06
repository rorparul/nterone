class CategoryPolicy < ApplicationPolicy
  include NilUsers

  def index?
    ensure_user_present
    @user.admin?
  end

  def show?
    @record.current_region_available? && !@record.archived?
  end

  def create?
    ensure_user_present
    @user.has_any_role?(%i(admin webmaster marketing))
  end

  def update?
    ensure_user_present
    @user.has_any_role?(%i(admin webmaster marketing))
  end

  def destroy?
    ensure_user_present
    @user.admin?
  end
end
