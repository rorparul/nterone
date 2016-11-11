class AssignedItem < ActiveRecord::Base
  belongs_to :assigner, class_name: 'User'
  belongs_to :student,  class_name: 'User'
  belongs_to :item,     polymorphic: true
end
