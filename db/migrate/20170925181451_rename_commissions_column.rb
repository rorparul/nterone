class RenameCommissionsColumn < ActiveRecord::Migration
  def change
    rename_column :events, :commission_override, :cost_commission
    add_column    :events, :autocalculate_cost_commission, :boolean, default: true
  end
end
