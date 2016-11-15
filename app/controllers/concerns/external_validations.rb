module ExternalValidations
  require 'net/http'

  extend ActiveSupport::Concern

  private

  def validate_experts_exchange
    source_user_id = cookies[:source_user_id]
    source_hash    = cookies[:source_hash]

    response           = Net::HTTP.get_response(URI.parse("https://www.experts-exchange.com/jsp/api.jsp?apiFunc=Course:discount&mid=#{source_user_id}&hash=#{source_hash}"))
    formatted_response = JSON.parse(response.body)

    formatted_response["isSuccess"]
  end
end
