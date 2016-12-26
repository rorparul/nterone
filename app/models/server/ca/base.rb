module Server
  module Ca
    module Base
      def hostname
        "www.nterone.ca"
      end

      def db_config
        YAML::load(ERB.new(File.read(Rails.root.join("config","database.ca.yml"))).result)[Rails.env]
      end
    end
  end
end
