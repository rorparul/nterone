class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string   "email",                                           default: "",               null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "company_name"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "contact_number"
      t.string   "country"
      t.string   "website"
      t.string   "street"
      t.string   "city"
      t.string   "state"
      t.string   "zipcode"
      t.boolean  "archived",                                        default: false
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email"
      t.string   "billing_street"
      t.string   "billing_city"
      t.string   "billing_state"
      t.string   "billing_zip_code"
      t.boolean  "same_addresses",                                  default: false
      t.boolean  "forem_admin",                                     default: false
      t.string   "forem_state",                                     default: "pending_review"
      t.boolean  "forem_auto_subscribe",                            default: false
      t.string   "billing_first_name"
      t.string   "billing_last_name"
      t.string   "shipping_first_name"
      t.string   "shipping_last_name"
      t.string   "shipping_street"
      t.string   "shipping_city"
      t.string   "shipping_state"
      t.string   "shipping_zip_code"
      t.string   "shipping_company"
      t.string   "billing_company"
      t.string   "referring_partner_email"
      t.integer  "company_id"
      t.text     "about"
      t.integer  "status",                                          default: 0
      t.decimal  "daily_rate",              precision: 8, scale: 2, default: 0.0
      t.text     "video_bio"
      t.string   "source_name"
      t.string   "source_user_id"
      t.integer  "parent_id"
      t.string   "salutation"
      t.string   "business_title"
      t.boolean  "do_not_call"
      t.boolean  "do_not_email"
      t.string   "email_alternative"
      t.string   "phone_alternative"
      t.text     "notes"
      t.string   "aasm_state"
      t.integer  "origin_region"
      t.text     "active_regions",                                  default: [],                            array: true
      t.boolean  "active",                                          default: true
      t.boolean  "archive",                                         default: false
      t.string   "sales_force_id"
    end
  end
end
