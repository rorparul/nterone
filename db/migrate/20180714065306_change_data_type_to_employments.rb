class ChangeDataTypeToEmployments < ActiveRecord::Migration
  remove_column :employments, :start_date
  remove_column :employments, :end_date
  add_column :employments, :start_date, :date
  add_column :employments, :end_date, :date
end
