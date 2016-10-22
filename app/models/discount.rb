# == Schema Information
#
# Table name: discounts
#
#  id         :integer          not null, primary key
#  active     :boolean
#  date_end   :date
#  date_start :date
#  limit      :integer
#  code       :string
#  kind       :string
#  value      :decimal(, )
#

class Discount < ActiveRecord::Base

  has_many :orders
  has_one :discount_filter, dependent: :destroy
  accepts_nested_attributes_for :discount_filter

  validates :code, :kind, :value, presence: true

end
