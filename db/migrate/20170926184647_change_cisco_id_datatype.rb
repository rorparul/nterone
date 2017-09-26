class ChangeCiscoIdDatatype < ActiveRecord::Migration
  def change
    change_column :courses, :cisco_id, :string
  end
end
