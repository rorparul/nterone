class AddVideoOnDemandIdToLmsExam < ActiveRecord::Migration
  def change
    add_reference :lms_exams, :video_on_demand, index: true, foreign_key: true
  end
end
