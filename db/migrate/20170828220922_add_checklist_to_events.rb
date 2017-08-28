class AddChecklistToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :checklist, index: true, foreign_key: true
  end
end
