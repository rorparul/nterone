class Subscription < ActiveRecord::Base
  belongs_to :video_on_demand

  has_one :order_item, as: :orderable
  has_one :order,      through: :order_item
end
