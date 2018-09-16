class AddResumeUploadToContactInfo < ActiveRecord::Migration
  def change
    add_column :contact_infos, :resume_upload, :string
  end
end
