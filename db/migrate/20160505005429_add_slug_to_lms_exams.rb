class AddSlugToLmsExams < ActiveRecord::Migration
  def change
    add_column :lms_exams, :slug, :string
  end
end
