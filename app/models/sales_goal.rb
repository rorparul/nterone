# == Schema Information
#
# Table name: sales_goals
#
#  id            :integer          not null, primary key
#  month         :date
#  amount        :integer
#  description   :text
#  origin_region :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class SalesGoal < ActiveRecord::Base
  validates :month, presence: true, uniqueness: { scope: :origin_region }
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
