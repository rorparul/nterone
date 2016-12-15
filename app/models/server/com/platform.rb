module Server
  module Com
    class Platform < ::Platform
      extend Base
      establish_connection db_config
    end
  end
end
