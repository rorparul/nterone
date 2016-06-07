module ResultObjects
  class Success < ResultObjects::Base
    def initialize(data)
      super(data)
    end

    def success?
      true
    end
  end
end
