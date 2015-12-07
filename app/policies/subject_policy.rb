class SubjectPolicy < ApplicationPolicy
  def create?
    @user.brand_admin?
  end

  def update?
    @user.brand_admin?
  end

  def destroy?
    @user.brand_admin?
  end
end
