class SetActiveRegionsForUnitedStates < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.tables.each do |table|
      begin
        klass = table.singularize.camelize.constantize
      rescue => exception
      else
        if klass.column_names.include?("active_regions")
          klass.unscoped.where("active_regions @> ?", '{""}').each do |record|
            record.active_regions = "{#{klass.origin_regions.key(0)}}"
            record.save
          end
        end
      end
    end
  end
end
