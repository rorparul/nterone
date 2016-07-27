class Reports::ProfitSheetsController < ApplicationController
  before_action :authenticate_user!

  def new

  end

  def create
    @events = Event.in_range(report_params[:start_date], report_params[:end_date])

    respond_to do |format|
      format.xlsx
    end
  end

private

  def report_params
    params.require(:report).permit(:start_date, :end_date)
  end
end
