class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :message

      t.timestamps null: false
    end
  end
end
