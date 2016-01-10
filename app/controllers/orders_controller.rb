class OrdersController < ApplicationController
  include AuthorizeNet::API

  # skip_before_action :authorize, only: [:new, :create]
  # before_action :set_cart,  only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.order('created_at desc').page(params[:page])
  end

  def show
  end

  def new
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty"
      return
    end

    @order = Order.new
  end

  def edit
  end

  def create
    if user_signed_in?
      @order                                        = current_user.orders.build
      transaction                                   = Transaction.new(ENV['anet_api_login_id'], ENV['anet_transaction_id'], :gateway => :sandbox)
      request                                       = CreateTransactionRequest.new
      request.transactionRequest                    = TransactionRequestType.new()
      request.transactionRequest.amount             = @cart.total_price
      request.transactionRequest.payment            = PaymentType.new
      request.transactionRequest.payment.creditCard = CreditCardType.new(order_params[:credit_card_number],
                                                                         order_params[:expiration_month] + order_params[:expiration_year],
                                                                         order_params[:security_code])
      request.transactionRequest.transactionType    = TransactionTypeEnum::AuthCaptureTransaction
      response = transaction.create_transaction(request)
      logger.info response.messages.resultCode
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode})"
        @order.auth_code = response.transactionResponse.authCode
        @order.add_order_items_from_cart(@cart)
        @order.order_items.each do |order_item|
          current_user.order_items << order_item
        end
        if @order.save
          flash[:success] = "You've successfully completed your order. Please check your email for a confirmation."
          OrderMailer.confirmation(current_user, @order).deliver_now
          redirect_to confirmation_orders_path(@order)
        else
          puts "Failed to create order: #{@order.errors.full_messages}"
          flash[:alert] = "Card charged successfully, but order failed to create. Please contact customer service."
          redirect_to :back
        end
      else
        logger.info response.messages.messages[0].text
        # puts response.transactionResponse.errors.errors[0].errorCode
        # puts response.transactionResponse.errors.errors[0].errorText
        # raise "Failed to charge card."
        flash[:alert] = 'Failed to charge card.'
        redirect_to :back
      end
    else
      flash[:alert] = "Please #{view_context.link_to('create an account',
                      new_user_registration_path)} before placing your order.".html_safe
      redirect_to :back
    end
  end

  def confirmation
    @order = Order.find(params[:id])
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:credit_card_number,
                                  :expiration_month,
                                  :expiration_year,
                                  :security_code,
                                  :clc_number,
                                  :clc_quantity)
  end
end
