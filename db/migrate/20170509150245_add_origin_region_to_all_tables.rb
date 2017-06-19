class AddOriginRegionToAllTables < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.tables.each do |table|
      begin
        klass = table.singularize.camelize.constantize
      rescue => exception
      else
        if !klass.column_names.include?("origin_region")
          add_column table, :origin_region, :integer
        end
      end
    end
  end
end
