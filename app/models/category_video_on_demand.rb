# == Schema Information
#
# Table name: category_video_on_demands
#
#  id                 :integer          not null, primary key
#  category_id        :integer
#  video_on_demand_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  origin_region      :integer
#

class CategoryVideoOnDemand < ActiveRecord::Base
  include Regions

  belongs_to :category
  belongs_to :video_on_demand

  validates :category_id, uniqueness: { scope: :video_on_demand_id }
end
