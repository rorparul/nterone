class ClassesUploader
  include CSVImporter

  model Event

  column :course_id,     as: "Course ID"
  column :start_date,    as: "Start Date", to: -> (start_date) { Date.strptime(start_date, "%m/%d/%Y").to_s(:db) }
  column :end_date,      as: "End Date",   to: -> (start_date) { Date.strptime(start_date, "%m/%d/%Y").to_s(:db) }
  column :start_time,    as: "Start Time"
  column :end_time,      as: "End Time"
  column :format,        as: "Format"
  column :price,         as: "Price"
end
