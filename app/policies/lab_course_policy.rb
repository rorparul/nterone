class LabCoursePolicy < ApplicationPolicy
  def new?
    user.admin?
  end

  def edit?
    user.admin?
  end
end
