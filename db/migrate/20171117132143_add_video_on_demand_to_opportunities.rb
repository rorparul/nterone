class AddVideoOnDemandToOpportunities < ActiveRecord::Migration
  def change
    add_reference :opportunities, :video_on_demand
  end
end
