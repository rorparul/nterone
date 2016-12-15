module Server
  module Com
    class Platform < ::Platform
      extend Base
      establish_connection db_config

      has_many :courses
      has_many :events, through: :courses
    end
  end
end
