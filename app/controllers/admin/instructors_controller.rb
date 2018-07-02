class Admin::InstructorsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  include SmartListingConcerns

  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index]

  # layout 'admin'

  def index
    @instructors = User.all_instructors
    if params[:instructors_smart_listing].present? and params[:instructors_smart_listing][:sort].present?
      @instructors = @instructors.unscope(:order) 
    end
    unless request.format.json?
      @instructors = @instructors.custom_search(params[:filter]) if params[:filter].present?
      prepare_smart_listing(@instructors)
    end

    event_rental_schedule = User.instructor_events_and_lab_rentals(@instructors)
    respond_to do |format|
      format.html
      format.js
      format.json do
        render json: get_event_to_json(event_rental_schedule)
      end
    end
  end

  private
  
  def prepare_smart_listing(users_scope)
    smart_listing_create(
      :instructors,
      users_scope,
      partial: 'listing',
      sort_attributes: [[:first_name, "first_name"],
                        [:last_name, "last_name"],
                        [:email, "email"]
                      ],
      default_sort: { updated_at: 'desc' }
    )
  end
  
  def authorize_admin
    current_user.admin?
  end

  def get_event_to_json(event_rental_schedule)
    a = []  
    event_rental_schedule.each do | event|
      if event.class == Event && event.instructor.present?
        a << { 'title': event.title_with_instructor_and_state, 'start': event.start_date.strftime("%Y-%m-%d"), 'end': (event.end_date + 1.day).strftime("%Y-%m-%d"), 'color': 'rgb(15, 115, 185)', 'url': admin_classes_show_path(event) }
      end
      if event.class == LabRental  && event.user.present?
        a << {'title': event.instructor_name_and_lab_course_title, 'start':  event.try(:first_day).strftime("%Y-%m-%d"),'end': event.try(:last_day).strftime("%Y-%m-%d"), 'color': 'rgb(0,100,0)' }
      end  
    end
    return a.to_json 
  end  
end
