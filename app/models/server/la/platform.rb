module Server
  module La
    class Platform < ::Platform
      extend Base
      establish_connection db_config
    end
  end
end
