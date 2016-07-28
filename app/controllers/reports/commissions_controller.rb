class Reports::CommissionsController < ApplicationController
  before_action :authenticate_user!

  def new

  end

  def create
    @order_items  = Order.items_in_range_for(*report_params.values)
    @sales_rep_id = report_params[:sales_rep]

    respond_to do |format|
      format.xlsx
    end
  end

private

  def report_params
    params.require(:report).permit(:sales_rep, :start_date, :end_date)
  end
end
