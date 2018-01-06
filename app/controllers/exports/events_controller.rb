class Exports::EventsController < ApplicationController
  # TODO: Add a policy for this controller

  def new
    @vendors = Platform.active.order(:title)
  end

  def create
    @events = @events.where(clean_params(company_params[:filters]))
    @events = @events.custom_search(params[:search]) if params[:search].present?
    render xlsx: 'index', filename: "events-#{DateTime.now}.xlsx"
  end

  private

  def export_params
    params.require(:export).permit()
  end
end
