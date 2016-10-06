class EventsController < ApplicationController
  before_action :authenticate_user!, except: :feed
  before_action :set_event, only: [:edit_in_house_note, :update_in_house_note]

  def page
    @events = Event.order(guaranteed: :desc, start_date: :asc).page(params[:page])
  end

  def feed
    @events = Event.upcoming_public_events
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def new
    @platform    = Platform.find(params[:platform_id])
    @course      = Course.find(params[:course_id])
    @event       = @course.events.build
    # @instructors = @platform.instructors
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
    # @instructors = User.only_instructors
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
      # @instructors = @platform.instructors
    end
  end

  def edit
    @platform    = Platform.find(params[:platform_id])
    @course      = Course.find(params[:course_id])
    @event       = Event.find(params[:id])
    # @instructors = @platform.instructors
  end

  def update
    @platform = Platform.find(params[:platform_id])
    @course   = Course.find(params[:course_id])
    @event    = Event.find(params[:id])

    EventReminderWorker.new.perform

    if @event.update_attributes(event_params)
      flash[:success] = 'Event successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      # @instructors  = @platform.instructors
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

  def student_registered_classes
    @platforms = Platform.order(:title)

    respond_to do |format|
      format.xlsx
      format.html
    end
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

  def edit_in_house_note
  end

  def update_in_house_note
    @event.update_attributes(in_house_note_params)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render json: {
        success: true, in_house_note: @event.in_house_note
      }}
    end
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
                                  :street,
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
                                  :should_remind,
                                  :remind_period,
                                  :sent_all_webex_invite,
                                  :sent_all_course_material,
                                  :sent_all_lab_credentials,
                                  :note,
                                  :in_house_note,
                                  :count_weekends,
                                  :autocalculate_instructor_costs,
                                  :calculate_book_costs,
                                  :language,
                                  :resell)
  end

  def in_house_note_params
    params.require(:event).permit(:in_house_note)
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

  def set_event
    @event = Event.find(params[:id])
  end
end
