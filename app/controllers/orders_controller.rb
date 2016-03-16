class OrdersController < ApplicationController
  include AuthorizeNet::API

  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.order('created_at desc').page(params[:page])
  end

  def show
  end

  def new
    if current_user.try(:admin?)
      @order            = Order.new
      @order.order_items.build
      @user             = User.find(params[:user_id])
      @video_on_demands = VideoOnDemand.order(:title)
    end
  end

  def edit
  end

  def create
    unless user_signed_in?
      @user = User.find_by_email(user_params[:email])
      if @user && @user.valid_password?(user_params[:password])
        sign_in(@user)
      else
        @user = User.new(user_params)
        @user.skip_confirmation!
        @user.save
        Role.create(user_id: @user.id)
        sign_in(@user)
      end
    end

    if current_user.try(:admin?)
      @order = Order.new(staff_order_params)
      if @order.save
        flash[:success] = "Purchase successfully created."
      else
        flash[:alert] = "Purchase failed to create."
      end
      redirect_to :back
    else
      @order                                        = current_user.buyer_orders.build
      request                                       = CreateTransactionRequest.new
      request.transactionRequest                    = TransactionRequestType.new
      request.transactionRequest.amount             = @cart.total_price_after_credits(order_params[:clc_quantity])
      request.transactionRequest.payment            = PaymentType.new
      request.transactionRequest.payment.creditCard = CreditCardType.new(credit_card_params[:credit_card_number],
                                                                         credit_card_params[:expiration_month] +
                                                                         credit_card_params[:expiration_year],
                                                                         credit_card_params[:security_code])
      request.transactionRequest.transactionType    = TransactionTypeEnum::AuthCaptureTransaction

      transaction = Transaction.new(ENV['anet_api_login_id'], ENV['anet_transaction_id'], :gateway => :sandbox)
      response    = transaction.create_transaction(request)

      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode})"
        @order.assign_attributes(order_params)
        @order.auth_code = response.transactionResponse.authCode
        @order.paid      = request.transactionRequest.amount
        @order.add_order_items_from_cart(@cart)
        if @order.save
          @order.order_items.each do |order_item|
            current_user.order_items << order_item
          end
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
    end
  end

  def confirmation
    @order = Order.find(params[:id])
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html do
          flash[:success] = 'Order was successfully updated.'
          redirect_to :back
        end
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

  def user_params
    params.require(:order).permit(:email,
                                  :password,
                                  :password_confirmation,
                                  :first_name,
                                  :last_name,
                                  :same_addresses,
                                  :billing_first_name,
                                  :billing_last_name,
                                  :billing_street,
                                  :billing_city,
                                  :billing_state,
                                  :billing_zip_code,
                                  :shipping_first_name,
                                  :shipping_last_name,
                                  :shipping_street,
                                  :shipping_city,
                                  :shipping_state,
                                  :shipping_zip_code)
  end

  def order_params
    params.require(:order).permit(:seller_id,
                                  :buyer_id,
                                  :auth_code,
                                  :clc_number,
                                  :clc_quantity,
                                  :paid,
                                  :billing_first_name,
                                  :billing_last_name,
                                  :billing_street,
                                  :billing_city,
                                  :billing_state,
                                  :billing_zip_code,
                                  :shipping_first_name,
                                  :shipping_last_name,
                                  :shipping_street,
                                  :shipping_city,
                                  :shipping_state,
                                  :shipping_zip_code)
  end

  def credit_card_params
    params.require(:order).permit(:credit_card_number,
                                  :expiration_month,
                                  :expiration_year,
                                  :security_code)
  end

  def staff_order_params
    params.require(:order).permit(:seller_id,
                                  :buyer_id,
                                  :clc_number,
                                  :clc_quantity,
                                  :payment_type,
                                  :paid,
                                  order_items_attributes: [:id,
                                                           :user_id,
                                                           :orderable_id,
                                                           :orderable_type])
  end
end

# create_table "orders", force: :cascade do |t|
#   t.datetime "created_at",                                                       null: false
#   t.datetime "updated_at",                                                       null: false
#   t.string   "auth_code"
#   t.string   "first_name"
#   t.string   "last_name"
#   t.string   "shipping_street"
#   t.string   "shipping_city"
#   t.string   "shipping_state"
#   t.string   "shipping_zip_code"
#   t.string   "shipping_country"
#   t.string   "email"
#   t.string   "clc_number"
#   t.string   "billing_name"
#   t.string   "billing_zip_code"
#   t.decimal  "paid",              precision: 8, scale: 2, default: 0.0
#   t.string   "billing_street"
#   t.string   "billing_city"
#   t.string   "billing_state"
#   t.integer  "seller_id"
#   t.integer  "buyer_id"
#   t.string   "status",                                    default: "Uninvoiced"
#   t.decimal  "total",             precision: 8, scale: 2, default: 0.0
#   t.string   "billing_country"
#   t.string   "payment_type"
#   t.integer  "clc_quantity",                              default: 0
# end

# create_table "users", force: :cascade do |t|
#   t.string   "email",                  default: "",               null: false
#   t.string   "encrypted_password",     default: "",               null: false
#   t.string   "reset_password_token"
#   t.datetime "reset_password_sent_at"
#   t.datetime "remember_created_at"
#   t.integer  "sign_in_count",          default: 0,                null: false
#   t.datetime "current_sign_in_at"
#   t.datetime "last_sign_in_at"
#   t.inet     "current_sign_in_ip"
#   t.inet     "last_sign_in_ip"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "company_name"
#   t.string   "first_name"
#   t.string   "last_name"
#   t.string   "contact_number"
#   t.string   "country"
#   t.string   "website"
#   t.string   "street"
#   t.string   "city"
#   t.string   "state"
#   t.string   "zipcode"
#   t.boolean  "archived",               default: false
#   t.string   "confirmation_token"
#   t.datetime "confirmed_at"
#   t.datetime "confirmation_sent_at"
#   t.string   "unconfirmed_email"
#   t.string   "invitation_token"
#   t.datetime "invitation_created_at"
#   t.datetime "invitation_sent_at"
#   t.datetime "invitation_accepted_at"
#   t.integer  "invitation_limit"
#   t.integer  "invited_by_id"
#   t.string   "invited_by_type"
#   t.integer  "invitations_count",      default: 0
#   t.datetime "last_active_at"
#   t.string   "billing_street"
#   t.string   "billing_city"
#   t.string   "billing_state"
#   t.string   "billing_zip_code"
#   t.boolean  "same_addresses",         default: false
#   t.boolean  "forem_admin",            default: false
#   t.string   "forem_state",            default: "pending_review"
#   t.boolean  "forem_auto_subscribe",   default: false
#   t.string   "billing_first_name"
#   t.string   "billing_last_name"
# end
