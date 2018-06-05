class VideoOnDemandPolicy < ApplicationPolicy
  include NilUsers

  def show?
    # TODO: Add proper logic here
    # @record.current_region_available? && !@record.archived?
    true
  end

  def new?
    ensure_user_present
    @user.has_any_role?(%i(admin webmaster))
  end

  def create?
    ensure_user_present
    @user.has_any_role?(%i(admin webmaster))
  end

  def edit?
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
