class Db::RestoreImagesService

  def initialize database, uploads_path
    @database      = database.to_sym
    @uploads_path  = uploads_path

    @main_database = Rails.env.to_sym

    @region = @database.to_s.split('-').last
    Rails.application.config.tld = @region
    regions = { com: 0, la: 1, ca: 2 }
    @origin_region = regions[@region.to_sym] || 0
  end

  def call
    Image.unscoped.group("imageable_type").count.values.each do |model_name|
      ActiveRecord::Base.establish_connection @main_database
      p model_name
      begin
        model = model_name.constantize
      rescue => exception
      else
        titles = {}

        if model.try(:first).try(:image)
          ActiveRecord::Base.establish_connection @database
          model.unscoped.all.each do |object|
            titles[object.title] = object.image  if object.image.present?
          end

          ActiveRecord::Base.establish_connection @main_database
          model.unscoped.where(origin_region: @origin_region).each do |object|
            image = titles[object.title]
            if image.try(:file).try(:file).try(:path)
              filename = "#{@uploads_path}" + image.file.file.path.gsub(/^production/, "")
              if File.exists? filename
                object.image = Image.new  unless object.image.present?
                object.image.file = File.open(filename)
                object.image.save
              end
            end
          end
        end
      end
    end
  end

end
