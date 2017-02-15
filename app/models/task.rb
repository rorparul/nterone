class Task < ActiveRecord::Base
  include SearchCop
  
  belongs_to :user
  belongs_to :rep, class_name: "User", foreign_key: :rep_id

  validates :activity_date, :rep_id, :priority, :subject, presence: true

  search_scope :custom_search do
    attributes :subject, :description
  end

  def priority_in_words
    if priority == 1
      "Low"
    elsif priority == 2
      "Normal"
    else
      "High"
    end
  end
end
