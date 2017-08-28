# == Schema Information
#
# Table name: checklists
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#

class Checklist < ActiveRecord::Base
  has_many :items, class_name: "ChecklistItem"
end
