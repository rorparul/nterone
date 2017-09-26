class LabCoursePolicy < ApplicationPolicy
  def create?
    user.has_any_role?(%i(admin lab_admin))
  end

  def update?
    user.has_any_role?(%i(admin lab_admin))
  end

  def destroy?
    user.has_any_role?(%i(admin lab_admin))
  end
end
