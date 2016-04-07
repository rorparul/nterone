module ModelSearch
  extend ActiveSupport::Concern

  module ClassMethods
    def search(query)
      query_string = ""
      columns = column_names
      columns.each do |column|
        if [:string, :text].include?(columns_hash[column].type)
          unless column == columns.last
            query_string += "LOWER(#{column}) like :q OR "
          else
            query_string += "LOWER(#{column}) like :q"
          end
        end
      end

      # reflect_on_all_associations.map{ |mac| mac.class_name }.compact.each do |association|
      #   columns = association.constantize.column_names
      #   columns.each do |column|
      #     if [:string, :text].include?(columns_hash[column].type)
      #       unless column == columns.last
      #         query_string += "LOWER(#{column}) like :q OR "
      #       else
      #         query_string += "LOWER(#{column}) like :q"
      #       end
      #     end
      #   end
      # end

      where(query_string, q: "%#{query.downcase}%")
    end
  end
end
