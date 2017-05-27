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
    @models = []
    all_tables.each do |table|
      begin
        klass = table.singularize.camelize.constantize
        @models << klass
      rescue => exception
      end
    end

    @post_updates = []

    # remove records
    puts "Removing records for region: #{region}..."
    @models.each do |model|
      model.unscoped.where(origin_region: origin_region).delete_all
    end

    def merge_simple model
      puts "Merging for model: #{model.model_name.name}"
      ActiveRecord::Base.establish_connection(@database)
      records = model.unscoped.all.to_a
      ActiveRecord::Base.establish_connection(@main_database)
      ids = {}
      records.each do |rec|
        id = rec.id
        begin
          new_rec = model.create rec.attributes.except("id")
          unless new_rec.persisted?
            new_rec.save(validate: false)
          end
          ids[id] = new_rec.id  if new_rec.id
        rescue Exception => e
          ap e
        end
      end
      relations = {}
      @models.each do |klass|
        klass.reflections.each do |name, reflection|
          if reflection.is_a?(ActiveRecord::Reflection::BelongsToReflection)
            class_name = reflection.options[:class_name] || reflection.plural_name.singularize.camelize
            if class_name == model.model_name.name
              relations[name] ||= []
              relations[name] << klass
              relations[name].uniq!
            end
          end
        end
      end
      @post_updates << {
        ids: ids,
        relations: relations
      }
      ids
    end
    
    def merge_tree model
      ids = merge_simple model
      @post_updates << {
        ids: ids,
        relations: [model]
      }
    end

    def do_post_update
      puts "Post updating..."
      ActiveRecord::Base.establish_connection(@main_database)
      @post_updates.each do |post_update|
        post_update[:ids].each do |old_id, new_id|
          foreign_field = post_update[:foreign_field]
          post_update[:relations].each do |foreign_field, relations|
            relations.each do |relation|
              relation.where("#{foreign_field}_id = #{old_id}").update_all("#{foreign_field}_id = #{new_id}")
            end  if relations
          end
        end
      end
    end

    merge_simple Announcement
    merge_simple Article
    merge_tree User
    merge_tree Company

    do_post_update
  end
end