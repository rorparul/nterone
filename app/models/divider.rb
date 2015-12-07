class Divider < ActiveRecord::Base
  belongs_to :platform

  has_many :group_items, as: :groupable, dependent: :destroy

  before_save :strip_content

  private

  def strip_content
    self.content.strip!
  end
end
