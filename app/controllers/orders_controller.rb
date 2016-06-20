class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.order('created_at desc').page(params[:page])
  end

  def new
    if current_user.try(:admin?) || current_user.try(:sales?)
      @order = Order.new
      @user  = params[:user] ? User.find(params[:user]) : nil
      @event = params[:event] ? @order.order_items.build(orderable_type: "Event", orderable_id: params[:event]) : nil
      render "new_admin"
    else
      @order = Order.new
    end
  end

  def create

    if current_user.try(:admin?) || current_user.try(:sales?)
      @order = Order.new(order_params_admin)
      @order.order_items.each do |order_item|
        p "OUTSIDE: #{order_item.inspect}"
        order_item.user_id = @order.buyer_id
      end

      if order_params[:payment_type] == "Credit Card"
        result = handle_credit_card_payment()

        if result.failure?
          flash[:alert] = get_error_msg(result.data) || "Failed to charge card."
          return redirect_to :back
        end
      elsif order_params[:payment_type] == "Cisco Learning Credits"
        @order.assign_attributes(clc_params)
      end

      if @order.save
        @order.confirm_with_partner if confirm_with_partner?
        flash[:success] = "Purchase successfully created."
      else
        flash[:alert] = "Purchase failed to create."
      end

      redirect_to :back
    else
      # Update user information
      current_user.update_attributes(user_params)

      # Create transaction
      @order = current_user.buyer_orders.build
      if order_params[:payment_type] == "Credit Card"
        result = handle_credit_card_payment()

        if result.failure?
          flash[:alert] = "Failed to charge card."
          return redirect_to :back
        end
      elsif order_params[:payment_type] == "Cisco Learning Credits"
        @order.assign_attributes(clc_params)
      end

      # Create order
      @order.assign_attributes(order_params)
      @order.add_order_items_from_cart(@cart)
      if @order.save
        @order.order_items.each do |order_item|
          current_user.order_items << order_item
        end
        flash[:success] = "You've successfully completed your order. Please check your email for a confirmation."
        OrderMailer.confirmation(current_user, @order).deliver_now
        return redirect_to confirmation_orders_path(@order)
      else
        render 'new'
      end
    end
  end

  def show
  end

  def edit
    # @event = Event.find(params[:event])
    @order = Order.find(params[:id])
    render "edit_admin"
  end

  def update
    respond_to do |format|
      if @order.update_attributes(order_params_admin)
        format.html do
          flash[:success] = "Order was successfully updated."
          redirect_to :back
        end
        format.js {  }
      else
        format.html do
          flash[:alert] = "Order failed to update."
          redirect_to :back
        end
        format.js {  }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def confirmation
    @order = Order.find(params[:id])
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def user_params
    params.require(:order).permit(:same_addresses,
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
                                  :shipping_zip_code,
                                  :referring_partner_email)
  end

  def order_params
    params.require(:order).permit(:seller_id,
                                  :buyer_id,
                                  :status,
                                  :payment_type,
                                  :same_addresses,
                                  :billing_company,
                                  :billing_first_name,
                                  :billing_last_name,
                                  :billing_street,
                                  :billing_city,
                                  :billing_state,
                                  :billing_zip_code,
                                  :shipping_company,
                                  :shipping_first_name,
                                  :shipping_last_name,
                                  :shipping_street,
                                  :shipping_city,
                                  :shipping_state,
                                  :shipping_zip_code)
  end

  def cc_params
    params.require(:order).permit(:credit_card_number,
                                  :expiration_month,
                                  :expiration_year,
                                  :security_code,
                                  :paid)
  end

  def clc_params
    params.require(:order).permit(:clc_number,
                                  :clc_quantity)
  end

  def order_params_admin
    params.require(:order).permit(:seller_id,
                                  :buyer_id,
                                  :clc_number,
                                  :clc_quantity,
                                  :payment_type,
                                  :paid,
                                  :po_paid,
                                  :invoice_number,
                                  :reviewed,
                                  :gilmore_order_number,
                                  :gilmore_invoice,
                                  :royalty_id,
                                  :po_number,
                                  :closed_date,
                                  :referring_partner_email,
                                  :same_addresses,
                                  :billing_company,
                                  :billing_first_name,
                                  :billing_last_name,
                                  :billing_street,
                                  :billing_city,
                                  :billing_state,
                                  :billing_zip_code,
                                  :shipping_company,
                                  :shipping_first_name,
                                  :shipping_last_name,
                                  :shipping_street,
                                  :shipping_city,
                                  :shipping_state,
                                  :shipping_zip_code,
                                  order_items_attributes: [:id,
                                                           :user_id,
                                                           :orderable_id,
                                                           :orderable_type,
                                                           :price,
                                                           :_destroy])
  end

  def handle_credit_card_payment
    payment_result = Payment::CreateService.new(order_params, cc_params).call
    response = payment_result.data

    if payment_result.success?
      puts "Successful charge (auth + capture) (authorization code: #{response[:auth_code]})"

      @order.auth_code = response[:auth_code]
      @order.paid = response[:amount]

      return ResultObjects::Success.new(response)
    else
      log_payment_error(response)
      return ResultObjects::Failure.new(response)
    end
  end

  def log_payment_error(response)
    transaction_res = response.transactionResponse
    should_log = response && transaction_res && transaction_res.errors && first_error

    return unless should_log

    first_error = transaction_res.errors.errors[0]

    logger.info response.messages.messages[0].text
    logger.info response

    logger.info first_error.errorCode
    logger.info first_error.errorText
  end

  def get_error_msg(response)
    transaction_res = response.transactionResponse
    error_exists = response && transaction_res && transaction_res.errors && first_error

    error_exists ? transaction_res.errors.errors[0].errorText : nil
  end

  def confirm_with_partner?
    params[:confirm_with_partner] == 'true'
  end
end
