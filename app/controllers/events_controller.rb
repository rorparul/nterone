class EventsController < ApplicationController
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
      flash[:notice] = 'Event successfully destroyed!'
    else
      flash[:alert] = 'Event unsuccessfully destroyed!'
    end
    redirect_to :back
  end

  def upload_form

  end

  def upload
    upload = ClassesUploader.new(file: event_params[:csv])
    if upload.valid_header?
      upload.run!
      if upload.report.success?
        flash[:success] = upload.report.message
      else
        flash[:alert] = upload.report.message
      end
    else
      flash[:alert] = upload.report.message
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
                                  :csv,
                                  :public,
                                  :status,
                                  :lab_source)
  end
end
