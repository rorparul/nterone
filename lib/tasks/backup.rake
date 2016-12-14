namespace "backup" do
  task "db" => :environment do
    hostname = `hostname`

    logger = Logger.new(Rails.root.join('log', 'backup.log'))
    logger.level = Logger::INFO
    logger.info("----- DB backup starting")

    start_time = Time.now

    dbconfig = YAML::load(ERB.new(IO.read(Rails.root.join('config', 'database.yml'))).result)[Rails.env]
    mappings = {database: :dbname, host: :host, port: :port, user: :username, username: :username}
    params = dbconfig
      .select {|c| mappings.keys.include? c.to_sym }
      .map {|k, v| "--#{mappings[k.to_sym]}=#{v}" }
      .join(" ")

    dump_path    = 'database.sql'
    dump_full_path = Rails.root.join('tmp', dump_path)
    archive_file_name = "db-#{dbconfig["database"]}-#{start_time.to_s(:db).gsub(/[-\s:]/, '')}.tar.bz2"
    backup_path  = Rails.root.join('tmp', archive_file_name)
    s3_path      = "#{hostname}/#{archive_file_name}"

    FileUtils.rm dump_full_path  if File.exists? dump_full_path
    FileUtils.rm backup_path  if File.exists? backup_path

    begin
      system "PGPASSWORD=#{dbconfig["password"]} pg_dump #{params} > #{dump_full_path}"

      if File.exists? dump_full_path
        logger.info("Database dump created.")

        system "cd #{Rails.root.join('tmp')} && tar -caf #{backup_path} #{dump_path}"

        if File.exists? backup_path
          logger.info("Archive file created.")

          # S3 client
          creds = Aws::Credentials.new(Setting.aws_s3_access_key_id, Setting.aws_s3_secret_access_key)
          Aws.config.update({
            credentials: creds,
            region: Setting.aws_s3_region,
            logger: logger
          })
          s3 = Aws::S3::Client.new

          # save backup
          s3.put_object(
            acl: 'private',
            bucket: Setting.aws_s3_bucket,
            body: File.open(backup_path),
            key: s3_path
          )
          logger.info("Archive file stored to AWS S3.")

          # remove old files
          files = s3.list_objects(bucket: Setting.aws_s3_bucket, prefix: "#{Setting.aws_s3_path}/").contents
          files = files.sort {|x,y| y.last_modified <=> x.last_modified }[Setting.aws_s3_files_keep..-1]
          if files
            files.each do |file|
              s3.delete_object(
                bucket: Setting.aws_s3_bucket,
                key: file.key
              )
            end
          end
          logger.info("Old archives deleted.")

        else
          logger.fatal("File #{backup_path} doesn't exist.")
        end

      else
        logger.fatal("File #{dump_full_path} doesn't exist.")
      end

    rescue => err
      logger.fatal("Caught exception; exiting")
      logger.fatal(err)
    end

    # remove all files
    FileUtils.rm dump_full_path  if File.exists? dump_full_path
    FileUtils.rm backup_path  if File.exists? backup_path

    logger.info("----- DB backup finished.")
  end
end

