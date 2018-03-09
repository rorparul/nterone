class VideoOnDemandPolicy < ApplicationPolicy
  include NilUsers

  def show?
    # TODO: Add proper logic here
    # @record.current_region_available? && !@record.archived?
    true
  end

  def new?
    ensure_user_present
    @user.admin?
  end

  def create?
    ensure_user_present
    @user.admin?
  end

  def edit?
    ensure_user_present
    @user.admin?
  end

  def update?
    ensure_user_present
    @user.admin?
  end

  def destroy?
    ensure_user_present
    @user.admin?
  end
end
