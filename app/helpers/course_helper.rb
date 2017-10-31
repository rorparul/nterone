module CourseHelper
  def grouped_courses_options(courses)
    groups = courses.group_by { |course| course.platform }
    groups.collect do |group|
      [
        group.first.try(:title), group.second.collect do |course|
          ["#{course.full_title} #{active_regions_tags(course)}", course.id]
        end
      ]
    end
  end

  def active_regions_tags(course)
    tags = ""
    course.active_regions.each { |ar| tags += ar.humanize.upcase if ar.present? }
    tags.present? ? " for #{tags}" : tags
  end
end
