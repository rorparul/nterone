module Server
  module La
    class Course < ::Course
      extend Base
      establish_connection db_config

      belongs_to :platform
    end
  end
end
