class OpportunityPolicy < ApplicationPolicy
  def index?
    @user.admin? || @user.sales?
  end

  def show?
    @user.admin? || (@user.sales? && @user.opportunities.find_by(id: @record.id))
  end

  def create?
    @user.admin? || @user.sales?
  end

  # def copy?
  # end

  def update?
    @user.admin? || (@user.sales? && @user.opportunities.find_by(id: @record.id))
  end

  def destroy?
    @user.admin? || (@user.sales? && @user.opportunities.find_by(id: @record.id))
  end
end
