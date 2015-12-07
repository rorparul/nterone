class CategoryPolicy < ApplicationPolicy
  def index?
    @user.brand_admin?
  end

  def show?
    @user.brand_admin?
  end

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
