module Checkout
  extend ActiveSupport::Concern

  def process(cart, credit_card_params)
    request                                       = CreateTransactionRequest.new
    request.transactionRequest                    = TransactionRequestType.new
    request.transactionRequest.amount             = @cart.total_price
    request.transactionRequest.payment            = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new(credit_card_params[:credit_card_number],
                                                                       credit_card_params[:expiration_month] +
                                                                       credit_card_params[:expiration_year],
                                                                       credit_card_params[:security_code])
    request.transactionRequest.billTo             = NameAndAddressType.new
    request.transactionRequest.billTo.firstName   = order_params[:billing_first_name]
    request.transactionRequest.billTo.lastName    = order_params[:billing_last_name]
    request.transactionRequest.billTo.address     = order_params[:billing_street]
    request.transactionRequest.billTo.city        = order_params[:billing_city]
    request.transactionRequest.billTo.state       = order_params[:billing_state]
    request.transactionRequest.billTo.zip         = order_params[:billing_zip_code]
    request.transactionRequest.transactionType    = TransactionTypeEnum::AuthCaptureTransaction

    if Rails.env.development?
      transaction = Transaction.new(ENV['anet_api_login_id'], ENV['anet_transaction_id'], gateway: :sandbox)
    elsif Rails.env.production?
      transaction = Transaction.new("6n4RAa4uz", "8DRM235rU88yx5w4", gateway: :production)
    end

    response = transaction.create_transaction(request)
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode})"
    else
      logger.info response.messages.messages[0].text
      logger.info response
      if response && response.transactionResponse && response.transactionResponse.errors && response.transactionResponse.errors.errors[0]
        logger.info response.transactionResponse.errors.errors[0].errorCode
        logger.info response.transactionResponse.errors.errors[0].errorText
      end
      flash[:alert] = "Failed to charge card."
      return redirect_to :back
    end
  end
end
