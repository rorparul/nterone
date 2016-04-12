class Category < ActiveRecord::Base
  extend FriendlyId
  scope :parent_categories, -> { where(parent_id: nil) }

  friendly_id :title, use: [:slugged, :finders]

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

  def items
    items = []
    self.subjects.where(active: true).each do |subject|
      items << subject if items.exclude?(subject)
    end
    self.courses.where(active: true).each do |course|
      items << course if items.exclude?(course)
    end
    self.video_on_demands.where(active: true).each do |video_on_demand|
      items << video_on_demand if items.exclude?(video_on_demand)
    end
    sorted(items)
  end

  def children_items
    items = []
    self.children.each do |child|
      child.subjects.where(active: true).each do |subject|
        items << subject if items.exclude?(subject)
      end
      child.courses.where(active: true).each do |course|
        items << course if items.exclude?(course)
      end
      child.video_on_demands.where(active: true).each do |video_on_demand|
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
        a.title.downcase <=> b.title.abbreviation
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
