class EventsController < ApplicationController
  before_action :authenticate_user!, except: :feed

  def page
    @events = Event.order(guaranteed: :desc, start_date: :asc).page(params[:page])
  end

  def feed
    @events = Event.upcoming_events
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def new
    @platform    = Platform.find(params[:platform_id])
    @course      = Course.find(params[:course_id])
    @event       = @course.events.build
    @instructors = @platform.instructors
  end

  def create
    @platform = Platform.find(params[:platform_id])
    @course   = Course.find(params[:course_id])
    @event    = @course.events.build(event_params)
    if @event.save
      flash[:success] = 'Event successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      @instructors = @platform.instructors
      render 'new'
    end
  end

  def select
    @platform    = Platform.find(params[:platform_id])
    @course      = Course.find(params[:course_id])
    @events      = @course.events
    @event       = @course.events.build
    @instructors = @platform.instructors
  end

  def  select_to_edit
    if event_params[:id] == 'none'
      platform = Platform.find(params[:platform_id])
      course   = Course.find(params[:course_id])
      redirect_to select_platform_course_events_path(platform, course)
    else
      @platform    = Platform.find(params[:platform_id])
      @course      = Course.find(params[:course_id])
      @event       = Event.find(event_params[:id])
      @instructors = @platform.instructors
    end
  end

  def edit
    @platform    = Platform.find(params[:platform_id])
    @course      = Course.find(params[:course_id])
    @event       = Event.find(params[:id])
    @instructors = @platform.instructors
  end

  def update
    @platform = Platform.find(params[:platform_id])
    @course   = Course.find(params[:course_id])
    @event    = Event.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:success] = 'Event successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      @instructors  = @platform.instructors
      render 'select_to_edit'
    end
  end

  def destroy
    event = Event.find(params[:id])
    if event.destroy
      flash[:success] = 'Event successfully destroyed.'
    else
      flash[:alert] = 'Event failed to destroy.'
    end
    redirect_to :back
  end

  def upload_form

  end

  def upload
    upload = ClassesUploader.upload(event_params[:file])
    if upload[:success]
      flash[:success] = "Successfully uploaded all classes."
    else
      flash[:alert] = ("<strong>#{view_context.pluralize(upload[:failures].count, 'Failure')}:</strong>" +
                      "<br>" +
                      "<table class='table table-condensed'>" +
                        "<thead>" +
                          "<tr>" +
                            "<th>Course ID</th>" +
                            "<th>Course Title</th>" +
                            "<th>Start Date</th>" +
                            "<th>End Date</th>" +
                            "<th>Start Time</th>" +
                            "<th>End Time</th>" +
                            "<th>Format</th>" +
                            "<th>Price</th>" +
                          "</tr>" +
                        "</thead>"+
                        "<tbody>" +
                          error_rows(upload[:failures]) +
                        "</tbody>"+
                      "</table>").html_safe
    end
    redirect_to :back
  end

  private

  def event_params
    params.require(:event).permit(:id,
                                  :start_date,
                                  :start_time,
                                  :end_date,
                                  :end_time,
                                  :format,
                                  :guaranteed,
                                  :instructor_id,
                                  :active,
                                  :price,
                                  :city,
                                  :state,
                                  :file,
                                  :public,
                                  :status,
                                  :lab_source,
                                  :cost_instructor,
                                  :cost_lab,
                                  :cost_te,
                                  :cost_facility,
                                  :cost_books,
                                  :cost_shipping,
                                  :partner_led,
                                  :time_zone,
                                  :sent_webex_invite,
                                  :sent_course_material,
                                  :sent_lab_credentials)
  end

  def error_rows(events)
    rows = ""
    events.each do |event|
      rows += "<tr>" +
                "<td>#{event[:course_id]}</td>" +
                "<td>#{event[:course_title]}</td>" +
                "<td>#{event[:start_date]}</td>" +
                "<td>#{event[:end_date]}</td>" +
                "<td>#{event[:start_time]}</td>" +
                "<td>#{event[:end_time]}</td>" +
                "<td>#{event[:format]}</td>" +
                "<td>#{event[:price]}</td>" +
              "</tr>"
    end
    rows
  end
end
