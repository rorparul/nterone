class AddAutoCalculateInstructorCostsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :autocalculate_instructor_costs, :boolean, default: true
  end
end
