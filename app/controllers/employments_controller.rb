class EmploymentsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_emplyment, only: [:show, :edit, :update, :destroy]

  def index
    @employments_scop = Employment.all
    @employments      = smart_listing_create(
      :employments,
      @employments_scop,
      partial: "employments/employment_list"
    )
  end  
  
  def new
    @emp = Employment.new
  end
  
  def create
    @emp = Employment.new(employment_params)
    if @emp.save
      redirect_to employments_path
    else
      render :new  
    end  
  end

  def edit
  end  

  def update
    if @emp.update(employment_params)
      redirect_to employments_path
    else
      render :edit  
    end  
  end  

  def destroy
    if @emp.delete
      redirect_to employments_path
    end
  end 
   
  private

    def set_emplyment
      @emp = Employment.find(params[:id])
    end 

    def employment_params
      params.require(:employment).permit(:start_date, :end_date, :employment_type, :start_time, :end_time, :instructor_id)   
    end
end
