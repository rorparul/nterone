class LabCourseTimeBlocksController < ApplicationController
  before_action :set_time_block, except: [:new, :create]
  # before_action :authorize_lab_course_time_block

  def new
    @lab_course = LabCourse.find(params[:lab_course_id])
    @time_block = LabCourseTimeBlock.new
  end

  def create
    @time_block = LabCourseTimeBlock.new(time_block_params)
    if @time_block.save
      flash[:success] = "Time Block successfully created."
    else
      flash[:alert] = "Time Block failed to save."
    end
    redirect_to :back
  end

  def edit
    @lab_course = @time_block.lab_course
  end

  def update
    if @time_block.update_attributes(time_block_params)
      flash[:success] = "Successfully updated time block."
    else
      flash[:alert] = "Time Block failed to update!"
    end
    redirect_to :back
  end

  def destroy
    if @time_block.destroy
      flash[:success] = "Time Block successfully destroyed."
    else
      flash[:alert] = "Failed to destroy time block!"
    end
    redirect_to :back
  end

  def date_select
    @time_starts =* (0..23).map do |n|
      if n / 12 == 0
        n = n % 12 == 0 ? "12:00am" : (n % 12).to_s + ":00am"
      else
        n = n % 12 == 0 ? "12:00pm" : (n % 12).to_s + ":00pm"
      end
    end
  end

  def time_select
    @lab_rentals = LabRental.where(first_day: params[:date_start], time_zone: params[:time_zone])
    @time_starts =* (0..23).map do |n|
      if n / 12 == 0
        n = n % 12 == 0 ? "12:00am" : (n % 12).to_s + ":00am"
      else
        n = n % 12 == 0 ? "12:00pm" : (n % 12).to_s + ":00pm"
      end
    end
    puts
    puts
    p @lab_rentals
    puts
    puts
  end

  private

  def time_block_params
    params.require(:lab_course_time_block).permit(
      :lab_course_id,
      :level_individual,
      :level_partner,
      :price,
      :ratio,
      :title,
      :unit_size,
      :unit_quantity
    )
  end

  def set_time_block
    @time_block = LabCourseTimeBlock.find(params[:id])
  end

  def authorize_lab_course_time_block
    authorize @time_block
  end

end
