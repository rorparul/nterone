module Server
  module Com
    class Course < ::Course
      extend Base
      establish_connection db_config
    end
  end
end
