class CompanyPolicy < ApplicationPolicy
  def index?
    @user.admin? || @user.sales?
  end

  def show?
    @user.admin? || (@user.sales? && @user.companies.find_by(id: @record.id))
  end

  def create?
    @user.admin? || @user.sales?
  end

  # def pluck?
  # end

  def update?
    @user.admin? || (@user.sales? && @user.companies.find_by(id: @record.id))
  end

  def merge?
    @user.admin? || (@user.sales? && @user.companies.find_by(id: @record.id))
  end

  def merge_companies?
    @user.admin? || (@user.sales? && @user.companies.find_by(id: @record.id))
  end

  def destroy?
    @user.admin? || (@user.sales? && @user.companies.find_by(id: @record.id))
  end

  def mass_edit?
    mass_update?
  end

  def mass_update?
    @user.admin? || @user.sales_manager?
  end
end
