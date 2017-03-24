class Reports::SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_report

  def new

  end

  def create
    start_date = parse_date_select(report_params, :start_date)
    end_date = parse_date_select(report_params, :end_date)
    if current_user.admin?
      @opportunities  = Opportunity.where(date_closed: start_date..end_date, reason_for_loss: nil).where.not(customer_id: nil)
      @opportunities  = @opportunities.where(waiting: false) unless params[:waiting]
      @opportunities  = @opportunities.closed                unless params[:open]
      @company_sales  = @opportunities.where(employee_id: nil)
      @employee_sales = @opportunities.where.not(employee_id: nil)
      @grouped_sales  = @employee_sales.group_by {|opportunity| opportunity.employee}
      respond_to do |format|
        format.xlsx {
          render xlsx: 'sales_report', file: 'reports/sales/create_admin.xlsx.axlsx'
        }
      end
    else
      @opportunities = Opportunity.where(date_closed: start_date..end_date, employee_id: current_user.id, reason_for_loss: nil).where.not(customer_id: nil)
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
