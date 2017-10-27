class AddOriginRegionToAllTables2 < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.tables.each do |table|
      begin
        klass = table.singularize.camelize.constantize
      rescue => exception
      else
        unless klass.column_names.include?("origin_region")
          add_column table, :origin_region, :integer
          add_index table, :origin_region
        end
        unless klass.column_names.include?("active_regions")
          add_column table, :active_regions, :text, array: true, default: []
        end
      end
    end
  end
end
