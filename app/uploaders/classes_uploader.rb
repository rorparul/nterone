class ClassesUploader
  def self.upload(file)
    report = { success: true, failures: []}
    spreadsheet = open_spreadsheet(file)
    header = format_header(spreadsheet.row(1))
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row.delete(:course_title)
      event = Event.new(row)
      if Event.find_by(course_id: event.course_id, start_date: event.start_date, end_date: event.end_date, start_time: event.start_time, end_time: event.end_time, format: event.format, price: event.price)
        report[:success] = false
        report[:failures] << row
      else
        unless event.save(row)
          report[:failures] << row
        end
      end
    end
    p report
    report
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.format_header(header)
    header.map do |title|
      case title
      when "Course ID"
        :course_id
      when "Course Title"
        :course_title
      when "Start Date"
        :start_date
      when "End Date"
        :end_date
      when "Start Time"
        :start_time
      when "End Time"
        :end_time
      when "Format"
        :format
      when "Price"
        :price
      end
    end
  end
end
