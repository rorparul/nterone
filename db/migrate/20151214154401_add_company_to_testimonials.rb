class AddCompanyToTestimonials < ActiveRecord::Migration
  def change
    add_column :testimonials, :company, :string
  end
end
