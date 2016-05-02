class ChangeExams < ActiveRecord::Migration
	def change
    add_column :exams, :description, :text
    add_column :exams, :type, :integer
  end
end
