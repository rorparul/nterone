class AddFieldsToPublicFeaturedEvents < ActiveRecord::Migration
  def change
    add_column :public_featured_events, :host, :string
    add_column :public_featured_events, :event_id, :integer
  end
end
