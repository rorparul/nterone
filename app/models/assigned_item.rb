# == Schema Information
#
# Table name: assigned_items
#
#  id          :integer          not null, primary key
#  assigner_id :integer
#  student_id  :integer
#  item_id     :integer
#  item_type   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_assigned_items_on_item_type_and_item_id  (item_type,item_id)
#

class AssignedItem < ActiveRecord::Base
  belongs_to :assigner, class_name: 'User'
  belongs_to :student,  class_name: 'User'
  belongs_to :item,     polymorphic: true
end
