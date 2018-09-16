class AddColumnToJobApplicants < ActiveRecord::Migration
  def change
    add_column :job_applicants, :phone, :integer
  end
end
