namespace "staging" do
  task "db_clone" => :environment do
    if Settings.stage == 'staging'
      logger = Logger.new(Rails.root.join('log', 'backup.log'))
      logger.level = Logger::INFO
      logger.info("----- DB clone starting")

      dbconfig = YAML::load(ERB.new(IO.read(Rails.root.join('config', 'database.yml'))).result)[Rails.env]

      begin
        # S3 client
        creds = Aws::Credentials.new(Setting.aws_s3_access_key_id, Setting.aws_s3_secret_access_key)
        Aws.config.update({
          credentials: creds,
          region: Setting.aws_s3_region,
          logger: logger
        })
        s3 = Aws::S3::Client.new

        files = s3.list_objects(bucket: Setting.aws_s3_bucket, prefix: "#{Setting.aws_s3_path}/").contents
        if files.size > 0
          last_backup = files.sort {|x,y| y.last_modified <=> x.last_modified }[0]
          backup_path = Rails.root.join('tmp', last_backup.key.split('/')[-1])
          File.open(backup_path, 'wb') do |file|
            s3.get_object(bucket: Setting.aws_s3_bucket, key: last_backup.key) do |chunk|
              file.write(chunk)
            end
          end

          dump_full_path = Rails.root.join('tmp', 'database.sql')
          logger.info `cd #{Rails.root.join('tmp')} && tar -xaf #{backup_path}`

          if File.exists? dump_full_path
            # drop database
            mappings = {host: :host, port: :port, user: :username}
            params = dbconfig
              .select {|c| mappings.keys.include? c.to_sym }
              .map {|k, v| "--#{mappings[k.to_sym]}=#{v}" }
              .join(" ")
            logger.info `PGPASSWORD=#{dbconfig["password"]} dropdb #{params} #{dbconfig["database"]} 2>&1`

            # create database
            logger.info `PGPASSWORD=#{dbconfig["password"]} createdb #{params} #{dbconfig["database"]} 2>&1`

            # restore database
            mappings = {database: :dbname, host: :host, port: :port, user: :username}
            params = dbconfig
              .select {|c| mappings.keys.include? c.to_sym }
              .map {|k, v| "--#{mappings[k.to_sym]}=#{v}" }
              .join(" ")
            logger.debug `PGPASSWORD=#{dbconfig["password"]} psql #{params} < #{dump_full_path}`
            logger.info("Database restored.")

          else
            logger.fatal("File #{dump_full_path} doesn't exist.")
          end
        end
      rescue
        logger.fatal("Caught exception; exiting")
        logger.fatal(err)
      end
      logger.info("----- DB clone finished.")
    end
  end
end
