class SetActiveRegionsForUnitedStates < ActiveRecord::Migration
  # def change
  #   ActiveRecord::Base.connection.tables.each do |table|
  #     begin
  #       klass = table.singularize.camelize.constantize
  #     rescue => exception
  #     else
  #       # set active_regions
  #       if klass.column_names.include?("active_regions")
  #         p klass.unscoped.where("active_regions = ? or active_regions = ?", '{}', '{""}').count
  #         klass.unscoped.where("active_regions = ? or active_regions = ?", '{}', '{""}').update_all("active_regions": "{#{klass.origin_regions.key(0)}}")
  #       end
  #       # set origin_region
  #       if klass.column_names.include?("origin_region")
  #         p klass.unscoped.where("origin_region = ?", nil).count
  #         klass.unscoped.where("origin_region = ?", nil).update_all("origin_region": 0)
  #       end
  #     end
  #   end
  # end
end
