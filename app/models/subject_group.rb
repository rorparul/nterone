# == Schema Information
#
# Table name: subject_groups
#
#  id            :integer          not null, primary key
#  subject_id    :integer
#  group_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  origin_region :integer
#

class SubjectGroup < ActiveRecord::Base
  include Regions

  belongs_to :subject
  belongs_to :group

  validates :subject, :group, presence: true
end
