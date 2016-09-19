class LabsUploader
  def self.upload(file)
      if file.original_filename == "globalknowledge.csv"
        spreadsheet = open_spreadsheet(file)
        header = format_header_gk(spreadsheet.row(1))
        format_rows_gk(spreadsheet, header)
      elsif file.original_filename == "universityofphoenix.csv"
        spreadsheet = open_spreadsheet(file)
        header = format_header_up(spreadsheet.row(1))
        format_rows_up(spreadsheet, header)
      else
        return
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

  def self.format_header_up(row)
    row.map do |column|
      case column
      when "courses"
        :course
      when "classdate"
        :first_day
      when "classenddate"
        :last_day
      when "studentname"
        :name
      when "studentemail"
        :email
      when "instructorinformation"
        :instructor
      when "instructoremailaddress"
        :instructor_email
      when "notes"
        :notes
      end
    end
  end

  def self.format_header_gk(row)
    row.map do |column|
      case column
      when "courses"
        :course
      when "classdate"
        :first_day
      when "studentqty"
        :num_of_students
      when "starttime"
        :start_time
      when "instructorinformation"
        :instructor
      when "instructoremailaddress"
        :instructor_email
      when "instructorphone"
        :instructor_phone
      when "notes"
        :notes
      when "location"
        :location
      when "confirmed"
        :confirmed
      when "company"
        :company_id
      when "timezone"
        :time_zone
      when "cancel"
        :canceled
      end
    end
  end

  def self.format_rows_up(spreadsheet, header)
    company = Company.find_by(title: "University of Phoenix")
    (2..spreadsheet.last_row).each do |i|
      row_original = Hash[[header, spreadsheet.row(i)].transpose]
      unless row_original[:instructor_email] =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
         row_original[:instructor_email] = nil
      end
      lab_rental = LabRental.new(
        company_id: company.id,
        start_time: "%8:%0:%0",
        end_time: "%17:%0:%0",
        time_zone: "Mountain Time (US & Canada)",
        notes: row_original[:notes],
        instructor_email: row_original[:instructor_email],
        instructor: row_original[:instructor],
        first_day: row_original[:first_day],
        last_day: row_original[:last_day],
        kind: 2
      )

      lab_course = LabCourse.find_by(title: row_original[:course])
      if lab_course
        lab_rental.assign_attributes(lab_course_id: lab_course.id)
      else
        lab_course = LabCourse.create(title: row_original[:course], company_id: company.id)
        lab_rental.assign_attributes(lab_course_id: lab_course.id)
      end
      lab_rental.save

      lab_student = LabStudent.find_by(email: row_original[:email])
      if lab_student
        lab_student.update_attribute(:lab_rental_id, lab_rental.id)
      else
        lab_student = LabStudent.new(lab_rental_id: lab_rental.id, name: row_original[:name], email: row_original[:email])
        lab_student.save(validate: false)
      end
    end
  end


  def self.format_rows_gk(spreadsheet, header)
    company = Company.find_by(title: "Global Knowledge")
    (2..spreadsheet.last_row).each do |i|
      row_original = Hash[[header, spreadsheet.row(i)].transpose]
      row_original[:company_id] = company.id
      row_original[:end_time] = "%17:%0:%0"
      row_original[:time_zone] = "Eastern Time (US & Canada)"
      unless row_original[:instructor_email] =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
         row_original[:instructor_email] = nil
      end
      if row_original[:confirmed] == "YES"
         row_original[:confirmed] = true
      else
         row_original[:confirmed] = false
      end
      if row_original[:canceled] == "CANCELED"
         row_original[:canceled] = true
      else
         row_original[:canceled] = false
      end
      row_new    = row_original.dup
      lab_rental = LabRental.new(row_new)
      lab_course = LabCourse.find_by(title: row_original[:course])
      if lab_course
        lab_rental.assign_attributes(lab_course_id: lab_course.id, kind: 1)
      else
        lab_course = LabCourse.create(title: row_original[:course], company_id: company.id)
        lab_rental.assign_attributes(lab_course_id: lab_course.id, kind: 1)
      end
      lab_rental.save
    end # (2..spreadsheet.last_row).each do |i|
  end # format_rows_gk

end
