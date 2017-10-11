class ClassesUploader
  def self.upload(file)
    result      = { failures: [] }
    spreadsheet = open_spreadsheet(file)
    header      = format_header(spreadsheet.row(1))

    (2..spreadsheet.last_row).each do |i|
      row_original     = format_row(Hash[[header, spreadsheet.row(i)].transpose])
      row_for_creation = row_original.dup
      course           = Course.find_by(cisco_id: row_for_creation.delete(:cisco_id))

      unless course.present? && course.events.create(row_for_creation).persisted?
        result[:failures] << row_original
      end
    end

    result
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv"  then Roo::Csv.new(file.path)
    when ".xls"  then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.format_header(header)
    header.map do |title|
      case title.strip
      when "Course ID"                        then :cisco_id
      when "Language"                         then :language
      when "Country Code"                     then :country_code
      when "Location Name"                    then :location
      when "Street Address"                   then :street
      when "City"                             then :city
      when "State/Province"                   then :state
      when "Zip Code"                         then :zipcode
      when "Offering Start Date(DD-Mon-YYYY)" then :start_date
      when "Offering End Date(DD-Mon-YYYY)"   then :end_date
      when "Delivery Type"                    then :format
      when "Comments"                         then :note
      when "Registration URL"                 then :registration_url
      when "Registration Phone"               then :registration_phone
      when "Registration Fax"                 then :registration_fax
      when "Registration Email"               then :registration_email
      when "Site ID"                          then :site_id
      when "Price"                            then :price
      end
    end
  end

  def self.format_row(row)
    row[:cisco_id]       = row[:cisco_id].to_i.to_s
    row[:language]       = row[:language] == 'English' ? 0 : 1
    row[:zipcode]        = row[:zipcode].to_i.to_s
    row[:start_date]     = row[:start_date]
    row[:end_date]       = row[:end_date]
    row[:start_time]     = Time.new(2000, 01, 01, 10, 00)
    row[:end_time]       = Time.new(2000, 01, 01, 18, 00)
    row[:site_id]        = row[:site_id].to_i.to_s
    row[:price]          = row[:price] || 0.0
    row[:active_regions] = ['united_states']
    row
  end
end
