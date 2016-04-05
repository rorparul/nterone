ActiveAdmin.register Event do
  menu priority: 4

  index do
    selectable_column
    id_column
    column :status
    column "Course" do |event|
      event.course.abbreviation
    end
    column :start_date
    column "Duration" do |event|
      event.length
    end
    column :end_date
    column :start_time
    column :end_time
    column :format
    column :instructor
    column :students
    column :revenue
    column :lab_source
    column :public
    column :guaranteed
    actions
  end
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end

# t.date     "start_date"
# t.date     "end_date"
# t.string   "format"
# t.decimal  "price",           precision: 8, scale: 2, default: 0.0
# t.integer  "instructor_id"
# t.integer  "course_id"
# t.datetime "created_at",                                              null: false
# t.datetime "updated_at",                                              null: false
# t.boolean  "guaranteed",                              default: false
# t.boolean  "active",                                  default: true
# t.time     "start_time"
# t.time     "end_time"
# t.string   "city"
# t.string   "state"
# t.string   "status"
# t.string   "lab_source"
# t.boolean  "public",                                  default: true
# t.decimal  "cost_instructor", precision: 8, scale: 2, default: 0.0
# t.decimal  "cost_lab",        precision: 8, scale: 2, default: 0.0
# t.decimal  "cost_te",         precision: 8, scale: 2, default: 0.0
# t.decimal  "cost_facility",   precision: 8, scale: 2, default: 0.0
# t.decimal  "cost_books",      precision: 8, scale: 2, default: 0.0
# t.decimal  "cost_shipping",   precision: 8, scale: 2, default: 0.0
# t.boolean  "partner_led",                             default: false
# t.string   "time_zone"
