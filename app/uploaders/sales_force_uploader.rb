class SalesForceUploader
  require 'csv'

  def self.upload(contacts, leads, users, tasks)
    @contacts           = Roo::CSV.new(contacts.path, csv_options: {encoding: 'windows-1251:utf-8'})
    @leads              = Roo::CSV.new(leads.path, csv_options: {encoding: 'windows-1251:utf-8'})
    @users              = Roo::CSV.new(users.path, csv_options: {encoding: 'windows-1251:utf-8'})
    @tasks              = Roo::CSV.new(tasks.path, csv_options: {encoding: 'windows-1251:utf-8'})
    # @contacts               = CSV.read(contacts.path, { headers: true, encoding: 'windows-1251:utf-8' } )
    # @leads                  = CSV.read(leads.path, { headers: true, encoding: 'windows-1251:utf-8' } )
    # @tasks                  = CSV.read(tasks.path, { headers: true, encoding: 'windows-1251:utf-8' } )
    # @users                  = CSV.read(users.path, { headers: true, encoding: 'windows-1251:utf-8' } )
    # @contacts         = open_spreadsheet(contacts)
    # @leads            = open_spreadsheet(leads)
    # @users            = open_spreadsheet(users)
    # @tasks            = open_spreadsheet(tasks)
    @tasks_header     = format_header(@tasks.row(1), "Tasks")
    save_tasks
  end

  def self.save_tasks
    n = 0
    (2..@tasks.last_row).each do |i|
      row_tasks = Hash[[@tasks_header, @tasks.row(i)].transpose]
      row_tasks.delete(:DELETE)
      @user = nil
      @rep = nil
      find_user(@contacts, row_tasks[:user_id])
      find_user(@leads, row_tasks[:user_id]) unless @user
      find_user(@users, row_tasks[:rep_id])
      next if @user.nil? || @rep.nil?
      row_tasks[:user_id] = @user.id
      row_tasks[:rep_id]  = @rep.id
      if row_tasks[:priority]
        row_tasks[:priority] == 'Normal' ? row_tasks[:priority] = 2 : row_tasks[:priority] = 3
      end
      if row_tasks[:complete]
        row_tasks[:complete] == 'Completed' ? row_tasks[:complete] = true : row_tasks[:complete] = false
      end
      Task.create(row_tasks)
      n += 1
      return if n == 2
    end
  end

  def self.find_user(table, id)
    table.each(ID: 'Id', email: 'Email') do |row|
      if row[:ID] == id
        return @user = User.find_by(email: row[:email]) unless @user
        return @rep = User.find_by(email: row[:email])
      end
    end
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
        when "Probability (%)"
          :stage
        when "Next Step"
          :notes
        when "Created Date"
          :created_at
        else
          :DELETE
        end
      elsif type == "Tasks"
        case title
        when "ActivityDate"
          :activity_date
        when "Description"
          :description
        when "OwnerId"
          :rep_id
        when "Priority"
          :priority
        when "Status"
          :complete
        when "Subject"
          :subject
        when "WhoId"
          :user_id
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
          #  Must find by full name
          if row_original[:user_id] == "Company Earnings"
            row_original[:user_id] = nil
          else

            # NOTE: Capture sales rep
            first_name = row_original[:user_id].split.first
            last_name  = row_original[:user_id].split.last
            users      = User.where(first_name: first_name, last_name: last_name)
            users.each do |user|
              @user = user if user.sales? || user.admin?
            end

            if @user
              row_original[:user_id] = @user.id
            # elsif @user.nil? && !(first_name.nil?) && !(first_name.blank?) && !(last_name.nil?) && !(last_name.blank?)
            #   email     = first_name + "." + last_name + "@nterone.com"
            #   password  = first_name.first(3) + last_name.first(3) + "Password1"
            #   user      = User.create!(first_name: first_name, last_name: last_name, email: email, password: password)
            #   Role.create(user_id: user.id, role: 3)
            #   row_original[:user_id] = user.id
            # else
            #   # Cannot create users without email address
            #   row_original[:user_id] = nil
            end
          end
        end
        Company.create(row_original) if Company.where(row_original).empty?
      when "Contacts"
        # if row_original[:do_not_email]
          # row_original[:do_not_email] == "1" || 1 ? row_original[:do_not_email] = true : row_original[:do_not_email] = false
        # end
        # If Contact has seller_id obtain information to create an associated lead resource

        # NOTE: Capture sales rep
        if row_original[:seller_id]
          first_name = row_original[:seller_id].split.first
          last_name  = row_original[:seller_id].split.last
          users      = User.where(first_name: first_name, last_name: last_name)
          users.each do |user|
            @rep = user if user.sales? || user.admin?
          end
        end

        # Create user if user does not exist
        user = User.find_by(email: row_original[:email])
        if user.nil? && !(row_original[:email].nil?) && !(row_original[:email].blank?) && !(row_original[:email].empty?) && !(row_original[:first_name].nil?) && !(row_original[:last_name].nil?)
          row_original.delete(:seller_id)
          row_original[:parent_id]  = @rep.try(:id)
          row_original[:password]   = row_original[:first_name].first(3) + row_original[:last_name].first(3) + "Password1"
          row_original[:status]     = 3
          row_original[:company_id] = Company.find_by(title: row_original[:company_name]).id unless Company.find_by(title: row_original[:company_name]).nil?
          # row_original[:first_name].capitalize! if row_original[:first_name].present?
          # row_original[:last_name].capitalize! if row_original[:last_name].present?
          user = User.new(row_original)
          user.save(:validate => false)
          Role.create(user_id: user.id, role: 4)
        end
        #  Create associated lead
        # if user && @rep
        #   # Lead.create(seller_id: @rep.id, buyer_id: user.id, status: 'assigned')
        # else
        #   email     = first_name + "." + last_name + "@nterone.com"
        #   password  = first_name.first(3) + last_name.first(3) + "Password1"
        #   @rep      = User.create(first_name: first_name, last_name: last_name, email: email, password: password)
        #   Role.create(user_id: @rep.id, role: 3)
        #   # Lead.create(seller_id: @rep.id, buyer_id: user.id, status: 'assigned')
        # end
      when "Leads"
        # NOTE: Capture sales rep
        if row_original[:seller_id]
          first_name = row_original[:seller_id].split.first
          last_name  = row_original[:seller_id].split.last
          users      = User.where(first_name: first_name, last_name: last_name)
          users.each do |user|
            @rep = user if user.sales? || user.admin?
          end
        end

        user = User.find_by(email: row_original[:email])
        if user.nil? && !(row_original[:email].nil?) && !(row_original[:email].blank?) && !(row_original[:email].empty?) && !(row_original[:first_name].nil?) && !(row_original[:last_name].nil?)
          row_original.delete(:seller_id)
          row_original[:parent_id]  = @rep.try(:id)
          row_original[:password]   = row_original[:first_name].first(3) + row_original[:last_name].first(3) + "Password1"
          row_original[:status]     = 0
          row_original[:company_id] = Company.find_by(title: row_original[:company_name]).id unless Company.find_by(title: row_original[:company_name]).nil?
          # row_original[:first_name].capitalize! if row_original[:first_name].present?
          # row_original[:last_name].capitalize! if row_original[:last_name].present?
          user = User.new(row_original)
          user.save(:validate => false)
          Role.create(user_id: user.id, role: 4)
        end
      when "Opportunities"
        if row_original[:account_id]
          company = Company.find_by(title: row_original[:account_id])
          row_original[:account_id] = company.nil? ? nil : company.id
        end

        if row_original[:amount]
          row_original[:amount] = row_original[:amount].to_d
        end

        # if row_original[:date_closed]
        #   row_original[:date_closed] = Date.strptime(row_original[:date_closed], '%m/%d/%Y').to_date
        # end

        # Associate Opportunity with rep if rep exists
        if row_original[:employee_id]
          # Must find by full name
          first_name = row_original[:employee_id].split.first
          last_name  = row_original[:employee_id].split.last
          users      = User.where(first_name: first_name, last_name: last_name)
          users.each do |user|
            @rep = user if user.sales? || user.admin?
          end
          if @rep
            row_original[:employee_id] = @rep.id
          # else
          #   email     = first_name + "." + last_name + "@nterone.com"
          #   password  = first_name.first(3) + last_name.first(3) + "Password1"
          #   rep      = User.create(first_name: first_name, last_name: last_name, email: email, password: password)
          #   Role.create(user_id: rep.id, role: 3)
          #   row_original[:employee_id] = rep.id
          end
        end
        if Opportunity.where(row_original).empty?
          opportunity = Opportunity.create(row_original)
          opportunity.update_attribute(:date_closed, row_original[:date_closed])
        end
      else
        # flash[:alert] = "Something went horribly wrong!"
        # return redirect_to :back
      end
    end
  end

end
