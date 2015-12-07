class Category < ActiveRecord::Base
  scope :parent_categories, -> { where(parent_id: nil) }

  belongs_to :platform
  belongs_to :parent, class_name: 'Category'

  has_many   :children, class_name: 'Category', foreign_key: 'parent_id'
  has_many   :category_subjects, dependent: :destroy
  has_many   :subjects, through: :category_subjects

  def children_subjects
    subjects = []
    self.children.each do |child|
      child.subjects.each do |subject|
        subjects << subject if subjects.exclude?(subject)
      end
    end
    subjects
  end

  private

  def delete_subjects
    Subject.joins('LEFT JOIN category_subjects on subjects.id = category_subjects.subject_id')
           .where(category_subjects: { id: nil })
           .delete_all
  end
end
