module Server
  module Ca
    class Event < ::Event
      extend Base
      establish_connection db_config

      belongs_to :course
    end
  end
end
