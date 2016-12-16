module Server
  module La
    module Base
      def hostname
        "www.nterone.la"
      end

      def db_config
        YAML::load(ERB.new(File.read(Rails.root.join("config","database.la.yml"))).result)[Rails.env]
      end
    end
  end
end

