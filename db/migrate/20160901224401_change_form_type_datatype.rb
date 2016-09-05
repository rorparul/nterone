class ChangeFormTypeDatatype < ActiveRecord::Migration
  def change
    remove_column :companies, :form_type
    add_column    :companies, :form_type, :integer
  end
end
