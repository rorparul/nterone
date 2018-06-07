class LabCoursePolicy < ApplicationPolicy
  include NilUsers

  def show?
    @record.current_region_available?
  end

  def create?
    ensure_user_present
    user.has_any_role?(%i(admin webmaster lab_admin))
  end

  def update?
    ensure_user_present
    user.has_any_role?(%i(admin webmaster lab_admin))
  end

  def destroy?
    ensure_user_present
    user.has_any_role?(%i(admin webmaster lab_admin))
  end
end
