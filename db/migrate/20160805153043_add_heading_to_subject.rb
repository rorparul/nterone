class AddHeadingToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :heading, :string
  end
end
