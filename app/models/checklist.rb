# == Schema Information
#
# Table name: checklists
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  name           :string
#  active_regions :text             default([]), is an Array
#  origin_region  :integer
#

class Checklist < ActiveRecord::Base
  include SearchCop
  include Regions

  has_many :items, class_name: "ChecklistItem"
  accepts_nested_attributes_for :items, allow_destroy: true

end
