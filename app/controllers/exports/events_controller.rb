class Exports::EventsController < ApplicationController
  # TODO: Add a policy for this controller

  def new
    @vendors = Platform.active.order(:title)
  end

  def create
    if export_params[:platform_id].blank?
      events = Event.all
    else
      events = Platform.find(export_params[:platform_id]).events
    end

    events  = events.where('start_date >= ?', export_params_start_date)
    @events = events.where(public: export_params[:public])

    render filename: "events-#{DateTime.now}.xlsx"
  end

  private

  def export_params
    params.require(:export).permit(
      :platform_id,
      :public,
      :start_date
    )
  end

  def export_params_start_date
    Date.new(
      export_params['start_date(1i)'].to_i,
      export_params['start_date(2i)'].to_i,
      export_params['start_date(3i)'].to_i
    )
  end
end
