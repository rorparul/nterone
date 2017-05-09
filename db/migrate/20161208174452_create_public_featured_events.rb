class CreatePublicFeaturedEvents < ActiveRecord::Migration
  def change
    create_table :public_featured_events do |t|
      t.string :full_title
      t.string :platform_course_url
      t.date :start_date
      t.date :end_date
      t.integer :length
      t.string :format
      t.string :language
      t.string :city
      t.string :state
      t.string :street
      t.decimal :price, precision: 8, scale: 2, default: 0.0
      t.text :video_preview
      t.string :link_to_cart
      t.string :pdf_url
      t.integer :platform_id
      t.string :platform_title

      t.timestamps null: false
    end
  end
end
