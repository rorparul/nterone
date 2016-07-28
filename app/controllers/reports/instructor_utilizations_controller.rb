class Reports::InstructorUtilizationsController < ApplicationController
  before_action :authenticate_user!

  def new

  end

  def create
    @instructors = Instructor.all

    respond_to do |format|
      format.xlsx
    end
  end

private

  def report_params
    params.require(:report).permit(:start_date, :end_date)
  end
end
