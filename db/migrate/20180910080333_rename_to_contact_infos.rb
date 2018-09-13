class RenameToContactInfos < ActiveRecord::Migration
  def change
    rename_table :contact_infos, :job_applicants
  end
end
