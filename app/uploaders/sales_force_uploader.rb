class SalesForceUploader
  def self.upload(file, type)
    spreadsheet = open_spreadsheet(file)
    header      = format_header(spreadsheet.row(1), type)
    format_rows(spreadsheet, header, type)
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.format_header(row, type)
    row.map do |title|
      if type == "Company"
        case title
        when "Account Name"
          :title
        when "Account Owner"
          :user_id
        when "Website"
          :website
        else
          :DELETE
        end
      elsif type == "Contacts"
        case title
        when "Account Name: Account Name"
          :company_name
        when "Alternate Phone Number"
          :phone_alternative
        when "Contact Owner: Full Name"
          :seller_id
        when "Email"
          :email
        when "Email Opt Out"
          :do_not_email
        when "First Name"
          :first_name
        when "Last Name"
          :last_name
        when "Mailing State/Province"
          :state
        when "Phone"
          :contact_number
        else
          :DELETE
        end
      elsif type == "Leads"
        case title
        when "Company / Account"
          :company_name
        when "Email"
          :email
        when "Email Opt Out"
          :do_not_email
        when "First Name"
          :first_name
        when "Last Name"
          :last_name
        when "Lead Owner"
          :seller_id
        when "Mobile"
          :phone_alternative
        when "Phone"
          :contact_number
        when "State/Province"
          :state
        when "Street"
          :street
        when "Title"
          :business_title
        else
          :DELETE
        end
      elsif type == "Opportunities"
        case title
        when "Account Name"
          :account_id
        when "Amount"
          :amount
        when "Close Date"
          :date_closed
        when "Opportunity Name"
          :title
        when "Opportunity Owner"
          :employee_id
        when "Stage"
          :stage
        else
          :DELETE
        end
      end
    end
  end

  def self.format_rows(spreadsheet, header, type)

  end

end
