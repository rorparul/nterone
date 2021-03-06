# == Schema Information
#
# Table name: subjects
#
#  id               :integer          not null, primary key
#  title            :string
#  description      :text
#  type             :string
#  created_at       :datetime
#  updated_at       :datetime
#  abbreviation     :string
#  platform_id      :integer
#  slug             :string
#  page_title       :string
#  page_description :text
#  partner_led      :boolean          default(FALSE)
#  active           :boolean          default(TRUE)
#  heading          :string
#  origin_region    :integer
#  active_regions   :text             default([]), is an Array
#  archived         :boolean          default(FALSE)
#
# Indexes
#
#  index_subjects_on_origin_region  (origin_region)
#  index_subjects_on_slug           (slug)
#

class Subject < ActiveRecord::Base
  extend FriendlyId
  include Imageable
  include Regions

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :abbreviation,
      [:abbreviation, :title],
      [:abbreviation, :title, :origin_region]
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

  after_initialize :set_all_regions, if: :new_record?

  scope :active, -> { where(archived: false) }

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

    where(active: true).where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{query.try(:downcase)}%").each do |subject|
      subjects << subject
    end

    Course.where("LOWER(title) like ?", "%#{query.try(:downcase)}%").each do |course|
      course.group_items.each do |group_item|
        if group_item.group
          if group_item.group.header.downcase.include?("recommended")
            group_item.group.subjects.each do |subject|
              if subject.active
                subjects << subject
              end
            end
          end
        end
      end

      course.exam_and_course_dynamics.each do |exam_and_course_dynamic|
        exam_and_course_dynamic.group_items.each do |group_item|
          if group_item.group
            if group_item.group.header.downcase.include?("recommended")
              group_item.group.subjects.each do |subject|
                if subject.active
                  subjects << subject
                end
              end
            end
          end
        end
      end
    end

    Exam.where("LOWER(title) like ?", "%#{query.try(:downcase)}%").each do |exam|
      exam.exam_and_course_dynamics.each do |exam_and_course_dynamic|
        exam_and_course_dynamic.group_items.each do |group_item|
          if group_item.group
            if group_item.group.header.downcase.include?("recommended")
              group_item.group.subjects.each do |subject|
                if subject.active
                  subjects << subject
                end
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
