class ChangeApplicantPhoneToString < ActiveRecord::Migration
  def change
    change_column :job_applicants, :phone, :string, default: ''
  end
end
