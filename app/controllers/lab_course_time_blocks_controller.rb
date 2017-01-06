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

  def set_time_block
    @time_block = LabCourseTimeBlock.find(params[:id])
  end

  def authorize_lab_course_time_block
    redirect_to root_url unless current_user.admin?
  end
end
