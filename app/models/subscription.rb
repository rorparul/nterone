class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :video_on_demand
end
