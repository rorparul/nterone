class Db::MergeService

  attr_accessor :post_updates

  def initialize database
    @database      = database.to_sym
    @main_database = Rails.env.to_sym

    @post_updates  = {}
    @ids           = {}
    @polymorphics  = {}

    init_origin_region

    init_models
  end

  def call
    @models = [User, Role, Event, VideoOnDemand, OrderItem, Registration]  if Rails.env.development?
    @models.each do |model|
      merge_model model
    end

    post_update

    rebuild_all_indexes
    remove_extra_roles
  end

  def init_origin_region
    ActiveRecord::Base.establish_connection(@main_database)
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

    # set origin_region to US by default

    ActiveRecord::Base.connection.tables.each do |table|
      begin
        klass = table.singularize.camelize.constantize
      rescue => exception
      else
        if klass.respond_to? :origin_regions
          # set active_regions
          if klass.column_names.include?("active_regions")
            klass
              .unscoped
              .where("active_regions = ? or active_regions = ?", '{}', '{""}')
              .update_all("active_regions": "{#{klass.origin_regions.key(0)}}")
          end
          # set origin_region
          if klass.column_names.include?("origin_region")
            klass
              .unscoped
              .where("origin_region is null")
              .update_all("origin_region": 0)
          end
        end
      end
    end
  end

  def init_models
    ActiveRecord::Base.establish_connection(@main_database)
    all_tables = ActiveRecord::Base.connection.tables.to_a

    @models = []
    @old_counts = {}
    all_tables.each do |table|
      begin
        klass = table.singularize.camelize.constantize
        @models << klass
        @old_counts[klass.name] = klass.unscoped.count
      rescue => exception
      end
    end
  end

  def merge_post_updates model_name, relations
    @post_updates[model_name] ||= {}
    @post_updates[model_name] =
      @post_updates[model_name].deep_merge(relations) {|key, this_val, other_val| (this_val + other_val).uniq }
  end

  def merge_model model
    page_size = 10000
    page = 0
    relations = {}
    ids = {}

    begin
      ActiveRecord::Base.establish_connection(@database)
      total_count = model.unscoped.count
    rescue Exception => e
      total_count = 0
    end

    # BREAK
    return  if total_count == 0

    ActiveRecord::Base.establish_connection(@main_database)
    ActiveRecord::Base.connection.execute("ALTER TABLE #{model.table_name} DISABLE TRIGGER ALL")

    if model == User
      user_emails = User.all.inject({}) {|h, u| h[u.email] = u.id; h }
    end

    while true do

      records = []
      old_ids = []

      ActiveRecord::Base.establish_connection(@database)
      records = model.unscoped.order(:id).offset(page * page_size).limit(page_size).to_a.map {|r| r.attributes }
      GC.start

      # BREAK
      break  if records.size == 0

      ActiveRecord::Base.establish_connection(@main_database)

      # Order
      if model == Order
        records.map! do |attributes|
          attributes["source"] = 10  if attributes["source"] == 0
        end
      end

      # User
      if model == User
        records.select! do |attributes|
          if user_emails[attributes["email"]]
            ids[attributes["id"]] = user_emails[attributes["email"]]
            false
          else
            true
          end
        end
      end

      # sorting
      records.sort! do |a, b|
        a["id"].to_i <=> b["id"].to_i
      end

      # extract id
      records.map! do |attributes|
        old_ids << attributes.delete("id")
        attributes["origin_region"]  = @origin_region
        attributes["active_regions"] = [Event.origin_regions.key(@origin_region)]
      end

      unless Rails.env.test?
        print "%20s: %10d / %10d, old count: %10d \r" % [model.name, page*page_size, total_count, @old_counts[model.name].to_i]
      end

      begin
        result = model.import records, validate: false

        if result.num_inserts == records.size
          result.ids.each_with_index do |id, i|
            ids[old_ids[i]] = id
          end
        else
          raise "Error inserting: "
          p attributes
        end
      rescue Exception => e
        puts e.backtrace.join("\t\n")
        p model.name
        p attributes
      end

      @models.each do |klass|

        klass.reflections.each do |name, reflection|

          foreign_field = reflection.options[:foreign_key] || name + "_id"
          if reflection.is_a?(ActiveRecord::Reflection::BelongsToReflection)

            unless reflection.options[:polymorphic]

              class_name = reflection.options[:class_name] || reflection.plural_name.singularize.camelize
              if class_name == model.name

                relations[foreign_field] ||= []
                relations[foreign_field] << klass.name
                relations[foreign_field].uniq!

              end
            end
          end
        end
      end

      page += 1

    end

    puts  unless Rails.env.test?

    ActiveRecord::Base.establish_connection(@main_database)
    ActiveRecord::Base.connection.execute("ALTER TABLE #{model.table_name} ENABLE TRIGGER ALL")

    if relations.any?
      merge_post_updates model.name, relations
    end

    @ids[model.name] = ids
  end

  def post_update
    puts "Post updating..."  unless Rails.env.test?
    ActiveRecord::Base.establish_connection(@main_database)

    p @post_updates  unless Rails.env.test?

    i = 0
    total = post_updates_size

    @post_updates.each do |model_name, relations|

      relations.each do |foreign_field, relation_model_names|

        relation_model_names.each do |relation_model_name|
          relation = relation_model_name.constantize
          index_name = "merge_tmp_index_" + relation_model_name + foreign_field
          begin
            ActiveRecord::Base.connection.execute("CREATE INDEX #{index_name} ON #{model.table_name} #{foreign_field}")
          rescue
          end

          @ids[model_name].each do |pair|

            old_id, new_id = pair
            relation
              .unscoped
              .where("#{foreign_field} = #{old_id}")
              .update_all("#{foreign_field} = #{new_id}")

            unless Rails.env.test?
              i += 1
              print "#{model_name}:#{foreign_field}:#{relation_model_name} #{i} / #{total}\r"
            end

            begin
              ActiveRecord::Base.connection.execute("DROP INDEX #{index_name}")
            rescue
            end

          end
        end
      end
    end
    puts  unless Rails.env.test?

    puts "Update polymorphics..." unless Rails.env.test?

    @models.each do |model|
      polymorphics = model.reflections.select {|name, r| r.options[:polymorphic] }

      polymorphics.each do |name, reflection|
        model.unscoped.group(name + "_type").count.each do |relation_name, count|
          foreign_field = name + "_id"
          @ids[relation_name].each do |pair|
            old_id, new_id = pair
            model
              .unscoped
              .where("#{name + '_type'} = '#{relation_name}' and #{foreign_field} = #{old_id}")
              .update_all("#{foreign_field} = #{new_id}")
          end  if @ids[relation_name]
        end
      end

    end
  end

  def rebuild_all_indexes
    ActiveRecord::Base.establish_connection(@main_database)
    @models.each do |model|
      ActiveRecord::Base.connection.execute("REINDEX TABLE #{model.table_name}")
    end
  end

  def remove_extra_roles
    ActiveRecord::Base.establish_connection(@main_database)
    User.unscoped.all.each do |user|
      roles = user.roles.map(&:role).uniq
      user.roles.delete_all
      roles.each do |role|
        user.roles.create(role: role, origin_region: user.origin_region)
      end
    end
  end

  def post_updates_size
    size = 0
    @post_updates.each do |model_name, relations|
      relations.each do |foreign_field, relation_model_names|
        relation_model_names.each do |relation_model_name|
          size += @ids[model_name].size
        end
      end
    end

    size
  end
end
