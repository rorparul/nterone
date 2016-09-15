# == Schema Information
#
# Table name: category_subjects
#
#  id          :integer          not null, primary key
#  category_id :integer
#  subject_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class CategorySubject < ActiveRecord::Base
  belongs_to :category
  belongs_to :subject

  validates :category_id, uniqueness: { scope: :subject_id }
end
