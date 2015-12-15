class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.string :quotation
      t.string :author
      t.string :course
      t.timestamps null: false
    end
  end
end
