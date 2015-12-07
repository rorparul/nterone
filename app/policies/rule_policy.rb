class RulePolicy < ApplicationPolicy
  def create?
    @user.brand_admin?
  end

  def update?
    @user.brand_admin?
  end
end
