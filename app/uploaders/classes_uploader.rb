class ClassesUploader
  def self.upload(file)
    report = { success: true, failures: []}
    spreadsheet = open_spreadsheet(file)
    header = format_header(spreadsheet.row(1))

    (2..spreadsheet.last_row).each do |i|
      row_original = Hash[[header, spreadsheet.row(i)].transpose]
      row_new      = row_original.dup
      row_new.delete(:course_title)

      if row_new[:start_time]
        row_new[:start_time] = Time.at(row_new[:start_time])
      end

      if row_new[:end_time]
        row_new[:end_time] = Time.at(row_new[:end_time])
      end

      event = Event.new(row_new)

      if Event.find_by(course_id: event.course_id,
                       start_date: event.start_date,
                       end_date: event.end_date,
                       start_time: event.start_time,
                       end_time: event.end_time,
                       format: event.format,
                       price: event.price)

        report[:success] = false
        report[:failures] << row_original
      else
        unless event.save
          p event.errors
          report[:failures] << row_original
        end
      end
    end
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
      case title.strip
      when "Course ID"
        :cisco_id
      when "Language"
        :language
      when "Country Code"
        :country_code # TODO: Add to events
      when "Location Name"
        :location # TODO: Add to events
      when "Street Address"
        :street # TODO: Add to events
      when "City"
        :city # TODO: Add to events
      when "State/Province"
        :state # TODO: Add to events
      when "Zip Code"
        :zipcode
      when "Offering Start Date(DD-Mon-YYYY)"
        :start_date
      when "Offering End Date(DD-Mon-YYYY)"
        :end_date
      when "Delivery Type"
        :format
      when "Comments"
        :note
      when "Registration URL"

      when "Registration Phone"

      when "Registration Fax"

      when "Registration Email"

      when "Site ID"

      end
    end
  end
end
