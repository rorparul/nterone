module ResultObjects
  class Failure < ResultObjects::Base
    def initialize(data)
      super(data)
    end

    def failure?
      true
    end
  end
end
