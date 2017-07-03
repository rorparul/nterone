# class SetOriginRegionToUnitedStates < ActiveRecord::Migration
#   def change
#     ActiveRecord::Base.connection.tables.each do |table|
#       begin
#         klass = table.singularize.camelize.constantize
#       rescue => exception
#       else
#         # set origin_region
#         if klass.column_names.include?("origin_region")
#           p klass.unscoped.where("origin_region is null").count
#           klass.unscoped.where("origin_region is null").update_all("origin_region": 0)
#         end
#       end
#     end
#   end
# end
