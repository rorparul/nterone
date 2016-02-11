class ChosenCoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chosen_course

  def toggle_active
    if @course
      @course.toggle!(:planned)
    else
      @course = ChosenCourse.create(chosen_course_params)
      @course.update_attributes(planned: true)
    end
    @grand_total = view_context.formatted_price_or_range_of_my_plan_for(@course.user)
  end

  def toggle_attended
    if @course
      @course.toggle!(:attended)
    else
      @course = ChosenCourse.create(chosen_course_params)
      @course.update_attributes(attended: true)
    end
    @grand_total = view_context.formatted_price_or_range_of_my_plan_for(@course.user)
  end

  private

  def set_chosen_course
    @course = ChosenCourse.find_by(chosen_course_params)
  end

  def chosen_course_params
    params.require(:chosen_course).permit(:user_id, :course_id, :status)
  end
end
