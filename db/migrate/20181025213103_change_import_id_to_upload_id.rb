class ChangeImportIdToUploadId < ActiveRecord::Migration
  def change
    rename_column :events, :import_id, :upload_id
  end
end
