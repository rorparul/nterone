class ClassesUploader
  include CSVImporter

  model Event

  column :start_date,    as: "Start Date", to: -> (start_date) { Date.strptime(start_date, "%m/%d/%Y").to_s(:db) }
  column :end_date,      as: "End Date",   to: -> (start_date) { Date.strptime(start_date, "%m/%d/%Y").to_s(:db) }
  column :format,        as: "Format"
  column :price,         as: "Price"
  column :guaranteed,    as: "Guaranteed"
  column :active,        as: "Active"
  column :instructor_id, as: "Instructor ID"
  column :course_id,     as: "Course ID"
end
