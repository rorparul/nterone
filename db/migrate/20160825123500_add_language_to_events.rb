class AddLanguageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :language, :integer, default: 0
  end
end
