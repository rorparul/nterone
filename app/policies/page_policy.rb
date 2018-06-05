class PagePolicy < ApplicationPolicy
  def create?
    user.has_any_role?(%i(admin webmaster marketing))
  end

  def update?
    user.has_any_role?(%i(admin webmaster marketing))
  end

  def destroy?
    user.has_any_role?(%i(admin webmaster marketing))
  end
end
