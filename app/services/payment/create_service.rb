class Payment::CreateService
  include AuthorizeNet::API

  PROD_API_LOGIN = '6n4RAa4uz'
  PROD_API_KEY = '8DRM235rU88yx5w4'

  DEV_API_LOGIN = ENV['anet_api_login_id']
  DEV_API_KEY = ENV['anet_transaction_id']

  def initialize(order_params, cc_params)
    @order_params = order_params
    @cc_params = cc_params
  end

  def call
    request = CreateTransactionRequest.new

    set_basic_data(request)
    set_payment(request)
    set_billing_address(request)

    response = create_transaction(request)

    if successfull_response?(response)
      ResultObjects::Success.new(response_data(request, response))
    else
      log_payment_error(response)
      ResultObjects::Failure.new(response)
    end
  end

  private

  def set_basic_data(request)
    request.transactionRequest = TransactionRequestType.new
    request.transactionRequest.amount = @cc_params[:paid]
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
  end

  def set_payment(request)
    credit_card = CreditCardType.new(
      @cc_params[:credit_card_number].gsub(' ', ''),
      exparation_date,
      @cc_params[:security_code]
    )

    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = credit_card
  end

  def set_billing_address(request)
    request.transactionRequest.billTo = NameAndAddressType.new
    request.transactionRequest.billTo.firstName = @order_params[:billing_first_name]
    request.transactionRequest.billTo.lastName = @order_params[:billing_last_name]
    request.transactionRequest.billTo.address = @order_params[:billing_street]
    request.transactionRequest.billTo.city = @order_params[:billing_city]
    request.transactionRequest.billTo.state = @order_params[:billing_state]
    request.transactionRequest.billTo.zip = @order_params[:billing_zip_code]
  end

  def create_transaction(request)
    if Rails.env.development? || Rails.env.test?
      Transaction.new(DEV_API_LOGIN, DEV_API_KEY, gateway: :sandbox).create_transaction(request)
    elsif Rails.env.production?
      Transaction.new(PROD_API_LOGIN, PROD_API_KEY, gateway: :production).create_transaction(request)
    end
  end

  def successfull_response?(response)
    response.messages.resultCode == MessageTypeEnum::Ok
  end

  def exparation_date
    @cc_params[:expiration_month] + @cc_params[:expiration_year]
  end

  def response_data(request, response)
    {
      auth_code: response.transactionResponse.authCode,
      amount: request.transactionRequest.amount
    }
  end

  def log_payment_error(response)
    if response.try(:transactionResponse).try(:errors).try(:errors).try(:first)
      Rails.logger.info response.messages.messages[0].text
      Rails.logger.info response

      first_error = response.transactionResponse.errors.errors[0]
      Rails.logger.info first_error.errorCode
      Rails.logger.info first_error.errorText
    end
  end
end
