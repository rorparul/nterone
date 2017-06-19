class AddActiveRegionsToAllTables < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.tables.each do |table|
      begin
        klass = table.singularize.camelize.constantize
      rescue => exception
      else
        if !klass.column_names.include?("active_regions")
          add_column table, :active_regions, :text, array: true, default: []
        end
      end
    end
  end
end
