module ResultObjects
  class Base
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def success?
      false
    end

    def failure?
      false
    end
  end
end
