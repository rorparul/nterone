class InstructorsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_user!, except: :show

  def new
    @platform   = Platform.find(params[:platform_id])
    @instructor = Instructor.new
  end

  def create
    @platform   = Platform.find(params[:platform_id])
    @instructor = @platform.instructors.build(instructor_params)
    if @instructor.save
      flash[:success] = 'Instructor successfully created!'
      render js: "window.location = '#{platform_path(@platform)}';"
    else
      render 'new'
    end
  end

  def show
    @instructor = User.find(params[:id])
  end

  def select
    @platform    = Platform.find(params[:platform_id])
    @instructor  = @platform.instructors.build
    @instructors = Instructor.where(platform_id: @platform.id)
  end

  def  select_to_edit
    if instructor_params[:id] == 'none'
      redirect_to select_platform_instructors_path(Platform.find(params[:platform_id]))
    else
      @platform   = Platform.find(params[:platform_id])
      @instructor = Instructor.find(instructor_params[:id])
    end
  end

  def update
    @platform   = Platform.find(params[:platform_id])
    @instructor = Instructor.find(params[:id])
    if @instructor.update_attributes(instructor_params)
      flash[:success] = 'Instructor successfully updated!'
      render js: "window.location = '#{platform_path(@platform)}';"
    else
      render 'edit'
    end
  end

  def destroy
    instructor = Instructor.find(params[:id])
    if instructor.destroy
      flash[:notice] = 'Instructor successfully destroyed!'
    else
      flash[:alert] = 'Instructor unsuccessfully destroyed!'
    end
    redirect_to :back
  end

  def classes
    @start_date = Date.parse params[:date_start].values.join("-") if params[:date_start]
    @end_date   = Date.parse params[:date_end].values.join("-")   if params[:date_end]
    @start_date = Date.parse params[:start] if params[:start]
    @end_date   = Date.parse params[:end]   if params[:end]
    @events = (@start_date && @end_date) ? current_user.taught_events.where(start_date: [@start_date..@end_date]) : current_user.taught_events
    unless request.format.json?
      @events = @events.custom_search(params[:filter]) if params[:filter]
      @start_date = @events.minimum("events.start_date")
      @end_date   = @events.maximum("events.start_date")
      @events = smart_listing_create(:events,
        @events,
        partial: 'instructors/class_listing',
        page_sizes: [100, 50, 10],
        sort_attributes: [
          [:start_date, 'start_date'],
          [:start_time, 'start_time'],
          [:format, "format"],
          [:status, "Status"],
          [:lab_source, "lab_source"]],
        default_sort: { start_date: 'asc', course: "asc"}
      )
    end
    respond_to do |format|
      format.html{ render 'instructors/classes' }
      format.js
      format.json do  
        render json: instructor_event_and_schedule(@events)
      end
    end
  end

  def classes_show
    @event = Event.find(params[:id])
    render 'instructors/classes_show'
  end

  def should_group_classes?
    params.dig(:events_smart_listing, :sort, :start_date).present? ||
    params.dig(:events_smart_listing, :sort, 'events.start_date').present? ||
    params.dig(:events_smart_listing, :sort).blank?
  end

  private

  def instructor_params
    params.require(:instructor).permit(
      :biography,
      :email,
      :first_name,
      :id,
      :last_name,
      :origin_region,
      :phone,
      active_regions: [])
  end

  def instructor_event_and_schedule(events)
    a = []
    lab_rentals = current_user.lab_rentals
    all_event_and_rental  = events + lab_rentals
    all_event_and_rental.each do |event|
      if event.class == Event && event.instructor.present?
        a << { 'title': event.title_with_instructor_and_state, 'start': event.start_date.strftime("%Y-%m-%d"), 'end': (event.end_date + 1.day).strftime("%Y-%m-%d"), 'color': 'rgb(15, 115, 185)', 'url': admin_classes_show_path(event) }
      end
      if event.class == LabRental  && event.user.present?  && event.first_day.present? && event.last_day.present?
        a << {'title': event.instructor_name_and_lab_course_title, 'start':  event.try(:first_day).strftime("%Y-%m-%d"),'end': event.try(:last_day).strftime("%Y-%m-%d"), 'color': 'rgb(0,100,0)' }
      end  
    end
    return a.to_json

  end  
end
