class Reports::ProfitSheetsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def new

  end

  def create
    start_date = parse_date_select(report_params, :start_date)
    end_date = parse_date_select(report_params, :end_date)
    source = report_params[:source]
    course_id = report_params[:course_id]

    @events = Event.in_range(start_date, end_date)
    @events = @events.from_source(source) if source.present?
    @events = @events.where(course_id: course_id)  if course_id.present?

    respond_to do |format|
      format.xlsx
    end
  end

private

  def report_params
    params.require(:report).permit(:start_date, :end_date, :source, :course_id, :course)
  end
end
