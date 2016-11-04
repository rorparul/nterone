class AddVideoModuleRefToLmsExams < ActiveRecord::Migration
  def change
    add_reference :lms_exams, :video_module, index: true, foreign_key: true
  end
end
