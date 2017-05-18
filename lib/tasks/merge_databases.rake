namespace "merge" do
  task "databases" => :environment do
    @database = "nterone-la"
    @main_database = Rails.env.development? ? "development" : "production"
    region = @database.split('-').last
    Rails.application.config.tld = region

    origin_region = case region
                    when 'com'
                      0
                    when 'la'
                      1
                    when 'ca'
                      2
                    else
                      0
                    end

    all_tables = ActiveRecord::Base.connection.tables.to_a
    all_tables.each do |table|
      begin
        klass = table.singularize.camelize.constantize
      rescue => exception
        next
      else
        active_region = klass.origin_regions.key(origin_region)

        # connect to slave database
        ActiveRecord::Base.establish_connection(@database)
        records = ActiveRecord::Base.connection.execute("select * from #{table}").to_a
        records.map! do |record|
          record.delete('id')
          record['origin_region'] = record['origin_region'].to_i
          record
        end

        # connect to main database
        ActiveRecord::Base.establish_connection(@main_database)
        # delete all records with origin_region
        klass.where("origin_region = #{origin_region}").delete_all
        # insert new records
        klass.create(records) do |record|
          record.origin_region = active_region
          record.active_regions = "{#{active_region}}"
        end
      end
    end
  end
end