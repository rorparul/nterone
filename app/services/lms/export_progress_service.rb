require 'csv'

class Lms::ExportProgressService
  def initialize(students)
    @students = students
    @resources = []

    @students.each_with_index do |student, i|
      append_student_resources(student, i)
    end
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      @resources.each { |r| csv << r }
    end
  end

  def get_resources
    @resources
  end

private

  def append_student_resources(student, i)
    student.assigned_vods.each do |vod|
      vod.all_exams.each { |exam| @resources << exam_data(i, student, exam) }
      vod.all_videos.each { |video| @resources << video_data(i, student, video) }
    end
  end

  def column_names
    ['Index', 'Student name', 'Type', 'Name', 'Status']
  end

  def video_data(i, student, video)
    status = video.status_for(student) || 'never started'
    [i + 1, student.full_name, 'Video', video.title, status]
  end

  def exam_data(i, student, exam)
    [i + 1, student.full_name, 'Exam', exam.title, exam.status_for(student)]
  end
end
