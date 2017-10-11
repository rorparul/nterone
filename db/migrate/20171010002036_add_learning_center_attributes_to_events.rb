class AddLearningCenterAttributesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :country_code,       :string
    add_column :events, :location,           :string
    add_column :events, :registration_url,   :string
    add_column :events, :registration_phone, :string
    add_column :events, :registration_fax,   :string
    add_column :events, :registration_email, :string
    add_column :events, :site_id,            :string
  end
end
