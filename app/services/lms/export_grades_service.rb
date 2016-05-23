require 'csv'

class Lms::ExportGradesService
  def initialize(students)
    @students = students
    @exams = []

    @students.each_with_index do |student, i|
      append_student_exams(student, i)
    end
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      @exams.each { |r| csv << r }
    end
  end

  def get_exams
    @exams
  end

private

  def append_student_exams(student, i)
    student.assigned_vods.each do |vod|
      exam = vod.course_exam
      @exams << exam_data(i, student, vod, exam) if exam.present?
    end
  end

  def column_names
    ['Index', 'Student name', 'Course Name', 'Exam Name', 'Status']
  end

  def exam_data(i, student, vod, exam)
    [i + 1, student.full_name, vod.title, exam.title, exam.status_for(student)]
  end
end
