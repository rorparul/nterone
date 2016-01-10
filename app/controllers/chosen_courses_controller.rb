class ChosenCoursesController < ApplicationController
  def toggle_active
    @course = ChosenCourse.find_by(chosen_course_params)
    if @course
      @course.toggle!(:planned)
    else
      @course = ChosenCourse.create(chosen_course_params)
      @course.update_attributes(planned: true)
    end
    @grand_total = view_context.formatted_price_or_range_of_my_plan_for(@course.user)
  end

  def toggle_attended
    @course = ChosenCourse.find_by(chosen_course_params)
    if @course
      @course.toggle!(:attended)
    else
      @course = ChosenCourse.create(chosen_course_params)
      @course.update_attributes(attended: true)
    end
    @grand_total = view_context.formatted_price_or_range_of_my_plan_for(@course.user)
  end

  private

  def chosen_course_params
    params.require(:chosen_course).permit(:user_id, :course_id, :status)
  end
end
