namespace "merge" do
  task :databases, [:database] => [:environment] do |t, args|
    @database = args[:database].to_sym
    @main_database = Rails.env.to_sym
    region = @database.to_s.split('-').last
    Rails.application.config.tld = region

    @origin_region = case region
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
    @ids = {}

    # remove records
    puts "Removing records for region: #{region}..."
    @models.each do |model|
      model.unscoped.where(origin_region: @origin_region).delete_all
    end

    def merge_simple model
      puts "Merging for model: #{model.model_name.name}"

      ActiveRecord::Base.establish_connection(@database)
      records = model.unscoped.all.to_a

      ActiveRecord::Base.establish_connection(@main_database)
      ActiveRecord::Base.connection.execute("ALTER TABLE #{model.table_name} DISABLE TRIGGER ALL")

      ids = {}
      polymorphics = model.reflections.select {|name, r| r.options[:polymorphic] }
      records.each do |rec|
        id = rec.id
        begin
          attributes = rec.attributes.except("id")
          attributes["origin_region"] = @origin_region
          attributes["active_regions"] = [Event.origin_regions.key(@origin_region)]

          # Order
          if model == Order
            attributes["source"] = 10  if attributes["source"] == 0
          end
          
          # User
          if model == User && model.unscoped.exists?(email: attributes["email"])
            ids[id] = model.unscoped.find_by(email: attributes["email"]).id
          else
            new_rec = model.new attributes
            new_rec.save(validate: false)
            ids[id] = new_rec.id
          end

          # Polymorphic
          polymorphics.each do |name, reflection|
            if attributes[name + "_type"]
              @post_updates << {
                model: attributes[name + "_type"].constantize,
                relations: { (name + "_id") => [model] }
              }
            end
          end

        rescue Exception => e
          ap e.message
          ap attributes
          puts e.backtrace.join("\t\n")
        end
      end

      relations = {}
      @models.each do |klass|
        klass.reflections.each do |name, reflection|
          foreign_field = reflection.options[:foreign_key] || name + "_id"
          if reflection.is_a?(ActiveRecord::Reflection::BelongsToReflection)
            unless reflection.options[:polymorphic]
              class_name = reflection.options[:class_name] || reflection.plural_name.singularize.camelize
              if class_name == model.model_name.name
                relations[foreign_field] ||= []
                relations[foreign_field] << klass
                relations[foreign_field].uniq!
              end
            end
          end
        end
      end

      @post_updates << {
        model: model,
        relations: relations
      }
      @ids[model.model_name.name] = ids

      ActiveRecord::Base.connection.execute("ALTER TABLE #{model.table_name} ENABLE TRIGGER ALL")
    end
    
    def do_post_update
      puts "Post updating..."
      ActiveRecord::Base.establish_connection(@main_database)
      @post_updates.each do |post_update|
        post_update[:relations].each do |foreign_field, relations|
          relations.each do |relation|
            @ids[post_update[:model].model_name.name].each do |old_id, new_id|
              relation.where("#{foreign_field} = #{old_id}").update_all("#{foreign_field} = #{new_id}")
            end
          end  if relations
        end
      end
    end

    @models.each do |model|
      merge_simple model
    end

    do_post_update
  end
end