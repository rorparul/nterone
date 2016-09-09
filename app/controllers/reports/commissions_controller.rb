class Reports::CommissionsController < ApplicationController
  before_action :authenticate_user!

  def new

  end

  def create
    start_date = parse_date_select(report_params, :start_date)
    end_date   = parse_date_select(report_params, :end_date)

    @order_items  = Order.items_in_range_for(report_params[:sales_rep], start_date, end_date)
    @sales_rep_id = current_user.sales_rep? ? current_user.id : report_params[:sales_rep]

    respond_to do |format|
      format.xlsx
    end
  end

private

  def report_params
    params.require(:report).permit(:sales_rep, :start_date, :end_date)
  end
end
