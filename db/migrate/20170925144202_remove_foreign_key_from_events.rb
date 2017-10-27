class RemoveForeignKeyFromEvents < ActiveRecord::Migration
  def change
    remove_foreign_key :events, :checklist
  end
end
