class PagePolicy < ApplicationPolicy
  def new?
    user.admin?
  end

  def edit?
    user.admin?
  end
end
