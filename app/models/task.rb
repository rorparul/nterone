# == Schema Information
#
# Table name: tasks
#
#  id             :integer          not null, primary key
#  activity_date  :datetime
#  description    :text
#  rep_id         :integer
#  priority       :integer          default(2)
#  subject        :string
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  complete       :boolean          default(FALSE)
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_tasks_on_origin_region  (origin_region)
#

class Task < ActiveRecord::Base
  include SearchCop
  include Regions

  belongs_to :user
  belongs_to :rep, class_name: "User", foreign_key: :rep_id

  validates :activity_date, :priority, :subject, presence: true

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
