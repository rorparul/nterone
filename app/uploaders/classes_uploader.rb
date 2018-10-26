class ClassesUploader
  def self.upload(file)
    begin
      spreadsheet            = open_spreadsheet(file)
      header                 = format_header(spreadsheet.row(1))
      Setting.last_upload_id = Time.now.to_i
      result                 = { total: spreadsheet.count - 1, duplicates: [], successes: [], failures: [] }

      (2..spreadsheet.last_row).each do |i|
        row_original     = format_row(Hash[[header, spreadsheet.row(i)].transpose])
        row_for_creation = row_original.dup
        course           ||= Course.active.find_by(abbreviation: row_for_creation.delete(:abbreviation)) if row_for_creation[:abbreviation].present?
        course           ||= Course.active.find_by(cisco_id: row_for_creation.delete(:cisco_id)) if row_for_creation[:cisco_id].present?

        if course.present? && course.events.find_by(row_for_creation).present?
          result[:duplicates] << row_original
          next
        end

        row_for_creation[:active_regions] = ['united_states', 'canada', 'latin_america', 'india']
        row_for_creation[:upload_id]      = Setting.last_upload_id

        if course.present? && course.events.create(row_for_creation).persisted?
          result[:successes] << row_original
        else
          result[:failures] << row_original
        end
      end
    rescue StandardError => error
      Rails.logger.info "Rescued: #{error}"

      Event.where(upload_id: Setting.last_upload_id).destroy_all if Setting.last_upload_id.present?
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
      when "Acronym"                          then :abbreviation
      when "Delivery Type"                    then :format
      when "State/Province"                   then :state
      when "City"                             then :city
      when "Start Date"                       then :start_date
      when "End Date"                         then :end_date
      when "Language"                         then :language
      when "Price"                            then :price
      # when "Site ID"                          then :site_id
      # when "Location"                         then :format
      # when "Location"                         then :location
      # when "Street Address"                   then :street
      # when "Zip Code"                         then :zipcode
      # when "Offering Start Date(DD-Mon-YYYY)" then :start_date
      # when "Offering End Date(DD-Mon-YYYY)"   then :end_date
      # when "Comments"                         then :note
      # when "Registration URL"                 then :registration_url
      # when "Registration Phone"               then :registration_phone
      # when "Registration Fax"                 then :registration_fax
      # when "Registration Email"               then :registration_email
      end
    end
  end

  def self.format_row(row)
    # row[:start_date]     = row[:start_date]
    # row[:end_date]       = row[:end_date]
    # row[:cisco_id]       = row[:cisco_id].to_i.to_s if row[:cisco_id].present?
    row[:language]       = row[:language].present? ? (row[:language] == 'English' ? 0 : 1) : 0
    row[:start_time]     = Time.new(2000, 01, 01, 10, 00)
    row[:end_time]       = Time.new(2000, 01, 01, 18, 00)
    row[:time_zone]      = 'Eastern Time (US & Canada)'
    # row[:site_id]        = row[:site_id].to_i.to_s if row[:site_id].present?
    # row[:price]          = row[:price] || 0.0
    # row[:active_regions] = ['united_states', 'canada', 'latin_america', 'india']
    row
  end

  # def self.calibrate_row_to_header(header, row)
  #   row.select.with_index do |value, index|
  #     value if header[index].present?
  #   end
  # end
end
