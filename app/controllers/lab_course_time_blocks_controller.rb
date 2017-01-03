class LabCourseTimeBlocksController < ApplicationController
  before_action :set_time_block, except: [:new, :create]
  before_action :authorize_lab_course_time_block, except: [:date_select, :time_select, :reserve]

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
    build_time_starts
    @time_zone  = nil
    @date_start = nil
  end

  def time_select
    @time_zone  = params[:time_zone]
    @date_start = params[:date_start]
    duration    = @time_block.unit_quantity
    determine_pods
    build_time_starts
    lab_rentals = LabRental.where(first_day: (@date_start.to_datetime - 1)..(@date_start.to_datetime + 1), level: 'individual')
    @time_starts.each_with_index do |time_start, index|
      count = 0
      lab_rentals.each do |lab_rental|
        if OrderItem.where(orderable_type: 'LabRental', orderable_id: lab_rental.id).exists?
          lab_rental_start = (lab_rental.first_day.to_s + lab_rental.start_time.strftime(" %H:%M %z")).to_time
          lab_rental_end   = (lab_rental.last_day.to_s + lab_rental.end_time.strftime(" %H:%M %z")).to_time
          overlap = ( lab_rental_start.utc - (time_start.utc + duration * 60 * 60) ) * ( time_start.utc - lab_rental_end.utc )
          count += 1 if overlap >= 0
        end
      end
      @time_starts[index] = nil if count >= @pods
    end
    @time_starts.compact!
  end

  def reserve
    @time_zone  = params[:time_zone]
    @start_time = params[:time_start].to_time.in_time_zone(@time_zone)
    @end_time   = @start_time + 60 * 60 * @time_block.unit_quantity
    @first_day  = @start_time.to_date
    @last_day   = @end_time.to_date
    lab_rental  = LabRental.new(
      end_time: @end_time,
      first_day: @first_day,
      lab_course_id: @time_block.lab_course.id,
      last_day: @last_day,
      level: @time_block.level,
      notes: "Created through self checkout.",
      num_of_students: @time_block.ratio,
      start_time: @start_time,
      time_zone: @time_zone,
      user_id: current_user.id
    )

    if lab_rental.save
      order_item = OrderItem.new(
      orderable_type: "LabRental",
      orderable_id: lab_rental.id,
      cart_id: @cart.id,
      price: @time_block.price,
      user_id: current_user.id,
      note: "Created through self checkout."
      )
      if order_item.save
        flash[:success] = "Item successfully added to cart! Please go to #{view_context.link_to "My Cart", new_order_path} to complete transaction".html_safe
      else
        flash[:alert] = "Failed to add time block to cart!"
      end
    else
      flash[:alert] = "Failed to add time block to cart!"
    end
    redirect_to :back
  end

  private

  def time_block_params
    params.require(:lab_course_time_block).permit(
      :lab_course_id,
      :level,
      :price,
      :ratio,
      :title,
      :unit_size,
      :unit_quantity
    )
  end

  def lab_rental_params
    params.require(:lab_rental).permit(
      :end_time,
      :first_day,
      :lab_course_id,
      :last_day,
      :notes,
      :num_of_students,
      :start_time,
      :time_zone,
      :user_id
    )
  end

  def set_time_block
    @time_block = LabCourseTimeBlock.find(params[:id])
  end

  def authorize_lab_course_time_block
    redirect_to root_url unless current_user.admin?
  end

  def build_time_starts
    if params[:date_start]
      @time_starts =* (0..23).map do |n|
        n = Time.mktime(
        params[:date_start].to_time.year,
        params[:date_start].to_time.month,
        params[:date_start].to_time.day,
        n,
        0)
        set_in_timezone(n, params[:time_zone][0])
      end
    else
      @time_starts =* (0..23).map do |n|
        n = (n.to_s + ":00").to_time
      end
    end
  end

  def determine_pods
    @pods = 0
    @pods += Setting.pods[:available_pods_for_partners] if @time_block.level == "partner"
    @pods += Setting.pods[:available_pods_for_individuals] if @time_block.level == 'individual'
  end

  def set_in_timezone(time, zone)
    ActiveSupport::TimeZone[zone].parse(time.asctime)
  end
end
