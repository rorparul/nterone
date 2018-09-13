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

ActiveRecord::Schema.define(version: 20180912093417) do

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

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string   "page_title"
    t.text     "page_description"
    t.text     "content"
    t.string   "slug"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "kind"
    t.string   "title"
    t.integer  "origin_region"
    t.text     "active_regions",   default: [],              array: true
  end

  add_index "articles", ["origin_region"], name: "index_articles_on_origin_region", using: :btree

  create_table "assign_quizzes", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "lms_exam_id"
    t.integer  "video_module_id"
    t.integer  "position"
  end

  create_table "assigned_items", force: :cascade do |t|
    t.integer  "assigner_id"
    t.integer  "student_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "assigned_items", ["item_type", "item_id"], name: "index_assigned_items_on_item_type_and_item_id", using: :btree
  add_index "assigned_items", ["origin_region"], name: "index_assigned_items_on_origin_region", using: :btree

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "source_name"
    t.string   "source_user_id"
    t.string   "source_hash"
    t.integer  "user_id"
    t.integer  "origin_region"
    t.text     "active_regions",             default: [],              array: true
    t.string   "token"
    t.datetime "notified_not_empty_cart_at"
  end

  add_index "carts", ["origin_region"], name: "index_carts_on_origin_region", using: :btree
  add_index "carts", ["token"], name: "index_carts_on_token", using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "platform_id"
    t.string   "title"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "position_as_parent", default: 0
    t.integer  "position_as_child",  default: 0
    t.integer  "position",           default: 0
    t.text     "description"
    t.string   "page_title"
    t.string   "heading"
    t.text     "meta_description"
    t.text     "video"
    t.integer  "origin_region"
    t.text     "active_regions",     default: [],    array: true
    t.boolean  "archived",           default: false
  end

  add_index "categories", ["origin_region"], name: "index_categories_on_origin_region", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["platform_id"], name: "index_categories_on_platform_id", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "category_courses", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "course_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "category_courses", ["origin_region"], name: "index_category_courses_on_origin_region", using: :btree

  create_table "category_subjects", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "origin_region"
    t.text     "active_regions", default: [], array: true
  end

  add_index "category_subjects", ["origin_region"], name: "index_category_subjects_on_origin_region", using: :btree

  create_table "category_video_on_demands", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "video_on_demand_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "origin_region"
    t.text     "active_regions",     default: [],              array: true
  end

  add_index "category_video_on_demands", ["origin_region"], name: "index_category_video_on_demands_on_origin_region", using: :btree

  create_table "checklist_items", force: :cascade do |t|
    t.integer  "checklist_id"
    t.text     "content"
    t.datetime "completed_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "checklist_items", ["checklist_id"], name: "index_checklist_items_on_checklist_id", using: :btree
  add_index "checklist_items", ["origin_region"], name: "index_checklist_items_on_origin_region", using: :btree

  create_table "checklist_items_events", force: :cascade do |t|
    t.integer  "checklist_item_id", null: false
    t.integer  "event_id",          null: false
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  add_index "checklist_items_events", ["checklist_item_id", "event_id"], name: "index_checklist_items_events_on_checklist_item_id_and_event_id", using: :btree

  create_table "checklists", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "name"
    t.text     "active_regions", default: [],              array: true
    t.integer  "origin_region"
  end

  add_index "checklists", ["origin_region"], name: "index_checklists_on_origin_region", using: :btree

  create_table "chosen_courses", force: :cascade do |t|
    t.integer  "course_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "status"
    t.boolean  "planned",                          default: false
    t.boolean  "attended",                         default: false
    t.boolean  "passed",                           default: false
    t.integer  "user_id"
    t.integer  "origin_region"
    t.text     "active_regions",                   default: [],                 array: true
    t.boolean  "audit_complete",                   default: false
    t.boolean  "completed_all_labs",               default: false
    t.boolean  "met_with_course_director",         default: false
    t.string   "audit_complete_by_user"
    t.string   "completed_all_labs_by_user"
    t.string   "met_with_course_director_by"
    t.date     "audit_complete_by_date"
    t.date     "completed_all_labs_by_date"
    t.date     "met_with_course_director_by_date"
  end

  add_index "chosen_courses", ["origin_region"], name: "index_chosen_courses_on_origin_region", using: :btree

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title"
    t.integer  "form_type"
    t.string   "slug"
    t.integer  "user_id"
    t.string   "kind"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone"
    t.string   "website"
    t.integer  "parent_id"
    t.string   "industry_code"
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
    t.string   "sales_force_id"
  end

  add_index "companies", ["origin_region"], name: "index_companies_on_origin_region", using: :btree

  create_table "contact_us_submissions", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "inquiry"
    t.string   "feedback"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "recipient"
    t.string   "subject"
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
    t.text     "message",        default: ""
  end

  add_index "contact_us_submissions", ["origin_region"], name: "index_contact_us_submissions_on_origin_region", using: :btree

  create_table "course_dynamics", force: :cascade do |t|
    t.integer  "exam_and_course_dynamic_id"
    t.integer  "course_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "origin_region"
    t.text     "active_regions",             default: [],              array: true
  end

  add_index "course_dynamics", ["origin_region"], name: "index_course_dynamics_on_origin_region", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "platform_id"
    t.boolean  "active",                                          default: true
    t.string   "abbreviation"
    t.text     "intro"
    t.text     "overview"
    t.text     "outline"
    t.text     "intended_audience"
    t.string   "pdf"
    t.text     "video_preview"
    t.decimal  "price",                   precision: 8, scale: 2, default: 0.0
    t.string   "slug"
    t.string   "page_title"
    t.text     "page_description"
    t.boolean  "partner_led",                                     default: false
    t.string   "heading"
    t.boolean  "satellite_viewable",                              default: true
    t.integer  "origin_region"
    t.text     "active_regions",                                  default: [],                 array: true
    t.string   "cisco_id"
    t.boolean  "archived",                                        default: false
    t.decimal  "book_cost_per_student",                           default: 0.0
    t.text     "featured_course_summary",                         default: ""
    t.boolean  "exclude_from_revenue",                            default: false
  end

  add_index "courses", ["origin_region"], name: "index_courses_on_origin_region", using: :btree
  add_index "courses", ["slug"], name: "index_courses_on_slug", using: :btree

  create_table "custom_items", force: :cascade do |t|
    t.text     "content"
    t.string   "shortname"
    t.string   "url"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "platform_id"
    t.boolean  "is_header",      default: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],                 array: true
    t.boolean  "archived",       default: false
  end

  add_index "custom_items", ["origin_region"], name: "index_custom_items_on_origin_region", using: :btree

  create_table "discount_filters", force: :cascade do |t|
    t.integer "discount_id"
    t.boolean "event"
    t.boolean "vod"
    t.string  "event_format"
    t.boolean "event_guaranteed"
    t.integer "event_course_id"
    t.string  "event_city"
    t.string  "event_state"
    t.boolean "event_partner_led"
    t.integer "event_language"
    t.integer "vod_platform_id"
    t.boolean "vod_partner_led"
    t.boolean "vod_lms"
    t.integer "origin_region"
    t.text    "active_regions",    default: [], array: true
  end

  add_index "discount_filters", ["origin_region"], name: "index_discount_filters_on_origin_region", using: :btree

  create_table "discounts", force: :cascade do |t|
    t.boolean "active",                                 default: true
    t.date    "date_end"
    t.date    "date_start"
    t.integer "limit"
    t.string  "code"
    t.string  "kind"
    t.decimal "value",          precision: 8, scale: 2, default: 0.0
    t.integer "origin_region"
    t.text    "active_regions",                         default: [],   array: true
  end

  add_index "discounts", ["origin_region"], name: "index_discounts_on_origin_region", using: :btree

  create_table "dividers", force: :cascade do |t|
    t.integer  "platform_id"
    t.string   "content"
    t.string   "shortname"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],                 array: true
    t.boolean  "archived",       default: false
  end

  add_index "dividers", ["origin_region"], name: "index_dividers_on_origin_region", using: :btree

  create_table "events", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "format"
    t.decimal  "price",                          precision: 8, scale: 2, default: 0.0
    t.integer  "instructor_id"
    t.integer  "course_id"
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.boolean  "guaranteed",                                             default: false
    t.boolean  "active",                                                 default: true
    t.time     "start_time"
    t.time     "end_time"
    t.string   "city"
    t.string   "state"
    t.string   "status",                                                 default: "Pending"
    t.string   "lab_source"
    t.boolean  "public",                                                 default: true
    t.decimal  "cost_instructor",                precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_lab",                       precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_te",                        precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_facility",                  precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_books",                     precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_shipping",                  precision: 8, scale: 2, default: 0.0
    t.boolean  "partner_led",                                            default: false
    t.string   "time_zone"
    t.boolean  "sent_all_webex_invite",                                  default: false
    t.boolean  "sent_all_course_material",                               default: false
    t.boolean  "sent_all_lab_credentials",                               default: false
    t.boolean  "should_remind",                                          default: false
    t.integer  "remind_period",                                          default: 0
    t.boolean  "reminder_sent",                                          default: false
    t.text     "note"
    t.boolean  "count_weekends",                                         default: false
    t.text     "in_house_note"
    t.string   "street"
    t.integer  "language",                                               default: 0
    t.boolean  "calculate_book_costs",                                   default: true
    t.boolean  "autocalculate_instructor_costs",                         default: true
    t.boolean  "resell",                                                 default: false
    t.string   "zipcode"
    t.integer  "origin_region"
    t.text     "active_regions",                                         default: [],                     array: true
    t.string   "company"
    t.integer  "checklist_id"
    t.decimal  "cost_commission",                precision: 8, scale: 2, default: 0.0
    t.boolean  "autocalculate_cost_commission",                          default: true
    t.boolean  "do_not_send_instructor_email",                           default: false
    t.string   "country_code"
    t.string   "location"
    t.string   "registration_url"
    t.string   "registration_phone"
    t.string   "registration_fax"
    t.string   "registration_email"
    t.string   "site_id"
    t.boolean  "archived",                                               default: false
    t.decimal  "book_cost_per_student",          precision: 8, scale: 2, default: 0.0
  end

  add_index "events", ["checklist_id"], name: "index_events_on_checklist_id", using: :btree
  add_index "events", ["origin_region"], name: "index_events_on_origin_region", using: :btree

  create_table "exam_and_course_dynamics", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "platform_id"
    t.integer  "origin_region"
    t.text     "active_regions", default: [],                 array: true
    t.boolean  "archived",       default: false
  end

  add_index "exam_and_course_dynamics", ["origin_region"], name: "index_exam_and_course_dynamics_on_origin_region", using: :btree

  create_table "exam_dynamics", force: :cascade do |t|
    t.integer  "exam_and_course_dynamic_id"
    t.integer  "exam_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "origin_region"
    t.text     "active_regions",             default: [],              array: true
  end

  add_index "exam_dynamics", ["origin_region"], name: "index_exam_dynamics_on_origin_region", using: :btree

  create_table "exams", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "platform_id"
    t.integer  "origin_region"
    t.text     "active_regions", default: [],                 array: true
    t.boolean  "archived",       default: false
  end

  add_index "exams", ["origin_region"], name: "index_exams_on_origin_region", using: :btree

  create_table "forums", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "group_items", force: :cascade do |t|
    t.integer  "groupable_id"
    t.string   "groupable_type"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "group_id"
    t.integer  "position"
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "group_items", ["groupable_type", "groupable_id"], name: "index_group_items_on_groupable_type_and_groupable_id", using: :btree
  add_index "group_items", ["origin_region"], name: "index_group_items_on_origin_region", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "header"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "platform_id"
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "groups", ["origin_region"], name: "index_groups_on_origin_region", using: :btree

  create_table "guests", force: :cascade do |t|
    t.string   "email",                                           default: "",    null: false
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
    t.text     "active_regions",                                  default: [],                 array: true
    t.boolean  "active",                                          default: true
    t.boolean  "archive",                                         default: false
    t.string   "sales_force_id"
  end

  add_index "guests", ["origin_region"], name: "index_guests_on_origin_region", using: :btree

  create_table "hacp_requests", force: :cascade do |t|
    t.string   "aicc_sid"
    t.boolean  "used",           default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.integer  "origin_region"
    t.text     "active_regions", default: [],                 array: true
  end

  add_index "hacp_requests", ["origin_region"], name: "index_hacp_requests_on_origin_region", using: :btree

  create_table "images", force: :cascade do |t|
    t.string  "file"
    t.integer "imageable_id"
    t.string  "imageable_type"
    t.integer "origin_region"
    t.text    "active_regions", default: [], array: true
  end

  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree
  add_index "images", ["origin_region"], name: "index_images_on_origin_region", using: :btree

  create_table "instructors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "biography"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "platform_id"
    t.integer  "status",         default: 0
    t.integer  "origin_region"
    t.text     "active_regions", default: [],                 array: true
    t.boolean  "archived",       default: false
  end

  add_index "instructors", ["origin_region"], name: "index_instructors_on_origin_region", using: :btree

  create_table "interests", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "data_center"
    t.boolean  "collaboration"
    t.boolean  "network"
    t.boolean  "security"
    t.boolean  "associate_level_certification"
    t.boolean  "professional_level_certification"
    t.boolean  "expert_level_certification"
    t.string   "other"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "origin_region"
    t.text     "active_regions",                   default: [],              array: true
  end

  add_index "interests", ["origin_region"], name: "index_interests_on_origin_region", using: :btree

  create_table "job_applicants", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "message"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "resume_upload"
    t.string   "phone",         default: ""
  end

  create_table "lab_course_time_blocks", force: :cascade do |t|
    t.integer "lab_course_id"
    t.decimal "unit_size",      precision: 4, scale: 2, default: 1.0
    t.integer "unit_quantity"
    t.integer "ratio",                                  default: 1
    t.decimal "price",          precision: 8, scale: 2, default: 0.0
    t.string  "level"
    t.integer "origin_region"
    t.text    "active_regions",                         default: [],  array: true
  end

  add_index "lab_course_time_blocks", ["origin_region"], name: "index_lab_course_time_blocks_on_origin_region", using: :btree

  create_table "lab_courses", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "company_id"
    t.text     "description"
    t.string   "slug"
    t.string   "abbreviation"
    t.text     "card_description"
    t.string   "level",            default: "both"
    t.integer  "pods_individual",  default: 0
    t.integer  "pods_partner",     default: 0
    t.integer  "origin_region"
    t.text     "active_regions",   default: [],                  array: true
  end

  add_index "lab_courses", ["origin_region"], name: "index_lab_courses_on_origin_region", using: :btree

  create_table "lab_rentals", force: :cascade do |t|
    t.date     "first_day"
    t.integer  "num_of_students",                           default: 0
    t.time     "start_time"
    t.string   "instructor"
    t.string   "instructor_email"
    t.string   "instructor_phone"
    t.text     "notes"
    t.string   "location"
    t.boolean  "confirmed",                                 default: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "course"
    t.integer  "user_id"
    t.integer  "company_id"
    t.boolean  "canceled"
    t.time     "end_time"
    t.integer  "lab_course_id"
    t.integer  "kind"
    t.string   "time_zone"
    t.boolean  "twenty_four_hours",                         default: false
    t.date     "last_day"
    t.string   "level"
    t.integer  "origin_region"
    t.text     "active_regions",                            default: [],                 array: true
    t.integer  "setup_by"
    t.integer  "tested_by"
    t.integer  "number_of_pods"
    t.boolean  "plus_instructor",                           default: false
    t.decimal  "price",             precision: 8, scale: 2, default: 0.0
    t.integer  "po_number"
    t.boolean  "entered_into_crm",                          default: false
    t.string   "invoice_number"
    t.boolean  "payment_received",                          default: false
    t.string   "poc"
    t.string   "terms"
    t.integer  "instructor_id"
  end

  add_index "lab_rentals", ["lab_course_id"], name: "index_lab_rentals_on_lab_course_id", using: :btree
  add_index "lab_rentals", ["origin_region"], name: "index_lab_rentals_on_origin_region", using: :btree

  create_table "lab_students", force: :cascade do |t|
    t.integer  "lab_rental_id"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "lab_students", ["origin_region"], name: "index_lab_students_on_origin_region", using: :btree

  create_table "leads", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "status",         default: "unassigned"
    t.string   "discount",       default: "0"
    t.integer  "origin_region"
    t.text     "active_regions", default: [],                        array: true
  end

  add_index "leads", ["origin_region"], name: "index_leads_on_origin_region", using: :btree

  create_table "lms_exam_answers", force: :cascade do |t|
    t.text     "answer_text"
    t.integer  "lms_exam_question_id"
    t.integer  "position"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "correct",              default: false
    t.integer  "origin_region"
    t.text     "active_regions",       default: [],                 array: true
  end

  add_index "lms_exam_answers", ["lms_exam_question_id"], name: "index_lms_exam_answers_on_lms_exam_question_id", using: :btree
  add_index "lms_exam_answers", ["origin_region"], name: "index_lms_exam_answers_on_origin_region", using: :btree

  create_table "lms_exam_attempt_answers", force: :cascade do |t|
    t.integer  "lms_exam_attempt_id"
    t.integer  "lms_exam_question_id"
    t.integer  "lms_exam_answer_id"
    t.text     "answer_text"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "position"
    t.integer  "origin_region"
    t.text     "active_regions",       default: [],              array: true
  end

  add_index "lms_exam_attempt_answers", ["lms_exam_answer_id"], name: "index_lms_exam_attempt_answers_on_lms_exam_answer_id", using: :btree
  add_index "lms_exam_attempt_answers", ["lms_exam_attempt_id"], name: "index_lms_exam_attempt_answers_on_lms_exam_attempt_id", using: :btree
  add_index "lms_exam_attempt_answers", ["lms_exam_question_id"], name: "index_lms_exam_attempt_answers_on_lms_exam_question_id", using: :btree
  add_index "lms_exam_attempt_answers", ["origin_region"], name: "index_lms_exam_attempt_answers_on_origin_region", using: :btree

  create_table "lms_exam_attempts", force: :cascade do |t|
    t.integer  "lms_exam_id"
    t.integer  "user_id"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "lms_exam_attempts", ["lms_exam_id"], name: "index_lms_exam_attempts_on_lms_exam_id", using: :btree
  add_index "lms_exam_attempts", ["origin_region"], name: "index_lms_exam_attempts_on_origin_region", using: :btree
  add_index "lms_exam_attempts", ["user_id"], name: "index_lms_exam_attempts_on_user_id", using: :btree

  create_table "lms_exam_question_joins", force: :cascade do |t|
    t.integer  "lms_exam_id"
    t.integer  "lms_exam_question_id"
    t.integer  "position"
    t.boolean  "active"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "origin_region"
    t.text     "active_regions",       default: [],              array: true
  end

  add_index "lms_exam_question_joins", ["lms_exam_id"], name: "index_lms_exam_question_joins_on_lms_exam_id", using: :btree
  add_index "lms_exam_question_joins", ["lms_exam_question_id"], name: "index_lms_exam_question_joins_on_lms_exam_question_id", using: :btree
  add_index "lms_exam_question_joins", ["origin_region"], name: "index_lms_exam_question_joins_on_origin_region", using: :btree

  create_table "lms_exam_questions", force: :cascade do |t|
    t.text     "question_text"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "question_type",  default: 0
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
    t.integer  "lms_exam_id"
    t.integer  "position"
  end

  add_index "lms_exam_questions", ["origin_region"], name: "index_lms_exam_questions_on_origin_region", using: :btree

  create_table "lms_exams", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "exam_type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "video_module_id"
    t.integer  "video_id"
    t.string   "slug"
    t.integer  "video_on_demand_id"
    t.integer  "origin_region"
    t.text     "active_regions",     default: [],              array: true
  end

  add_index "lms_exams", ["origin_region"], name: "index_lms_exams_on_origin_region", using: :btree
  add_index "lms_exams", ["video_id"], name: "index_lms_exams_on_video_id", using: :btree
  add_index "lms_exams", ["video_module_id"], name: "index_lms_exams_on_video_module_id", using: :btree
  add_index "lms_exams", ["video_on_demand_id"], name: "index_lms_exams_on_video_on_demand_id", using: :btree

  create_table "lms_managed_students", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "manager_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "lms_managed_students", ["origin_region"], name: "index_lms_managed_students_on_origin_region", using: :btree

  create_table "opportunities", force: :cascade do |t|
    t.integer  "employee_id"
    t.integer  "customer_id"
    t.integer  "account_id"
    t.string   "title"
    t.integer  "stage"
    t.decimal  "amount",             precision: 8, scale: 2, default: 0.0
    t.string   "kind"
    t.string   "reason_for_loss"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.boolean  "waiting",                                    default: false
    t.string   "payment_kind"
    t.string   "billing_street"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zip_code"
    t.integer  "partner_id"
    t.date     "date_closed"
    t.integer  "course_id"
    t.integer  "event_id"
    t.string   "email_optional"
    t.text     "notes"
    t.integer  "origin_region"
    t.text     "active_regions",                             default: [],                 array: true
    t.integer  "video_on_demand_id"
  end

  add_index "opportunities", ["origin_region"], name: "index_opportunities_on_origin_region", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.integer  "orderable_id"
    t.string   "orderable_type"
    t.integer  "cart_id"
    t.decimal  "price",                precision: 8, scale: 2, default: 0.0
    t.integer  "order_id"
    t.integer  "user_id"
    t.boolean  "sent_webex_invite",                            default: false
    t.boolean  "sent_course_material",                         default: false
    t.boolean  "sent_lab_credentials",                         default: false
    t.string   "status"
    t.text     "note"
    t.integer  "origin_region"
    t.text     "active_regions",                               default: [],                 array: true
  end

  add_index "order_items", ["orderable_id"], name: "index_order_items_on_orderable_id", using: :btree
  add_index "order_items", ["origin_region"], name: "index_order_items_on_origin_region", using: :btree

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.string   "auth_code"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "shipping_street"
    t.string   "shipping_city"
    t.string   "shipping_state"
    t.string   "shipping_zip_code"
    t.string   "shipping_country"
    t.string   "email"
    t.string   "clc_number"
    t.string   "billing_name"
    t.string   "billing_zip_code"
    t.decimal  "paid",                    precision: 8, scale: 2, default: 0.0
    t.string   "billing_street"
    t.string   "billing_city"
    t.string   "billing_state"
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.string   "status",                                          default: "Uninvoiced"
    t.decimal  "total",                   precision: 8, scale: 2, default: 0.0
    t.string   "billing_country"
    t.string   "payment_type"
    t.integer  "clc_quantity",                                    default: 0
    t.string   "billing_first_name"
    t.string   "billing_last_name"
    t.string   "shipping_company"
    t.string   "billing_company"
    t.boolean  "same_addresses",                                  default: false
    t.string   "shipping_first_name"
    t.string   "shipping_last_name"
    t.string   "po_number"
    t.decimal  "po_paid",                 precision: 8, scale: 2, default: 0.0
    t.boolean  "verified",                                        default: false
    t.boolean  "invoiced",                                        default: false
    t.string   "invoice_number"
    t.integer  "status_position"
    t.boolean  "reviewed",                                        default: false
    t.decimal  "balance",                 precision: 8, scale: 2, default: 0.0
    t.string   "referring_partner_email"
    t.string   "gilmore_order_number"
    t.string   "gilmore_invoice"
    t.string   "royalty_id"
    t.date     "closed_date"
    t.integer  "source",                                          default: 0
    t.string   "other_source"
    t.integer  "discount_id"
    t.integer  "opportunity_id"
    t.integer  "origin_region"
    t.text     "active_regions",                                  default: [],                        array: true
  end

  add_index "orders", ["buyer_id"], name: "index_orders_on_buyer_id", using: :btree
  add_index "orders", ["origin_region"], name: "index_orders_on_origin_region", using: :btree
  add_index "orders", ["seller_id"], name: "index_orders_on_seller_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "page_title"
    t.string   "slug"
    t.boolean  "static",           default: false
    t.text     "page_description"
    t.integer  "origin_region"
    t.text     "active_regions",   default: [],                 array: true
  end

  add_index "pages", ["origin_region"], name: "index_pages_on_origin_region", using: :btree

  create_table "passed_exams", force: :cascade do |t|
    t.integer  "planned_subject_id"
    t.integer  "exam_id"
    t.boolean  "passed",             default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "user_id"
    t.integer  "origin_region"
    t.text     "active_regions",     default: [],                 array: true
  end

  add_index "passed_exams", ["origin_region"], name: "index_passed_exams_on_origin_region", using: :btree

  create_table "planned_subjects", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.string   "status"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "active",         default: true
    t.boolean  "read",           default: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],                 array: true
  end

  add_index "planned_subjects", ["origin_region"], name: "index_planned_subjects_on_origin_region", using: :btree

  create_table "platforms", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "slug"
    t.string   "page_title"
    t.text     "page_description"
    t.boolean  "satellite_viewable",             default: true
    t.integer  "origin_region"
    t.text     "active_regions",                 default: [],    array: true
    t.boolean  "archived",                       default: false
    t.boolean  "display_parent_category_on_top", default: false
  end

  add_index "platforms", ["origin_region"], name: "index_platforms_on_origin_region", using: :btree
  add_index "platforms", ["slug"], name: "index_platforms_on_slug", using: :btree

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

  create_table "public_featured_events", force: :cascade do |t|
    t.string   "full_title"
    t.string   "platform_course_url"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "length"
    t.string   "format"
    t.string   "language"
    t.string   "city"
    t.string   "state"
    t.string   "street"
    t.decimal  "price",               precision: 8, scale: 2, default: 0.0
    t.text     "video_preview"
    t.string   "link_to_cart"
    t.string   "pdf_url"
    t.integer  "platform_id"
    t.string   "platform_title"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "host"
    t.integer  "event_id"
    t.integer  "origin_region"
    t.text     "active_regions",                              default: [],               array: true
  end

  add_index "public_featured_events", ["origin_region"], name: "index_public_featured_events_on_origin_region", using: :btree

  create_table "quotes", force: :cascade do |t|
    t.integer  "lead_id"
    t.text     "content"
    t.string   "quote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.boolean  "sent_webex_invite",    default: false
    t.boolean  "sent_course_material", default: false
    t.boolean  "sent_lab_credentials", default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "event_id"
    t.integer  "origin_region"
    t.text     "active_regions",       default: [],                 array: true
  end

  add_index "registrations", ["origin_region"], name: "index_registrations_on_origin_region", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.string   "status"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "relationships", ["buyer_id"], name: "index_relationships_on_buyer_id", using: :btree
  add_index "relationships", ["origin_region"], name: "index_relationships_on_origin_region", using: :btree
  add_index "relationships", ["seller_id", "buyer_id"], name: "index_relationships_on_seller_id_and_buyer_id", unique: true, using: :btree
  add_index "relationships", ["seller_id"], name: "index_relationships_on_seller_id", using: :btree

  create_table "resource_events", force: :cascade do |t|
    t.string   "string"
    t.string   "employment_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.time     "start_time"
    t.time     "end_time"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "instructor_id"
  end

  create_table "roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "origin_region"
    t.text     "active_regions", default: [], array: true
  end

  add_index "roles", ["origin_region"], name: "index_roles_on_origin_region", using: :btree

  create_table "sales_goals", force: :cascade do |t|
    t.date     "month"
    t.integer  "amount"
    t.text     "description"
    t.integer  "origin_region"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                                    null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type",     limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "origin_region"
    t.text     "active_regions",            default: [],              array: true
  end

  add_index "settings", ["origin_region"], name: "index_settings_on_origin_region", using: :btree
  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "subject_groups", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "group_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "subject_groups", ["origin_region"], name: "index_subject_groups_on_origin_region", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation"
    t.integer  "platform_id"
    t.string   "slug"
    t.string   "page_title"
    t.text     "page_description"
    t.boolean  "partner_led",      default: false
    t.boolean  "active",           default: true
    t.string   "heading"
    t.integer  "origin_region"
    t.text     "active_regions",   default: [],    array: true
    t.boolean  "archived",         default: false
  end

  add_index "subjects", ["origin_region"], name: "index_subjects_on_origin_region", using: :btree
  add_index "subjects", ["slug"], name: "index_subjects_on_slug", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.date     "date_exp"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "video_on_demand_id"
    t.integer  "origin_region"
    t.text     "active_regions",     default: [],              array: true
  end

  add_index "subscriptions", ["origin_region"], name: "index_subscriptions_on_origin_region", using: :btree

  create_table "taken_exams", force: :cascade do |t|
    t.integer  "lms_exam_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "taken_exams", ["lms_exam_id"], name: "index_taken_exams_on_lms_exam_id", using: :btree
  add_index "taken_exams", ["user_id"], name: "index_taken_exams_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.datetime "activity_date"
    t.text     "description"
    t.integer  "rep_id"
    t.integer  "priority",       default: 2
    t.string   "subject"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "complete",       default: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],                 array: true
  end

  add_index "tasks", ["origin_region"], name: "index_tasks_on_origin_region", using: :btree

  create_table "testimonials", force: :cascade do |t|
    t.string   "quotation"
    t.string   "author"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "company"
    t.integer  "course_id"
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "testimonials", ["origin_region"], name: "index_testimonials_on_origin_region", using: :btree

  create_table "thredded_user_topic_reads", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.integer  "topic_id",                null: false
    t.integer  "post_id",                 null: false
    t.integer  "posts_count", default: 0, null: false
    t.integer  "page",        default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_user_topic_reads", ["topic_id"], name: "index_thredded_user_topic_reads_on_topic_id", using: :btree
  add_index "thredded_user_topic_reads", ["user_id", "topic_id"], name: "index_thredded_user_topic_reads_on_user_id_and_topic_id", unique: true, using: :btree

  create_table "topics", force: :cascade do |t|
    t.integer  "forum_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topologies", force: :cascade do |t|
    t.integer  "lab_course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "origin_region"
    t.text     "active_regions", default: [], array: true
  end

  create_table "user_companies", force: :cascade do |t|
    t.integer "user_id"
    t.integer "company_id"
  end

  add_index "user_companies", ["company_id"], name: "index_user_companies_on_company_id", using: :btree
  add_index "user_companies", ["user_id"], name: "index_user_companies_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                           default: "",    null: false
    t.string   "encrypted_password",                              default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
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
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                               default: 0
    t.datetime "last_active_at"
    t.string   "billing_street"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zip_code"
    t.boolean  "same_addresses",                                  default: false
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
    t.decimal  "onsite_daily_rate",       precision: 8, scale: 2, default: 0.0
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
    t.text     "active_regions",                                  default: [],                 array: true
    t.boolean  "active",                                          default: true
    t.boolean  "archive",                                         default: false
    t.string   "sales_force_id"
    t.integer  "customer_type"
    t.decimal  "online_daily_rate",       precision: 8, scale: 2, default: 0.0
    t.integer  "employement_type"
    t.integer  "rating"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["origin_region"], name: "index_users_on_origin_region", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "video_modules", force: :cascade do |t|
    t.integer  "video_on_demand_id"
    t.string   "title"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "position",               default: 0
    t.boolean  "cisco_digital_learning", default: false
    t.string   "cdl_course_code"
    t.integer  "origin_region"
    t.text     "active_regions",         default: [],                 array: true
  end

  add_index "video_modules", ["origin_region"], name: "index_video_modules_on_origin_region", using: :btree

  create_table "video_on_demands", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "instructor_id"
    t.string   "level"
    t.decimal  "price",                     precision: 8, scale: 2, default: 0.0
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.integer  "platform_id"
    t.string   "title"
    t.string   "abbreviation"
    t.string   "slug"
    t.string   "page_title"
    t.text     "page_description"
    t.text     "intro"
    t.text     "overview"
    t.text     "outline"
    t.text     "intended_audience"
    t.boolean  "partner_led",                                       default: false
    t.boolean  "active",                                            default: true
    t.boolean  "lms",                                               default: false
    t.string   "heading"
    t.boolean  "satellite_viewable",                                default: true
    t.boolean  "cisco_digital_learning",                            default: false
    t.string   "cdl_course_code"
    t.integer  "origin_region"
    t.text     "active_regions",                                    default: [],                 array: true
    t.string   "cisco_course_product_code"
    t.boolean  "archived",                                          default: false
  end

  add_index "video_on_demands", ["origin_region"], name: "index_video_on_demands_on_origin_region", using: :btree
  add_index "video_on_demands", ["slug"], name: "index_video_on_demands_on_slug", using: :btree

  create_table "videos", force: :cascade do |t|
    t.integer  "video_module_id"
    t.string   "title"
    t.string   "url"
    t.text     "embed_code"
    t.boolean  "free"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "position",        default: 0
    t.string   "slug"
    t.integer  "origin_region"
    t.text     "active_regions",  default: [],              array: true
  end

  add_index "videos", ["origin_region"], name: "index_videos_on_origin_region", using: :btree

  create_table "watched_videos", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.string   "status"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "origin_region"
    t.text     "active_regions", default: [],              array: true
  end

  add_index "watched_videos", ["origin_region"], name: "index_watched_videos_on_origin_region", using: :btree

  add_foreign_key "checklist_items", "checklists"
  add_foreign_key "lab_rentals", "lab_courses"
  add_foreign_key "lms_exam_answers", "lms_exam_questions"
  add_foreign_key "lms_exam_attempt_answers", "lms_exam_answers"
  add_foreign_key "lms_exam_attempt_answers", "lms_exam_attempts"
  add_foreign_key "lms_exam_attempt_answers", "lms_exam_questions"
  add_foreign_key "lms_exam_attempts", "lms_exams"
  add_foreign_key "lms_exam_attempts", "users"
  add_foreign_key "lms_exam_question_joins", "lms_exam_questions"
  add_foreign_key "lms_exam_question_joins", "lms_exams"
  add_foreign_key "lms_exams", "video_modules"
  add_foreign_key "lms_exams", "video_on_demands"
  add_foreign_key "lms_exams", "videos"
  add_foreign_key "taken_exams", "lms_exams"
  add_foreign_key "taken_exams", "users"
  add_foreign_key "user_companies", "companies"
  add_foreign_key "user_companies", "users"
  add_foreign_key "users", "companies"
end
