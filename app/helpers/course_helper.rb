module CourseHelper
  def grouped_courses_options(courses)
    groups = courses.group_by { |course| course.platform }
    groups.collect do |group|
      [group.first.title, group.second.collect { |course| ["#{course.full_title}", course.id] }]
    end
  end
end
