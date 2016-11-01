class Lms::ExportController < Lms::BaseController
  before_action :authenticate_user!
  before_action :set_students

  def grades
    authorize :lms_export, :grades?

    csv_exporter = Lms::ExportGradesService.new(@students)
    @exams = csv_exporter.get_exams

    respond_to do |format|
      format.csv { send_data csv_exporter.to_csv }
      format.xlsx
    end
  end

  def progress
    authorize :lms_export, :progress?

    csv_exporter = Lms::ExportProgressService.new(@students)
    @resources = csv_exporter.get_resources

    respond_to do |format|
      format.csv { send_data csv_exporter.to_csv }
      format.xlsx
    end
  end

  private

  def set_students
    @students = current_user.lms_business? ? User.lms_students_all : current_user.lms_students
  end
end
