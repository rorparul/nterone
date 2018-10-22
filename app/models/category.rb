# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  platform_id        :integer
#  title              :string
#  parent_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  slug               :string
#  position_as_parent :integer          default(0)
#  position_as_child  :integer          default(0)
#  position           :integer          default(0)
#  description        :text
#  page_title         :string
#  heading            :string
#  meta_description   :text
#  video              :text
#  origin_region      :integer
#  active_regions     :text             default([]), is an Array
#  archived           :boolean          default(FALSE)
#
# Indexes
#
#  index_categories_on_origin_region  (origin_region)
#  index_categories_on_parent_id      (parent_id)
#  index_categories_on_platform_id    (platform_id)
#  index_categories_on_slug           (slug)
#

class Category < ActiveRecord::Base
  include Regions
  extend FriendlyId
  scope :parent_categories, -> { where(parent_id: nil) }

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [:title, [:title, :origin_region]]
  end

  belongs_to :platform
  belongs_to :parent, class_name: 'Category'

  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :category_subjects, dependent: :destroy
  has_many :subjects, through: :category_subjects
  has_many :category_courses, dependent: :destroy
  has_many :courses, through: :category_courses
  has_many :category_video_on_demands, dependent: :destroy
  has_many :video_on_demands, through: :category_video_on_demands

  validates :title, presence: true

  after_initialize :set_all_regions, if: :new_record?

  scope :active, -> { where(archived: false) }

  def items
    items = []
    self.subjects.current_region.where(active: true, archived: false).each do |subject|
      items << subject if items.exclude?(subject)
    end
    self.courses.current_region.where(active: true, archived: false).each do |course|
      items << course if items.exclude?(course)
    end
    self.video_on_demands.current_region.where(active: true, archived: false, lms: false).each do |video_on_demand|
      items << video_on_demand if items.exclude?(video_on_demand)
    end
    sorted(items)
  end

  def children_items
    items = []
    self.children.each do |child|
      child.subjects.current_region.where(active: true, archived: false).each do |subject|
        items << subject if items.exclude?(subject)
      end
      child.courses.current_region.where(active: true, archived: false).each do |course|
        items << course if items.exclude?(course)
      end
      child.video_on_demands.current_region.where(active: true, archived: false, lms: false).each do |video_on_demand|
        items << video_on_demand if items.exclude?(video_on_demand)
      end
    end
    sorted(items)
  end

  private

  # TODO: The partner_led filter puts them at the end but not alphabetically
  def sorted(items)
    items.sort do |a, b|
      if a.abbreviation && b.abbreviation
        a.abbreviation.downcase <=> b.abbreviation.downcase
      else
        a.title.downcase <=> b.abbreviation.try(:downcase)
      end
      a.partner_led.to_s <=> b.partner_led.to_s
    end
  end

  def delete_subjects
    Subject.joins('LEFT JOIN category_subjects on subjects.id = category_subjects.subject_id')
           .where(category_subjects: { id: nil })
           .delete_all
  end
end
