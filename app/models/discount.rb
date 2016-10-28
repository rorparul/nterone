# == Schema Information
#
# Table name: discounts
#
#  id         :integer          not null, primary key
#  active     :boolean          default(TRUE)
#  date_end   :date
#  date_start :date
#  limit      :integer
#  code       :string
#  kind       :string
#  value      :decimal(8, 2)    default(0.0)
#

class Discount < ActiveRecord::Base
  has_many :orders
  has_many :order_items, through: :orders

  has_one :discount_filter, dependent: :destroy

  accepts_nested_attributes_for :discount_filter

  validates :code, :kind, :value, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0.00 }
  validates :code, uniqueness: true

  def active_and_within_bounds?
    return false if active == false
    return false if limit.present? && order_items.count > limit

    if date_start.present? && date_end.present?
      Date.today >= date_start && Date.today <= date_end
    elsif date_start.nil? && date_end.nil?
      true
    else
      if date_start.present?
        return Date.today >= date_start
      end

      if date_end.present?
        return Date.today <= date_end
      end
    end
  end
end
