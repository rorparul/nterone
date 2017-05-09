module LmsStudentHelper
  def watched_count_class(course, student)
    completed = course.watched_count(student) == course.video_count && course.video_count != 0
    completed ? 'label-success' : 'label-default'
  end

  def quizes_completed_class(course, student)
    completed = course.quizes_completed_count_by(student) == course.quizes_count && course.quizes_count != 0
    completed ? 'label-success' : 'label-default'
  end
end
