# == Schema Information
#
# Table name: dividers
#
#  id          :integer          not null, primary key
#  platform_id :integer
#  content     :string
#  shortname   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Divider < ActiveRecord::Base
  belongs_to :platform

  has_many :group_items, as: :groupable, dependent: :destroy

  before_save :strip_content

  validates :content, presence: true

  private

  def strip_content
    self.content.strip!
  end
end
