module Server
  module Com
    class Event < ::Event
      extend Base
      establish_connection db_config
    end
  end
end
