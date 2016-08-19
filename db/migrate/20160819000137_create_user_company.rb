class CreateUserCompany < ActiveRecord::Migration
  def change
    create_table :user_companies do |t|
      t.references :user, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true
    end
  end
end
