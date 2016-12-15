module Server
  module La
    class Course < ::Course
      extend Base
      establish_connection db_config
    end
  end
end
