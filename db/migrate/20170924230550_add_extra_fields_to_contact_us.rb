class AddExtraFieldsToContactUs < ActiveRecord::Migration
  def change
    add_column :contact_us_submissions, :recipient, :string
    add_column :contact_us_submissions, :subject, :string
  end
end
