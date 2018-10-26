class AddImportIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :import_id, :string
  end
end
