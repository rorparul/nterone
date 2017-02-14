module SmartListingConcerns
  extend ActiveSupport::Concern

  private

  def manage_smart_listing(methods)
    respond_to do |format|
      format.html do
        methods.each do |method|
          symbol = method.to_sym
          self.send(symbol)
        end
      end

      format.js do
        name = params.keys.first.chomp("_smart_listing")
        symbol = "list_#{name}".to_sym
        self.send(symbol)
        @list = name.to_sym
      end
    end
  end
end
