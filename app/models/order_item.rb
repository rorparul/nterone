class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :orderable, polymorphic: true
  belongs_to :cart

  before_save :copy_current_orderable_price

  validates :cart_id, uniqueness: { scope: [:orderable_id, :orderable_type] }

  private

  def copy_current_orderable_price
    self.price = self.orderable.price
  end
end
