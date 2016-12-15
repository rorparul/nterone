module Server
  module Com
    module Base
      def hostname
        "www.nterone.com"
      end

      def db_config
        YAML::load(ERB.new(File.read(Rails.root.join("config","database.com.yml"))).result)[Rails.env]
      end
    end
  end
end

