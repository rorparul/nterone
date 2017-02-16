class Reports::SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def new

  end

  def create
    start_date = parse_date_select(report_params, :start_date)
    end_date = parse_date_select(report_params, :end_date)
    @company_sales = Opportunity.where(date_closed: start_date..end_date, employee_id: nil).where.not(customer_id: nil)
    @opportunities = Opportunity.where(date_closed: start_date..end_date).where.not(employee_id: nil, customer_id: nil)
    @grouped_opportunities = @opportunities.group_by {|opportunity| opportunity.employee}
    respond_to do |format|
      format.xlsx
    end
  end

  private

  def report_params
    params.require(:report).permit(:start_date, :end_date)
  end
end
