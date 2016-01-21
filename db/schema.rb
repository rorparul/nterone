# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160121040236) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "announcements", force: :cascade do |t|
    t.text     "content"
    t.string   "audience"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "status",     default: "open"
    t.string   "poster"
  end

  create_table "attendances", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carousel_items", force: :cascade do |t|
    t.string   "caption"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "active",     default: true
    t.string   "url"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "platform_id"
    t.string   "title"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["platform_id"], name: "index_categories_on_platform_id", using: :btree

  create_table "category_courses", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "course_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "category_subjects", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_video_on_demands", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "video_on_demand_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "chosen_courses", force: :cascade do |t|
    t.integer  "course_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "status"
    t.boolean  "planned",    default: false
    t.boolean  "attended",   default: false
    t.boolean  "passed",     default: false
    t.integer  "user_id"
  end

  create_table "course_dynamics", force: :cascade do |t|
    t.integer  "exam_and_course_dynamic_id"
    t.integer  "course_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "platform_id"
    t.boolean  "active",            default: true
    t.string   "abbreviation"
    t.string   "sku"
    t.text     "intro"
    t.text     "overview"
    t.text     "outline"
    t.text     "intended_audience"
    t.string   "course_info"
    t.text     "video_preview"
    t.string   "url"
    t.integer  "price"
  end

  create_table "custom_items", force: :cascade do |t|
    t.text     "content"
    t.string   "shortname"
    t.string   "url"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "platform_id"
    t.boolean  "is_header",   default: false
  end

  create_table "dividers", force: :cascade do |t|
    t.integer  "platform_id"
    t.string   "content"
    t.string   "shortname"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "events", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "format"
    t.decimal  "price",           precision: 8, scale: 2
    t.integer  "instructor_id"
    t.integer  "course_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.boolean  "guaranteed",                              default: false
    t.boolean  "active",                                  default: true
    t.time     "start_time"
    t.time     "end_time"
    t.string   "city"
    t.string   "state"
    t.string   "status"
    t.string   "lab_source"
    t.boolean  "public",                                  default: true
    t.decimal  "cost_instructor", precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_lab",        precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_te",         precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_facility",   precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_books",      precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_shipping",   precision: 8, scale: 2, default: 0.0
  end

  create_table "exam_and_course_dynamics", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "platform_id"
  end

  create_table "exam_dynamics", force: :cascade do |t|
    t.integer  "exam_and_course_dynamic_id"
    t.integer  "exam_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "exams", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "platform_id"
  end

  create_table "forums", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "group_items", force: :cascade do |t|
    t.integer  "groupable_id"
    t.string   "groupable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "group_id"
    t.integer  "position"
  end

  add_index "group_items", ["groupable_type", "groupable_id"], name: "index_group_items_on_groupable_type_and_groupable_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "header"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "platform_id"
  end

  create_table "images", force: :cascade do |t|
    t.string  "file"
    t.integer "imageable_id"
    t.string  "imageable_type"
  end

  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree

  create_table "instructors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "biography"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "platform_id"
  end

  create_table "leads", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "status",     default: "unassigned"
    t.string   "discount",   default: "0"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "announcement_id"
    t.boolean  "read",            default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "orderable_id"
    t.string   "orderable_type"
    t.integer  "cart_id"
    t.decimal  "price"
    t.integer  "order_id"
    t.integer  "user_id"
    t.integer  "ownable_id"
    t.string   "ownable_type"
    t.integer  "seller_id"
    t.integer  "buyer_id"
  end

  add_index "order_items", ["buyer_id"], name: "index_order_items_on_buyer_id", using: :btree
  add_index "order_items", ["orderable_id"], name: "index_order_items_on_orderable_id", using: :btree
  add_index "order_items", ["ownable_id"], name: "index_order_items_on_ownable_id", using: :btree
  add_index "order_items", ["seller_id"], name: "index_order_items_on_seller_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "auth_code"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.string   "email"
    t.string   "clc_number"
    t.string   "clc_quantity"
    t.string   "name_on_card"
    t.string   "billing_zip_code"
    t.decimal  "paid",             precision: 8, scale: 2
    t.string   "billing_street"
    t.string   "billing_city"
    t.string   "billing_state"
    t.integer  "seller_id"
    t.integer  "buyer_id"
  end

  add_index "orders", ["buyer_id"], name: "index_orders_on_buyer_id", using: :btree
  add_index "orders", ["seller_id"], name: "index_orders_on_seller_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "passed_exams", force: :cascade do |t|
    t.integer  "planned_subject_id"
    t.integer  "exam_id"
    t.boolean  "passed",             default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "user_id"
  end

  create_table "planned_subjects", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.string   "status"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",     default: true
    t.boolean  "read",       default: false
  end

  create_table "platforms", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prep_items", force: :cascade do |t|
    t.integer  "exam_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchased_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "purchasable_id"
    t.string   "purchasable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "purchased_items", ["purchasable_type", "purchasable_id"], name: "index_purchased_items_on_purchasable_type_and_purchasable_id", using: :btree

  create_table "quotes", force: :cascade do |t|
    t.integer  "lead_id"
    t.text     "content"
    t.string   "quote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "relationships", ["buyer_id"], name: "index_relationships_on_buyer_id", using: :btree
  add_index "relationships", ["seller_id", "buyer_id"], name: "index_relationships_on_seller_id_and_buyer_id", unique: true, using: :btree
  add_index "relationships", ["seller_id"], name: "index_relationships_on_seller_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subject_groups", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation"
    t.integer  "platform_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "video_on_demand_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "testimonials", force: :cascade do |t|
    t.string   "quotation"
    t.string   "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "company"
    t.integer  "course_id"
  end

  create_table "topics", force: :cascade do |t|
    t.integer  "forum_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_events", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_vods", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "video_on_demand_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",          null: false
    t.string   "encrypted_password",     default: "",          null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "company_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "contact_number"
    t.string   "gender",                 default: "undefined"
    t.string   "country"
    t.string   "website"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.boolean  "archived",               default: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.datetime "last_active_at"
    t.string   "billing_street"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zip_code"
    t.boolean  "same_addresses",         default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "video_modules", force: :cascade do |t|
    t.integer  "video_on_demand_id"
    t.string   "title"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "video_on_demands", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "instructor_id"
    t.string   "level"
    t.decimal  "price",         precision: 8, scale: 2
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "platform_id"
    t.string   "title"
    t.string   "abbreviation"
  end

  create_table "videos", force: :cascade do |t|
    t.integer  "video_module_id"
    t.string   "title"
    t.string   "url"
    t.text     "embed_code"
    t.boolean  "free"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
