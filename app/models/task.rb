class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :rep, class_name: "User", foreign_key: :rep_id

  validates :activity_date, :rep_id, :priority, :subject, presence: true
end
