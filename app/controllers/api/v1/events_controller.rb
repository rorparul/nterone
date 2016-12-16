class Api::V1::EventsController < Api::V1::BaseController

  def upcoming_public_featured_events
    @events = Event.where(
      "events.active = :active and public = :public and guaranteed = :guaranteed and start_date >= :start_date",
      { active: true, public: true, guaranteed: true, start_date: Date.today }
    ).all
  end

end
