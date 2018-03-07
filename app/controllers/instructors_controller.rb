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
    @events = current_user.taught_events
    @events = smart_listing_create(:events,
      @events,
      partial: 'instructors/class_listing',
      sort_attributes: [
        [:start_date, 'start_date'],
        [:start_time, 'start_time'],
        [:lab_source, 'lab_source']],
      default_sort: { start_date: 'asc'}
    )

    respond_to do |format|
      format.html{ render 'instructors/classes', layout: 'admin' }
      format.js
    end
  end

  def classes_show
    @event = Event.find(params[:id])
    render 'instructors/classes_show', layout: 'admin'
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
end
