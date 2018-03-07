class CoursePolicy < ApplicationPolicy
  include NilUsers

  def show?
    @record.current_region_available? && !@record.archived?
  end
end
