class ChangePhoneDataTypeToJobApplicants < ActiveRecord::Migration
  def change
    change_column :job_applicants, :phone, :string
  end
end
