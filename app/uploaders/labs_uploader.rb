class LabsUploader
  def self.upload(file, company)
    spreadsheet = open_spreadsheet(file)
    header = format_header(spreadsheet.row(1))
    format_rows(spreadsheet, header, company)
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
      when "cancel"
        :canceled
      when "classdate"
        :first_day
      when "classenddate"
        :last_day
      when "company"
        :company_id
      when "confirmed"
        :confirmed
      when "courses"
        :course
      when "instructoremailaddress"
        :instructor_email
      when "instructorinformation"
        :instructor
      when "instructorphone"
        :instructor_phone
      when "location"
        :location
      when "notes"
        :notes
      when "starttime"
        :start_time
      when "studentemail"
        :email
      when "studentname"
        :name
      when "studentqty"
        :num_of_students
      when "timezone"
        :time_zone
      else
        :DELETE
      end
    end
  end

  def self.format_rows(spreadsheet, header, company)
    (2..spreadsheet.last_row).each do |i|
      row_original = Hash[[header, spreadsheet.row(i)].transpose]
      row_original.delete(:DELETE)

      if row_original[:canceled]
        if row_original[:canceled] == "CANCELED"
           row_original[:canceled] = true
        else
           row_original[:canceled] = false
        end
      end

      row_original[:company_id] = company.id

      if row_original[:confirmed]
        if row_original[:confirmed] == "YES"
           row_original[:confirmed] = true
        else
           row_original[:confirmed] = false
        end
      end

      # if row_original[:course]
      #
      # end
      #
      # if row_original[:email]
      #
      # end

      row_original[:end_time] = Time.new(2000, 01, 01, 17, 0, 0)

      if row_original[:first_day]
        # row_original[:first_day] = Date.strptime(row_original[:first_day], "%m/%d/%Y")
        modified_first_day_input = row_original[:first_day].gsub('="', '').gsub('"', '') if row_original[:first_day]
        if modified_first_day_input =~ /\//
          first_day = Date.strptime(modified_first_day_input, "%m/%d/%Y") if modified_first_day_input
          row_original[:first_day] = first_day if first_day
        end
      end

      # if row_original[:instructor]
      #
      # end

      if row_original[:instructor_email]
        unless row_original[:instructor_email] =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
           row_original[:instructor_email] = nil
        end
      end

      # if row_original[:instructor_phone]
      #
      # end

      if row_original[:last_day]
        row_original[:last_day] = Date.strptime(row_original[:last_day], "%m/%d/%Y")
      end

      case company
      when company.title == "Global Knowledge"
        row_original[:kind] = 1
      when company.title == "University of Phoenix"
        row_original[:kind] = 2
      else
        row_original[:kind] = 3
      end

      # if row_original[:location]
      #
      # end
      #
      # if row_original[:name]
      #
      # end
      #
      # if row_original[:notes]
      #
      # end
      #
      # if row_original[:num_of_students]
      #
      # end

      if row_original[:start_time]
        modified_start_time_input = row_original[:start_time].gsub('="', '').gsub('"', '') if row_original[:start_time]
        row_original[:start_time] = modified_start_time_input if modified_start_time_input
      end

      if row_original[:time_zone]
        case company
        when company.title == "Global Knowledge"
          row_original[:time_zone] = "Eastern Time (US & Canada)"
        when company.title == "University of Phoenix"
          row_original[:time_zone] = "Mountain Time (US & Canada)"
        else
          row_original[:time_zone] = "Eastern Time (US & Canada)"
        end
      end

      if LabRental.where(row_original).empty?
        lab_rental = LabRental.new(row_original)
        lab_course = LabCourse.find_by(title: row_original[:course])
        if lab_course
          lab_rental.assign_attributes(lab_course_id: lab_course.id)
        else
          lab_course = LabCourse.create(title: row_original[:course], company_id: company.id)
          lab_rental.assign_attributes(lab_course_id: lab_course.id)
        end

        lab_rental.save
        if row_original[:email]
          lab_student = LabStudent.find_by(email: row_original[:email])
          if lab_student
            lab_student.update_attribute(:lab_rental_id, lab_rental.id)
          else
            lab_student = LabStudent.new(lab_rental_id: lab_rental.id, name: row_original[:name], email: row_original[:email])
            lab_student.save(validate: false)
          end
          lab_rental.save
        end
      end
    end
  end
end
