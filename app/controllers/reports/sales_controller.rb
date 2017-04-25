class Reports::SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_report

  def new
    if current_user.admin? || current_user.sales_manager?
      @owners = User.all_sales
    end
  end

  def create
    start_date = parse_date_select(report_params, :start_date)
    end_date   = parse_date_select(report_params, :end_date)

    @opportunities = Opportunity.where(date_closed: start_date..end_date)
    @opportunities = @opportunities.pending if report_params[:status] == "open"
    @opportunities = @opportunities.waiting if report_params[:status] == "waiting"
    @opportunities = @opportunities.won     if report_params[:status] == "won"

    @remove_percent_column = report_params[:status] == "won"

    if current_user.admin? || current_user.sales_manager?
      @company_sales = @opportunities.where(employee_id: nil)
      
      if params[:filter_user] == ''
        employee_sales = @opportunities.where.not(employee_id: nil)
      else
        employee_sales = @opportunities.where(employee_id: params[:filter_user])
      end

      @grouped_sales = employee_sales.group_by { |opportunity| opportunity.employee }

      respond_to do |format|
        format.xlsx do
          render xlsx: 'sales_report', file: 'reports/sales/create_admin.xlsx.axlsx'
        end
      end
    else
      @opportunities = @opportunities.where(employee_id: current_user.id)

      respond_to do |format|
        format.xlsx do
          render xlsx: 'sales_report', file: 'reports/sales/create_rep.xlsx.axlsx'
        end
      end
    end
  end

  private

  def report_params
    params.require(:report).permit(:status, :start_date, :end_date)
  end

  def authorize_report
    return redirect_to root_path unless current_user.admin? || current_user.sales?
  end
end
