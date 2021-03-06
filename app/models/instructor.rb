# == Schema Information
#
# Table name: instructors
#
#  id             :integer          not null, primary key
#  first_name     :string
#  last_name      :string
#  biography      :string
#  email          :string
#  phone          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  platform_id    :integer
#  status         :integer          default(0)
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#  archived       :boolean          default(FALSE)
#
# Indexes
#
#  index_instructors_on_origin_region  (origin_region)
#

class Instructor < ActiveRecord::Base
  include Regions

  enum status: { employee: 0, contractor: 1 }

  belongs_to :platform
  has_many   :events
  has_many   :video_on_demands

  validates_presence_of   :first_name, :last_name, :email
  validates_uniqueness_of :email

  after_initialize :set_all_regions, if: :new_record?

  def full_name
    "#{first_name} #{last_name}"
  end

  def events_in_range(start_date, end_date)
    self.events.where(start_date: start_date..end_date)
  end
end
