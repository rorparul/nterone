module CourseHelper
  def grouped_courses_options(courses)
    groups = courses.group_by { |course| course.platform }
    groups.collect do |group|
      [
        group.first.try(:title), group.second.collect do |course|
          [course.full_title, course.id]
        end
      ]
    end
  end
end
