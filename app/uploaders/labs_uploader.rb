class LabsUploader
  def self.upload(file)
    report = {success: true, failers: []}
    spreadsheet = open_spreadsheet(file)
    header = format_header(spreadsheet.row(1))
    p header
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.format_header(row)
    row.map do |column|
      case column
      when "id"
        :id
      when "courses"
        :course
      when "classdate"
        :first_day
      when "classenddate"
        :last_day
      when "studentname"
        
  end

end
