class Cart < ActiveRecord::Base
  has_many :order_items, dependent: :destroy

  def total_price
    order_items.to_a.sum { |item| item.price }
  end
end
