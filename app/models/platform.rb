# == Schema Information
#
# Table name: platforms
#
#  id                 :integer          not null, primary key
#  title              :string
#  created_at         :datetime
#  updated_at         :datetime
#  url                :string
#  slug               :string
#  page_title         :string
#  page_description   :text
#  satellite_viewable :boolean          default(TRUE)
#
# Indexes
#
#  index_platforms_on_slug  (slug)
#

class Platform < ActiveRecord::Base
  extend FriendlyId
  include Imageable

  friendly_id :title, use: [:slugged, :finders]

  has_many :categories, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :exams, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :events, through: :courses
  has_many :dividers, dependent: :destroy
  has_many :custom_items, dependent: :destroy
  has_many :exam_and_course_dynamics, dependent: :destroy
  has_many :instructors, dependent: :destroy
  has_many :video_on_demands, dependent: :destroy

  has_one :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  delegate :parent_categories, to: :categories

  validates :title, presence: true
  validates_associated :image

  def upcoming_events
    events.where("events.active = :active and start_date >= :start_date", { active: true, start_date: Date.today }).order(:start_date)
  end

  def featured_upcoming_events
    events.where("events.active = :active and guaranteed = :guaranteed and start_date >= :start_date", { active: true, guaranteed: true, start_date: Date.today }).order(:start_date)
  end

  def upcoming_public_featured_events(host = nil)
    events.where(
      "events.active = :active and public = :public and guaranteed = :guaranteed and start_date >= :start_date",
      { active: true, public: true, guaranteed: true, start_date: Date.today }
    ).order(:start_date)

    # if host == 'www.nterone.com'
    #   ActiveRecord::Base.establish_connection(
    #     adapter:  "postgresql",
    #     host:     "184.7.26.56",
    #     username: "pguser",
    #     password: "qwe123",
    #     database: "db1_prod"
    #   )
    # end
    #
    # if host == 'www.nterone.la'
    #   ActiveRecord::Base.establish_connection(
    #     adapter:  "postgresql",
    #     host:     "184.7.26.58",
    #     username: "pguser",
    #     password: "qwe123",
    #     database: "db1_prod"
    #   )
    # end
  end

  def export
    CSV.generate do |csv|
      #Platform
      csv << ["Class", "Platform"]
      column_names = Platform.column_names
      csv << column_names
      csv << attributes.values_at(*column_names)
      csv << []

      #Category
      csv << ["Class", "Category"]
      column_names = Category.column_names
      csv << column_names
      categories.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
      csv << []

      #CategorySubject
      csv << ["Class", "CategorySubject"]
      column_names = CategorySubject.column_names
      csv << column_names
      categories.each do |item|
        item.category_subjects.each do |item2|
          csv << item2.attributes.values_at(*column_names)
        end
      end
      csv << []

      #CategoryCourse
      csv << ["Class", "CategoryCourse"]
      column_names = CategoryCourse.column_names
      csv << column_names
      categories.each do |item|
        item.category_courses.each do |item2|
          csv << item2.attributes.values_at(*column_names)
        end
      end
      csv << []

      #CategorySubject
      csv << ["Class", "CategoryVideoOnDemand"]
      column_names = CategoryVideoOnDemand.column_names
      csv << column_names
      categories.each do |item|
        item.category_video_on_demands.each do |item2|
          csv << item2.attributes.values_at(*column_names)
        end
      end
      csv << []

      #Subject
      csv << ["Class", "Subject"]
      column_names = Subject.column_names
      csv << column_names
      subjects.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
      csv << []

      #Course
      csv << ["Class", "Course"]
      column_names = Course.column_names
      csv << column_names
      courses.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
      csv << []

      #VideoOnDemand
      csv << ["Class", "VideoOnDemand"]
      column_names = VideoOnDemand.column_names
      csv << column_names
      video_on_demands.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
      csv << []

      #Group
      csv << ["Class", "Group"]
      column_names = Group.column_names
      csv << column_names
      subjects.each do |item|
        item.groups.each do |item2|
          csv << item2.attributes.values_at(*column_names)
        end
      end
      csv << []

      #VideoModule
      csv << ["Class", "VideoModule"]
      column_names = VideoModule.column_names
      csv << column_names
      video_on_demands.each do |item|
        item.video_modules.each do |item2|
          csv << item2.attributes.values_at(*column_names)
        end
      end
      csv << []

      #Video
      csv << ["Class", "Video"]
      column_names = Video.column_names
      csv << column_names
      video_on_demands.each do |item|
        item.video_modules.each do |item2|
          item2.videos.each do |item3|
            csv << item3.attributes.values_at(*column_names)
          end
        end
      end
      csv << []

      #SubjectGroup
      csv << ["Class", "SubjectGroup"]
      column_names = SubjectGroup.column_names
      csv << column_names
      subjects.each do |item|
        item.subject_groups.each do |item2|
          csv << item2.attributes.values_at(*column_names)
        end
      end
      csv << []

      #GroupItem
      csv << ["Class", "GroupItem"]
      column_names = GroupItem.column_names
      csv << column_names
      subjects.each do |item|
        item.groups.each do |item2|
          item2.group_items.each do |item3|
            csv << item3.attributes.values_at(*column_names)
          end
        end
      end
      csv << []

      #Exam
      csv << ["Class", "Exam"]
      column_names = Exam.column_names
      csv << column_names
      exams.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
      csv << []

      #Divider
      csv << ["Class", "Divider"]
      column_names = Divider.column_names
      csv << column_names
      dividers.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
      csv << []

      #CustomItem
      csv << ["Class", "CustomItem"]
      column_names = CustomItem.column_names
      csv << column_names
      custom_items.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
      csv << []

      #ExamAndCourseDynamics
      csv << ["Class", "ExamAndCourseDynamic"]
      column_names = ExamAndCourseDynamic.column_names
      csv << column_names
      exam_and_course_dynamics.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
      csv << []

      #ExamDynamic
      csv << ["Class", "ExamDynamic"]
      column_names = ExamDynamic.column_names
      csv << column_names
      exam_and_course_dynamics.each do |item|
        item.exam_dynamics.each do |item2|
          csv << item2.attributes.values_at(*column_names)
        end
      end
      csv << []

      #CourseDynamic
      csv << ["Class", "CourseDynamic"]
      column_names = CourseDynamic.column_names
      csv << column_names
      exam_and_course_dynamics.each do |item|
        item.course_dynamics.each do |item2|
          csv << item2.attributes.values_at(*column_names)
        end
      end
      csv << []

      #Images
      csv << ["Class", "Image"]
      column_names = Image.column_names
      csv << column_names
      if image
        csv << image.attributes.values_at(*column_names)
      end
      subjects.each do |item|
        if item.image
          csv << item.image.attributes.values_at(*column_names)
        end
      end
      csv << []
    end
  end

  def self.incremented_values(current_class, current_attributes, row)
    row = row
    current_attributes.each do |attribute|
      if attribute == "id" || attribute.include?("_id")
        if attribute == "id"
          increment = current_class.constantize.maximum(:id).try(:next) || 1
        elsif attribute.include?("_id")
          if attribute[0..-4].camelize == "Parent"
            increment = Category.maximum(:id).try(:next) || 1
          elsif attribute[0..-4].camelize == "Groupable"
            increment = row[2].constantize.maximum(:id).try(:next) || 1
          elsif attribute[0..-4].camelize == "Imageable"
            increment = row[3].constantize.maximum(:id).try(:next) || 1
          else
            increment = attribute[0..-4].camelize.constantize.maximum(:id).try(:next) || 1
          end
        end
        index = current_attributes.index(attribute)
        if row[index]
          row[index] = row[index].to_i + increment
        end
      end
    end
    row
  end

  def self.import(import_file)
    begin
      temp_dir = "#{Rails.public_path}/unzipped"
      Zip::File.open(import_file.path) do |zip|
        if Dir.exist?(temp_dir)
          FileUtils.rm_rf(temp_dir)
        end
        Dir.mkdir(temp_dir)
        zip.each do |item|
          item.extract("#{temp_dir}/#{item.name}")
        end
      end

      collection         = {}
      current_class      = nil
      current_attributes = nil
      CSV.foreach("#{temp_dir}/data.csv") do |row|
        if row[0] == "Class"
          current_class = row[1]
        elsif row[0] == "id"
          current_attributes = row
        elsif row.empty?
          current_class      = nil
          current_attributes = nil
        else
          new_values = incremented_values(current_class, current_attributes, row)
          unless collection[current_class]
            collection[current_class] = []
          end
          collection[current_class] << Hash[current_attributes.zip new_values]
        end
      end

      collection.each do |k, v|
        next if k == "Image"
        current_class = k.constantize
        if k == "Platform" || k == "Subject"
          v.each do |current_attributes|
            image_path = nil
            collection["Image"].each do |c|
              if c["imageable_type"] == k && c["imageable_id"] == current_attributes["id"] && c["file"] != nil
                image_path = "#{temp_dir}/#{c['file']}"
                break
              end
            end
            if image_path
              new_record = current_class.new(current_attributes)
              new_record.save(validate: false)
              new_record.set_image(url_param: image_path, for: :image, bulk: true)
            else
              new_record = current_class.create(current_attributes)
              new_record.save(validate: false)
            end
          end
        else
          v.each do |current_attributes|
            new_record = current_class.create(current_attributes)
            new_record.save(validate: false)
          end
        end
      end
    ensure
      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end

      FileUtils.rm_rf(temp_dir)
    end
  end

  def contained_images
    images = [image]
    subjects.each do |item|
      if item.image && item.image.file.file
        images << item.image unless images.any? { |img| img.file.url.split('/').last == item.image.file.url.split('/').last }
      end
    end
    images
  end
end
