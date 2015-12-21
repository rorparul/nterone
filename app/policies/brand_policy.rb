class BrandPolicy < ApplicationPolicy
  def index?
    @user.super_admin?
  end

  def create?
    @user.super_admin?
  end

  def update?
    @user.super_admin? || @user.admin?
  end
end
