class SubjectPolicy < ApplicationPolicy
  include NilUsers

  def show?
    @record.current_region_available? && !@record.archived?
  end

  def create?
    ensure_user_present
    @user.has_any_role?(%i(admin webmaster))
  end

  def update?
    ensure_user_present
    @user.has_any_role?(%i(admin webmaster))
  end

  def destroy?
    ensure_user_present
    @user.has_any_role?(%i(admin webmaster))
  end
end
