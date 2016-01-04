class SubjectGroup < ActiveRecord::Base
  belongs_to :subject
  belongs_to :group

  validates :subject, :group, presence: true
end
