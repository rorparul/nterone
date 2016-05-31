class Registration < ActiveRecord::Base
  belongs_to :event

  has_one :order_item, as: :orderable
  has_one :order,      through: :order_item
end
