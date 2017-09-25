class AddIndexOnOriginRegionToAllModels < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.tables.each do |table|
      begin
        klass = table.singularize.camelize.constantize
        if klass.column_names.include?("origin_region")
          add_index table, :origin_region
        end
      rescue => exception
      end
    end
  end
end
