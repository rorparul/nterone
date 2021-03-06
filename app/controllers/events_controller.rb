class EventsController < ApplicationController
  before_action :authenticate_user!, except: :feed
  before_action :set_event, only: [:edit_in_house_note, :update_in_house_note]

  def page
    @events = Event.order(guaranteed: :desc, start_date: :asc).page(params[:page])
  end

  def feed
    @events = Event.upcoming_public_events.current_region
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def new
    @platform = Platform.find(params[:platform_id])
    @course   = Course.find(params[:course_id])
    @event    = @course.events.build
    @event.assign_attributes(book_cost_per_student: @course.book_cost_per_student)
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
    @platform = Platform.find(params[:platform_id])
    @course   = Course.find(params[:course_id])
    @events   = @course.events
    @event    = @course.events.build
  end

  def select_to_edit
    if event_params[:id] == 'none'
      platform = Platform.find(params[:platform_id])
      course   = Course.find(params[:course_id])
      redirect_to select_platform_course_events_path(platform, course)
    else
      @platform = Platform.find(params[:platform_id])
      @course   = Course.find(params[:course_id])
      @event    = Event.find(event_params[:id])
    end
  end

  def edit
    @platform = Platform.find(params[:platform_id])
    @course   = Course.find(params[:course_id])
    @event    = Event.find(params[:id])
  end

  def update
    @platform = Platform.find(params[:platform_id])
    @course   = Course.find(params[:course_id])
    @event    = Event.find(params[:id])

    # EventReminderWorker.new.perform

    if @event.update_attributes(event_params)
      flash[:success] = 'Event successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
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
    @events = Event.joins(:course).upcoming_events.with_students

    respond_to do |format|
      format.xlsx
      format.html
    end
  end

  def upload_form
  end

  def upload
    @upload = ClassesUploader.upload(event_params[:file])
  end

  def edit_in_house_note
  end

  def update_in_house_note
    @event.update_attributes(in_house_note_params)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js do
        render json: { success: true, in_house_note: @event.in_house_note }
      end
    end
  end

  def pluck
    @event = Event.find_by(id: params[:event_id])
  end

  def instructor_options
    @course = Course.find_by_id(params[:course_id])
    @event = Event.find_by(id: params[:event_id])
    @event.format = params[:event_format] if @event.present?
  end

  def state_list
    @states = CS.states(params[:country_code].downcase)
  end

  private

  def event_params
    params.require(:event).permit(
      :active,
      :autocalculate_instructor_costs,
      :book_cost_per_student,
      :calculate_book_costs,
      :city,
      :cost_books,
      :cost_facility,
      :cost_instructor,
      :cost_lab,
      :cost_shipping,
      :cost_te,
      :count_weekends,
      :end_date,
      :end_time,
      :file,
      :format,
      :guaranteed,
      :id,
      :in_house_note,
      :instructor_id,
      :lab_source,
      :language,
      :note,
      :origin_region,
      :partner_led,
      :price,
      :public,
      :remind_period,
      :resell,
      :sent_all_course_material,
      :sent_all_lab_credentials,
      :sent_all_webex_invite,
      :should_remind,
      :start_date,
      :start_time,
      :state,
      :status,
      :street,
      :time_zone,
      :zipcode,
      :checklist_id,
      :cost_commission,
      :autocalculate_cost_commission,
      :do_not_send_instructor_email,
      :country_code,
      :location,
      :registration_url,
      :registration_phone,
      :registration_fax,
      :registration_email,
      :site_id,
      active_regions: []
    )
  end

  def in_house_note_params
    params.require(:event).permit(:in_house_note)
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
