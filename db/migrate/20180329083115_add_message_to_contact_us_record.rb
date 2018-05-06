class AddMessageToContactUsRecord < ActiveRecord::Migration
  def change
    add_column :contact_us_submissions, :message, :text, default: ''
  end
end
