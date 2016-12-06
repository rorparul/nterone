require 'csv'

class CSV::ExportCourseService
  def initialize(courses)
    @courses = courses
  end

  def to_csv(options={})
    CSV.generate(headers: true) do |csv|
      csv << headers

      @courses.each do |course|
        csv << row(course)
      end
    end
  end

private

  def headers
    [
      I18n.t('courses.export.vendor'),
      I18n.t('courses.export.abbreviation'),
      I18n.t('courses.export.title'),
      I18n.t('courses.export.price'),
      I18n.t('courses.export.intro'),
      I18n.t('courses.export.overview'),
      I18n.t('courses.export.outline'),
      I18n.t('courses.export.intended_audience'),
      I18n.t('courses.export.slug'),
      I18n.t('courses.export.url'),
      I18n.t('courses.export.categories')
    ]
  end

  def row course
    [
      course.platform.try(:title),
      course.abbreviation,
      course.title,
      ApplicationController.helpers.formatted_price_or_range_of_upcoming_events_for(course),
      course.intro.try(:html_safe),
      course.overview.try(:html_safe),
      course.outline.try(:html_safe),
      course.intended_audience.try(:html_safe),
      course.slug,
      Rails.application.routes.url_helpers.platform_course_url(course.platform, course),
      course.categories.to_a.map(&:title).join(', ')
    ]
  end

end
