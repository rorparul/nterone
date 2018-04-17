class SettingPolicy < ApplicationPolicy
  def index?
    user.has_any_role?(%i(admin))
  end

  def update?
    user.has_any_role?(%i(admin))
  end
end
