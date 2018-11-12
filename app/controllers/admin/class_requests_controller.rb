class Admin::ClassRequestsController < Admin::BaseController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_class_request, only: [:edit, :update, :approve, :destroy]

  def new
    @event = current_user.event_requests.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = 'Your class request was successfully submitted.'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def index
    if current_user.sales_rep?
      events_scope = Event.unscoped.where(approved: false, sales_rep_id: current_user.id)
    elsif current_user.sales_manager? || current_user.admin?
      events_scope = Event.unscoped.where(approved: false)
    end
    @events = smart_listing_create(:class_requests, events_scope, partial: "admin/class_requests/listing")
  end

  def edit
  end

  def update
    @event.assign_attributes(event_params)
    if @event.save
      flash[:success] = 'Your class request was successfully updated and submitted.'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'edit'
    end
  end

  def approve
    if @event.update_attributes(approved: true)
      flash[:success] = 'The class request was successfully approved.'
    else
      flash[:alert] = 'There was an issue when attempting to approve the class request.'
    end
    redirect_to :back
  end

  def destroy
    if @event.destroy
      flash[:success] = 'Your class request was successfully canceled.'
    else
      flash[:alert] = 'There was an issue when attempting to cancel your class request.'
    end
  end

  private

  def set_class_request
    @event = Event.unscoped.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :id,
      :course_id,
      :sales_rep_id,
      :approved,
      :end_date,
      :end_time,
      :format,
      :in_house_note,
      :language,
      :price,
      :start_date,
      :start_time,
      :state,
      :time_zone,
      :country_code,
      :customer_name,
      :estimated_student_count,
      :origin_region,
      active_regions: []
    )
  end
end
