module Checkout
  extend ActiveSupport::Concern
  include AuthorizeNet::API

  def process_credit_card(cart, credit_card_params, order_params)
    request                                       = CreateTransactionRequest.new
    request.transactionRequest                    = TransactionRequestType.new
    request.transactionRequest.amount             = cc_params[:paid]
    request.transactionRequest.payment            = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new(cc_params[:credit_card_number],
                                                                       cc_params[:expiration_month] +
                                                                       cc_params[:expiration_year],
                                                                       cc_params[:security_code])
    request.transactionRequest.billTo             = NameAndAddressType.new
    request.transactionRequest.billTo.firstName   = order_params[:billing_first_name]
    request.transactionRequest.billTo.lastName    = order_params[:billing_last_name]
    request.transactionRequest.billTo.address     = order_params[:billing_street]
    request.transactionRequest.billTo.city        = order_params[:billing_city]
    request.transactionRequest.billTo.state       = order_params[:billing_state]
    request.transactionRequest.billTo.zip         = order_params[:billing_zip_code]
    request.transactionRequest.transactionType    = TransactionTypeEnum::AuthCaptureTransaction

    if Rails.env.production?
      transaction = Transaction.new("6n4RAa4uz", "8DRM235rU88yx5w4", gateway: :production)
    else
      transaction = Transaction.new(ENV['anet_api_login_id'], ENV['anet_transaction_id'], gateway: :sandbox)
    end

    response = transaction.create_transaction(request)
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode})"
      # @order.auth_code = response.transactionResponse.authCode
      # @order.paid      = request.transactionRequest.amount
      {auth_code: response.transactionResponse.authCode, paid: request.transactionRequest.amount}
    else
      logger.info response.messages.messages[0].text
      if Rails.env.production?
        logger.info response.transactionResponse.errors.errors[0].errorCode
        logger.info response.transactionResponse.errors.errors[0].errorText
      end
      false
    end
  end
end
