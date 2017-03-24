class Reports::SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_report

  def new

  end

  def create
    start_date = parse_date_select(report_params, :start_date)
    end_date = parse_date_select(report_params, :end_date)

    @opportunities  = Opportunity.where(date_closed: start_date..end_date).where.not(customer_id: nil)
    @opportunities  = @opportunities.where(waiting: false) unless params[:report][:waiting] == "1"
    @opportunities  = @opportunities.closed                unless params[:report][:open] == "1"

    if current_user.admin?
      @company_sales  = @opportunities.where(employee_id: nil)
      employee_sales  = @opportunities.where.not(employee_id: nil)
      @grouped_sales  = employee_sales.group_by {|opportunity| opportunity.employee}
      respond_to do |format|
        format.xlsx {
          render xlsx: 'sales_report', file: 'reports/sales/create_admin.xlsx.axlsx'
        }
      end
    else
      @opportunities  = @opportunities.where(employee_id: current_user.id)
      respond_to do |format|
        format.xlsx {
          render xlsx: 'sales_report', file: 'reports/sales/create_rep.xlsx.axlsx'
        }
      end
    end
  end

  private

  def report_params
    params.require(:report).permit(:start_date, :end_date)
  end

  def authorize_report
    return redirect_to root_path unless current_user.admin? || current_user.sales?
  end
end
