class CategorySubject < ActiveRecord::Base
  belongs_to :category
  belongs_to :subject

  validates :category_id, uniqueness: { scope: :subject_id }
end
