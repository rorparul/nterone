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
      if type == "Companies"
        case title
        when "Account Name"
          :title
        when "Account Owner"
          # Must Find By Name
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
          # Must find by name
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
          # Must find by name
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
          # Must find by name
          :account_id
        when "Amount"
          :amount
        when "Close Date"
          :date_closed
        when "Opportunity Name"
          :title
        when "Opportunity Owner"
          # Must find by name
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
    (2..spreadsheet.last_row).each do |i|
      row_original = Hash[[header, spreadsheet.row(i)].transpose]
      row_original.delete(:DELETE)
      case type
      when "Companies"
        if row_original[:user_id]
          #  Must find my full name
          if row_original[:user_id] == "Company Earnings"
            row_original[:user_id] = nil
          else
            first_name = row_original[:user_id].split.first
            last_name  = row_original[:user_id].split.last
            user       = User.find_by(first_name: first_name, last_name: last_name)
            if user && (user.sales? || user.admin?)
              row_original[:user_id] = user.id
            else
              # Cannot create users without email address
              row_original[:user_id] = nil
            end
          end
        end
        Company.create(row_original) if Company.where(row_original).empty?
      when "Contacts" || "Leads"
        if row_original[:do_not_email]
          row_original[:do_not_email] = row_original[:do_not_email] == "1" || 1 ? true : false
        end
        # If Contact has seller_id obtain information to create an associated lead resource
        if row_original[:seller_id]
          # Must find rep by full name
          first_name = row_original[:seller_id].split.first
          last_name  = row_original[:seller_id].split.last
          @rep       = User.find_by(first_name: first_name, last_name: last_name)
          row_original.delete(:seller_id)
        end
        # Create user if user does not exist
        user = User.find_by(email: row_original[:email])
        if user.nil?
          row_original[:status]     = 3 if type == "Contacts"
          row_original[:company_id] = Company.find_by(title: row_original[:company_name]).id unless Company.find_by(title: row_original[:company_name]).nil?
          user = User.create(row_original)
        end
        #  Create associated lead
        if @rep && (@rep.sales? || @rep.admin?)
          Lead.create(seller_id: @rep.id, buyer_id: user.id, status: 'assigned')
        end
      when "Opportunities"
        if row_original[:account_id]
          company = Company.find_by(title: row_original[:account_id])
          row_original[:account_id] = company.id unless company.nil?
        end

        if row_original[:amount]
          row_original[:amount] = row_original[:amount].to_d
        end

        if row_original[:date_closed]
          row_original[:date_closed] = Date.strptime(row_original[:date_closed], '%m/%d/%Y')
        end

        # Associate Opportunity with rep if rep exists
        if row_original[:employee_id]
          # Must find by full name
          first_name = row_original[:employee_id].split.first
          last_name  = row_original[:employee_id].split.last
          rep        = User.find_by(first_name: first_name, last_name: last_name)
          row_original[:employee_id] = rep.id unless rep.nil?
        end
        Opportunity.create(row_original)
      else
        flash[:alert] = "Something went horribly wrong!"
        return redirect_to :back
      end
    end
  end

end
