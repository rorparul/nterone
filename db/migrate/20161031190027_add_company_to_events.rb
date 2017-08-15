class AddCompanyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :company, :string
  end
end
