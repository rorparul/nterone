class Subject < ActiveRecord::Base
  extend FriendlyId
  include Imageable

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :abbreviation,
      [:abbreviation, :title]
    ]
  end

  belongs_to :platform

  has_many :category_subjects, dependent: :destroy
  has_many :categories,        through: :category_subjects
  has_many :subject_groups,    dependent: :destroy
  has_many :groups,            through: :subject_groups
  has_many :planned_subjects,  dependent: :destroy
  has_many :users,             through: :planned_subjects

  has_one  :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  validates :categories, :title, :abbreviation, presence: true
  validates_associated :categories

  def full_title
    if abbreviation.present?
      "#{abbreviation}: #{title}"
    else
      title
    end
  end

  # TODO: Optimize search performance
  def self.search(query)
    subjects = []

    where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{query.downcase}%").each do |subject|
      subjects << subject
    end

    Course.where("LOWER(title) like ?", "%#{query.downcase}%").each do |course|
      course.group_items.each do |group_item|
        if group_item.group
          if group_item.group.header.downcase.include?("recommended")
            group_item.group.subjects.each do |subject|
              subjects << subject
            end
          end
        end
      end

      course.exam_and_course_dynamics.each do |exam_and_course_dynamic|
        exam_and_course_dynamic.group_items.each do |group_item|
          if group_item.group
            if group_item.group.header.downcase.include?("recommended")
              group_item.group.subjects.each do |subject|
                subjects << subject
              end
            end
          end
        end
      end
    end

    Exam.where("LOWER(title) like ?", "%#{query.downcase}%").each do |exam|
      exam.exam_and_course_dynamics.each do |exam_and_course_dynamic|
        exam_and_course_dynamic.group_items.each do |group_item|
          if group_item.group
            if group_item.group.header.downcase.include?("recommended")
              group_item.group.subjects.each do |subject|
                subjects << subject
              end
            end
          end
        end
      end
    end

    subjects.uniq
  end

  def courses
    courses = []
    self.groups.each do |group|
      group.group_items.each do |group_item|
        type   = group_item.groupable_type
        object = group_item.groupable
        if type == "Course"
          courses << object
        elsif type == "ExamAndCourseDynamic"
          object.courses.each do |course|
            courses << course
          end
        elsif type == "Exam"
          object.courses.each do |course|
            courses << course
          end
        end
      end
    end
    courses
  end
end
