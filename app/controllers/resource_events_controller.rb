class ResourceEventsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_emplyment, only: [:show, :edit, :update, :destroy]

  def index
    @employments_scop = ResourceEvent.all
    @employments      = smart_listing_create(
      :resourse_events,
      @employments_scop,
      partial: "resource_events/employment_list"
    )
  end  
  
  def new
    @emp = ResourceEvent.new
  end
  
  def create
    @emp = ResourceEvent.new(employment_params)
    if @emp.save
      redirect_to resource_events_path
    else
      render :new  
    end  
  end


  def show
  end  

  def edit
  end  

  def update
    if @emp.update(employment_params)
      redirect_to resource_events_path
    else
      render :edit  
    end  
  end  

  def destroy
    if @emp.delete
      redirect_to resource_events_path 
    end
  end 
   
  private

    def set_emplyment
      @emp = ResourceEvent.find(params[:id])
    end 

    def employment_params
      params.require(:resource_event).permit(:start_date, :end_date, :employment_type, :start_time, :end_time, :instructor_id)   
    end
end
