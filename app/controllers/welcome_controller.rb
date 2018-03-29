class WelcomeController < ApplicationController
  def index
    @page = Page.find_by(title: 'Welcome')
    set_featured_courses
  end

  private

  def set_featured_courses
    @featured_course_1 = Course.find_by(id: Setting.featured_course_1_id)
    @featured_course_2 = Course.find_by(id: Setting.featured_course_2_id)
    @featured_course_3 = Course.find_by(id: Setting.featured_course_3_id)
    @featured_course_4 = Course.find_by(id: Setting.featured_course_4_id)
  end
end
