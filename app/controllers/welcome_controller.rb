class WelcomeController < ApplicationController
  def index
    @page = Page.find_by(title: 'Welcome')
    set_featured_courses
  end

  private

  def set_featured_courses
    @amazon    = Platform.find_by(title: 'Web Services by Amazon')
    @cisco     = Platform.find_by(title: 'Cisco')
    @itil      = Platform.find_by(title: 'ITIL')
    @microsoft = Platform.find_by(title: 'Microsoft')
    @vmware    = Platform.find_by(title: 'VMware')

    @featured_course_1 = Course.find_by(id: YAML.load(Setting.featured_course_1_id)[$tld])
    @featured_course_2 = Course.find_by(id: YAML.load(Setting.featured_course_2_id)[$tld])
    @featured_course_3 = Course.find_by(id: YAML.load(Setting.featured_course_3_id)[$tld])
    @featured_course_4 = Course.find_by(id: YAML.load(Setting.featured_course_4_id)[$tld])
    rescue
  end
end
