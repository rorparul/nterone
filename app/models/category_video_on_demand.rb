class CategoryVideoOnDemand < ActiveRecord::Base
  belongs_to :category
  belongs_to :video_on_demand

  validates :category_id, uniqueness: { scope: :video_on_demand_id }
end
