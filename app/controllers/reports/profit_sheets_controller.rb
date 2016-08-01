class Reports::ProfitSheetsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def new

  end

  def create
    start_date = parse_date_select(report_params, :start_date)
    end_date = parse_date_select(report_params, :end_date)

    @events = Event.in_range(start_date, end_date)

    respond_to do |format|
      format.xlsx
    end
  end

private

  def report_params
    params.require(:report).permit(:start_date, :end_date)
  end
end
