# == Schema Information
#
# Table name: dividers
#
#  id             :integer          not null, primary key
#  platform_id    :integer
#  content        :string
#  shortname      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#  archived       :boolean          default(FALSE)
#
# Indexes
#
#  index_dividers_on_origin_region  (origin_region)
#

class Divider < ActiveRecord::Base
  include Regions

  belongs_to :platform

  has_many :group_items, as: :groupable, dependent: :destroy

  validates :content, presence: true

  after_initialize :set_all_regions, if: :new_record?
  
  before_save :strip_content

  private

  def strip_content
    self.content.strip!
  end
end
