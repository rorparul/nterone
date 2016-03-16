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

ActiveRecord::Schema.define(version: 20160315215032) do

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

  create_table "articles", force: :cascade do |t|
    t.string   "page_title"
    t.text     "page_description"
    t.text     "content"
    t.string   "slug"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "kind"
    t.string   "title"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string   "page_title"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "slug"
    t.text     "page_description"
  end

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "slug"
    t.integer  "position_as_parent", default: 0
    t.integer  "position_as_child",  default: 0
    t.integer  "position",           default: 0
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["platform_id"], name: "index_categories_on_platform_id", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

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
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.integer  "platform_id"
    t.boolean  "active",                                    default: true
    t.string   "abbreviation"
    t.text     "intro"
    t.text     "overview"
    t.text     "outline"
    t.text     "intended_audience"
    t.string   "pdf"
    t.text     "video_preview"
    t.decimal  "price",             precision: 8, scale: 2, default: 0.0
    t.string   "slug"
    t.string   "page_title"
    t.text     "page_description"
    t.boolean  "partner_led",                               default: false
  end

  add_index "courses", ["slug"], name: "index_courses_on_slug", using: :btree

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
    t.decimal  "price",           precision: 8, scale: 2, default: 0.0
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
    t.boolean  "partner_led",                             default: false
    t.string   "time_zone"
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

  create_table "forem_categories", force: :cascade do |t|
    t.string   "name",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "position",   default: 0
  end

  add_index "forem_categories", ["slug"], name: "index_forem_categories_on_slug", unique: true, using: :btree

  create_table "forem_forums", force: :cascade do |t|
    t.string  "name"
    t.text    "description"
    t.integer "category_id"
    t.integer "views_count", default: 0
    t.string  "slug"
    t.integer "position",    default: 0
  end

  add_index "forem_forums", ["slug"], name: "index_forem_forums_on_slug", unique: true, using: :btree

  create_table "forem_groups", force: :cascade do |t|
    t.string "name"
  end

  add_index "forem_groups", ["name"], name: "index_forem_groups_on_name", using: :btree

  create_table "forem_memberships", force: :cascade do |t|
    t.integer "group_id"
    t.integer "member_id"
  end

  add_index "forem_memberships", ["group_id"], name: "index_forem_memberships_on_group_id", using: :btree

  create_table "forem_moderator_groups", force: :cascade do |t|
    t.integer "forum_id"
    t.integer "group_id"
  end

  add_index "forem_moderator_groups", ["forum_id"], name: "index_forem_moderator_groups_on_forum_id", using: :btree

  create_table "forem_posts", force: :cascade do |t|
    t.integer  "topic_id"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_to_id"
    t.string   "state",       default: "pending_review"
    t.boolean  "notified",    default: false
  end

  add_index "forem_posts", ["reply_to_id"], name: "index_forem_posts_on_reply_to_id", using: :btree
  add_index "forem_posts", ["state"], name: "index_forem_posts_on_state", using: :btree
  add_index "forem_posts", ["topic_id"], name: "index_forem_posts_on_topic_id", using: :btree
  add_index "forem_posts", ["user_id"], name: "index_forem_posts_on_user_id", using: :btree

  create_table "forem_subscriptions", force: :cascade do |t|
    t.integer "subscriber_id"
    t.integer "topic_id"
  end

  create_table "forem_topics", force: :cascade do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "locked",       default: false,            null: false
    t.boolean  "pinned",       default: false
    t.boolean  "hidden",       default: false
    t.datetime "last_post_at"
    t.string   "state",        default: "pending_review"
    t.integer  "views_count",  default: 0
    t.string   "slug"
  end

  add_index "forem_topics", ["forum_id"], name: "index_forem_topics_on_forum_id", using: :btree
  add_index "forem_topics", ["slug"], name: "index_forem_topics_on_slug", unique: true, using: :btree
  add_index "forem_topics", ["state"], name: "index_forem_topics_on_state", using: :btree
  add_index "forem_topics", ["user_id"], name: "index_forem_topics_on_user_id", using: :btree

  create_table "forem_views", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",             default: 0
    t.string   "viewable_type"
    t.datetime "current_viewed_at"
    t.datetime "past_viewed_at"
  end

  add_index "forem_views", ["updated_at"], name: "index_forem_views_on_updated_at", using: :btree
  add_index "forem_views", ["user_id"], name: "index_forem_views_on_user_id", using: :btree
  add_index "forem_views", ["viewable_id"], name: "index_forem_views_on_viewable_id", using: :btree

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

  create_table "industry_articles", force: :cascade do |t|
    t.string   "page_title"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "slug"
    t.text     "page_description"
  end

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
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "orderable_id"
    t.string   "orderable_type"
    t.integer  "cart_id"
    t.decimal  "price",          precision: 8, scale: 2, default: 0.0
    t.integer  "order_id"
    t.integer  "user_id"
  end

  add_index "order_items", ["orderable_id"], name: "index_order_items_on_orderable_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
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
    t.decimal  "paid",              precision: 8, scale: 2, default: 0.0
    t.string   "billing_street"
    t.string   "billing_city"
    t.string   "billing_state"
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.string   "status",                                    default: "Uninvoiced"
    t.decimal  "total",             precision: 8, scale: 2, default: 0.0
    t.string   "billing_country"
    t.string   "payment_type"
    t.integer  "clc_quantity",                              default: 0
  end

  add_index "orders", ["buyer_id"], name: "index_orders_on_buyer_id", using: :btree
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
    t.string   "slug"
    t.string   "page_title"
    t.text     "page_description"
  end

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

  create_table "press_releases", force: :cascade do |t|
    t.string   "page_title"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "slug"
    t.text     "page_description"
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
    t.string   "slug"
    t.string   "page_title"
    t.text     "page_description"
    t.boolean  "partner_led",      default: false
  end

  add_index "subjects", ["slug"], name: "index_subjects_on_slug", using: :btree

  create_table "testimonials", force: :cascade do |t|
    t.string   "quotation"
    t.string   "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "company"
    t.integer  "course_id"
  end

  create_table "thredded_categories", force: :cascade do |t|
    t.integer  "messageboard_id", null: false
    t.string   "name",            null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",            null: false
  end

  add_index "thredded_categories", ["messageboard_id", "slug"], name: "index_thredded_categories_on_messageboard_id_and_slug", unique: true, using: :btree
  add_index "thredded_categories", ["messageboard_id"], name: "index_thredded_categories_on_messageboard_id", using: :btree

  create_table "thredded_images", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "width"
    t.integer  "height"
    t.string   "orientation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_images", ["post_id"], name: "index_thredded_images_on_post_id", using: :btree

  create_table "thredded_messageboards", force: :cascade do |t|
    t.string   "name",                                       null: false
    t.string   "slug"
    t.text     "description"
    t.string   "security",             default: "public"
    t.string   "posting_permission",   default: "anonymous"
    t.integer  "topics_count",         default: 0
    t.integer  "posts_count",          default: 0
    t.boolean  "closed",               default: false,       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filter",               default: "markdown",  null: false
    t.integer  "private_topics_count", default: 0
  end

  add_index "thredded_messageboards", ["closed"], name: "index_thredded_messageboards_on_closed", using: :btree
  add_index "thredded_messageboards", ["slug"], name: "index_thredded_messageboards_on_slug", using: :btree

  create_table "thredded_notification_preferences", force: :cascade do |t|
    t.boolean  "notify_on_mention", default: true
    t.boolean  "notify_on_message", default: true
    t.integer  "user_id",                          null: false
    t.integer  "messageboard_id",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_notification_preferences", ["messageboard_id"], name: "index_thredded_notification_preferences_on_messageboard_id", using: :btree
  add_index "thredded_notification_preferences", ["user_id"], name: "index_thredded_notification_preferences_on_user_id", using: :btree

  create_table "thredded_post_notifications", force: :cascade do |t|
    t.string   "email",      null: false
    t.integer  "post_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_post_notifications", ["post_id"], name: "index_thredded_post_notifications_on_post_id", using: :btree

  create_table "thredded_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.string   "ip"
    t.string   "filter",          default: "markdown"
    t.string   "source",          default: "web"
    t.integer  "postable_id"
    t.integer  "messageboard_id",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "postable_type"
  end

  add_index "thredded_posts", ["messageboard_id"], name: "index_thredded_posts_on_messageboard_id", using: :btree
  add_index "thredded_posts", ["postable_id", "postable_type"], name: "index_thredded_posts_on_postable_id_and_postable_type", using: :btree
  add_index "thredded_posts", ["postable_id"], name: "index_thredded_posts_on_postable_id", using: :btree
  add_index "thredded_posts", ["user_id"], name: "index_thredded_posts_on_user_id", using: :btree

  create_table "thredded_private_topics", force: :cascade do |t|
    t.integer  "user_id",                     null: false
    t.integer  "last_user_id",                null: false
    t.string   "title",                       null: false
    t.string   "slug",                        null: false
    t.integer  "messageboard_id",             null: false
    t.integer  "posts_count",     default: 0
    t.string   "hash_id",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_private_topics", ["hash_id"], name: "index_thredded_private_topics_on_hash_id", using: :btree
  add_index "thredded_private_topics", ["messageboard_id"], name: "index_thredded_private_topics_on_messageboard_id", using: :btree
  add_index "thredded_private_topics", ["slug"], name: "index_thredded_private_topics_on_slug", using: :btree

  create_table "thredded_private_users", force: :cascade do |t|
    t.integer  "private_topic_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",             default: false
  end

  add_index "thredded_private_users", ["private_topic_id"], name: "index_thredded_private_users_on_private_topic_id", using: :btree
  add_index "thredded_private_users", ["read"], name: "index_thredded_private_users_on_read", using: :btree
  add_index "thredded_private_users", ["user_id"], name: "index_thredded_private_users_on_user_id", using: :btree

  create_table "thredded_roles", force: :cascade do |t|
    t.string   "level"
    t.integer  "user_id"
    t.integer  "messageboard_id"
    t.datetime "last_seen"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_roles", ["messageboard_id"], name: "index_thredded_roles_on_messageboard_id", using: :btree
  add_index "thredded_roles", ["user_id"], name: "index_thredded_roles_on_user_id", using: :btree

  create_table "thredded_topic_categories", force: :cascade do |t|
    t.integer "topic_id",    null: false
    t.integer "category_id", null: false
  end

  add_index "thredded_topic_categories", ["category_id"], name: "index_thredded_topic_categories_on_category_id", using: :btree
  add_index "thredded_topic_categories", ["topic_id"], name: "index_thredded_topic_categories_on_topic_id", using: :btree

  create_table "thredded_topics", force: :cascade do |t|
    t.integer  "user_id",                         null: false
    t.integer  "last_user_id",                    null: false
    t.string   "title",                           null: false
    t.string   "slug",                            null: false
    t.integer  "messageboard_id",                 null: false
    t.integer  "posts_count",     default: 0,     null: false
    t.boolean  "sticky",          default: false, null: false
    t.boolean  "locked",          default: false, null: false
    t.string   "hash_id",                         null: false
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_topics", ["hash_id"], name: "index_thredded_topics_on_hash_id", using: :btree
  add_index "thredded_topics", ["messageboard_id", "slug"], name: "index_thredded_topics_on_messageboard_id_and_slug", unique: true, using: :btree
  add_index "thredded_topics", ["messageboard_id"], name: "index_thredded_topics_on_messageboard_id", using: :btree
  add_index "thredded_topics", ["user_id"], name: "index_thredded_topics_on_user_id", using: :btree

  create_table "thredded_user_details", force: :cascade do |t|
    t.integer  "user_id",                            null: false
    t.datetime "latest_activity_at"
    t.integer  "posts_count",        default: 0
    t.integer  "topics_count",       default: 0
    t.boolean  "superadmin",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_user_details", ["latest_activity_at"], name: "index_thredded_user_details_on_latest_activity_at", using: :btree
  add_index "thredded_user_details", ["user_id"], name: "index_thredded_user_details_on_user_id", using: :btree

  create_table "thredded_user_preferences", force: :cascade do |t|
    t.integer  "user_id",                                           null: false
    t.string   "time_zone",  default: "Eastern Time (US & Canada)"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_user_preferences", ["user_id"], name: "index_thredded_user_preferences_on_user_id", using: :btree

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

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",               null: false
    t.string   "encrypted_password",     default: "",               null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                null: false
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
    t.boolean  "forem_admin",            default: false
    t.string   "forem_state",            default: "pending_review"
    t.boolean  "forem_auto_subscribe",   default: false
    t.string   "billing_first_name"
    t.string   "billing_last_name"
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
    t.decimal  "price",             precision: 8, scale: 2, default: 0.0
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
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
    t.boolean  "partner_led",                               default: false
  end

  add_index "video_on_demands", ["slug"], name: "index_video_on_demands_on_slug", using: :btree

  create_table "videos", force: :cascade do |t|
    t.integer  "video_module_id"
    t.string   "title"
    t.string   "url"
    t.text     "embed_code"
    t.boolean  "free"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "watched_videos", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
