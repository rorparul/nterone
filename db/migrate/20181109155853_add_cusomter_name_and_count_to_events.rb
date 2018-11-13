class AddCusomterNameAndCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :customer_name, :string, default: ''
    add_column :events, :estimated_student_count, :integer, default: 0
  end
end
