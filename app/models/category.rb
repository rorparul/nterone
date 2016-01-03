class Category < ActiveRecord::Base
  scope :parent_categories, -> { where(parent_id: nil) }

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
    self.subjects.each do |subject|
      items << subject if items.exclude?(subject)
    end
    self.courses.each do |course|
      items << course if items.exclude?(course)
    end
    self.video_on_demands.each do |video_on_demand|
      items << video_on_demand if items.exclude?(video_on_demand)
    end
    items
  end

  def children_items
    items = []
    self.children.each do |child|
      child.subjects.each do |subject|
        items << subject if items.exclude?(subject)
      end
      child.courses.each do |course|
        items << course if items.exclude?(course)
      end
      child.video_on_demands.each do |video_on_demand|
        items << video_on_demand if items.exclude?(video_on_demand)
      end
    end
    items
  end

  private

  def delete_subjects
    Subject.joins('LEFT JOIN category_subjects on subjects.id = category_subjects.subject_id')
           .where(category_subjects: { id: nil })
           .delete_all
  end
end
