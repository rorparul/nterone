class OrdersController < ApplicationController
  include DiscountApplicator

  before_action :authenticate_user!, except: [:new, :create, :confirmation]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token, only: :exact_create

  def index
    @orders = Order.order('created_at desc').page(params[:page])
  end

  def new
    @order = Order.new

    if current_user.try(:admin?) || current_user.try(:sales?)
      @user  = params[:user] ? User.find(params[:user]) : nil
      @event = params[:event] ? @order.order_items.build(orderable_type: "Event", orderable_id: params[:event]) : nil

      return render 'new_admin'
    end

    if TopLevelDomain == 'ca' && params[:form] != 'default'
      @x_amount        = view_context.number_with_precision(@cart.total_price, precision: 2)
      @x_login         = 'WSP-NTERO-QyTV6QATZA'
      @transaction_key = 'L2Q9MfxD9GtkthkT7cs~'
      @x_currency_code = 'CAD'
      @x_fp_sequence   = ((rand*100000).to_i + 2000).to_s
      @x_fp_timestamp  = Time.now.to_i.to_s
      @hmac_data       = "#{@x_login}^#{@x_fp_sequence}^#{@x_fp_timestamp}^#{@x_amount}^#{@x_currency_code}"
      @x_fp_hash       = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('md5'), @transaction_key, @hmac_data)

      return render 'new_for_ca'
    end
  end

  def create
    if current_user.try(:employee?)
      # Create order
      #
      @order = Order.new(permitted_params.order_admin)
      @order.order_items.each do |order_item|
        order_item.user_id = @order.buyer_id
      end

      payment_type = permitted_params.order[:payment_type]
      if payment_type == "Credit Card"
        result = handle_credit_card_payment()

        if result.failure?
          @order.errors[:base] << get_error_msg(result.data)

          return render 'create_admin'
        end

      elsif payment_type == "Cisco Learning Credits"
        @order.assign_attributes(permitted_params.cisco_learning_credits)

      end

      if @order.save
        @order.confirm_with_rep if confirm_with_rep?

        flash[:success] = "Purchase successfully created."

        render js: "window.location = '#{request.referrer}';"
      else
        return render 'create_admin'
      end

      # redirect_to :back

    elsif user_signed_in?

      unless valid_input_values?
        flash[:alert] = "Order submission failed. Form was tampered with."
        return redirect_to :back
      end

      # Update user information
      #
      current_user.update_attributes(permitted_params.user)

      # Create order
      #
      @order = current_user.buyer_orders.build(permitted_params.order)
      @order.add_order_items_from_cart(@cart)

      # Create transaction
      #
      if permitted_params.order[:payment_type] == "Credit Card"
        result = handle_credit_card_payment()

        Rails.logger.info result.inspect

        if result.failure?
          flash[:alert] = "Failed to charge card."
          return redirect_to :back
        end
      elsif permitted_params.order[:payment_type] == "Cisco Learning Credits"
        @order.assign_attributes(permitted_params.cisco_learning_credits)
      end

      # Save order
      #
      if @order.save
        @order.order_items.each do |order_item|
          current_user.order_items << order_item
          pod_order = order_item.orderable_type == 'LabRental' && order_item.orderable.level == 'individual'
        end

        flash[:success] = t(".success")

        OrderMailer.confirmation(current_user, @order).deliver_now
        OrderMailer.lab_rental_notification(current_user, order_pods).deliver_now if order_pods.any?

        return redirect_to confirmation_orders_path(@order)

      else
        render 'new'

      end

    # Guest
    #

    else

      unless valid_input_values?
        flash[:alert] = "Order submission failed. Form was tampered with."
        return redirect_to :back
      end

      @guest = Guest.create(permitted_params.guest)

      # Create transaction
      @order = Order.new
      if permitted_params.order[:payment_type] == "Credit Card"
        result = handle_credit_card_payment()

        if result.failure?
          flash[:alert] = "Failed to charge card."
          return redirect_to :back
        end
      elsif permitted_params.order[:payment_type] == "Cisco Learning Credits"
        @order.assign_attributes(permitted_params.cisco_learning_credits)
      end

      # Create order
      @order.assign_attributes(permitted_params.order)
      @order.add_order_items_from_cart(@cart)
      if @order.save
        @order.order_items.each do |order_item|
          pod_order = true if order_item.orderable_type == 'LabRental' && order_item.orderable.level == 'individual'
        end
        flash[:success] = t(".success")
        OrderMailer.confirmation(@guest, @order).deliver_now
        # OrderMailer.lab_rental_notification(current_user, order_pods).deliver_now if order_pods.any?
        return redirect_to confirmation_orders_path(@order)
      else
        render 'new'
      end
    end
  end

  def show
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    if @order.update_attributes(permitted_params.order_admin)
      if params[:order].keys.count > 1
        flash[:success] = "Order was successfully updated."
        render js: "window.location = '#{request.referrer}';"
      else
        # render json: { success: true }
        render "layouts/async_status"
      end
    else
      if params[:order].keys.count > 1
        render 'edit_admin'
      else
        render json: { success: false }
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
    return redirect_to root_path unless current_user && current_user.buyer_orders.pluck(:id).include?(@order.id)
  end

  def exact_create
    if params[:x_response_code] == '1'
      @order = current_user.buyer_orders.build
      @order.assign_attributes(payment_type: 'Credit Card', paid: params[:x_amount], origin_region: params[:origin_region])
      @order.add_order_items_from_cart(@cart)
      if @order.save
        @order.order_items.each do |order_item|
          current_user.order_items << order_item
          pod_order = order_item.orderable_type == 'LabRental' && order_item.orderable.level == 'individual'
        end
        flash[:success] = 'You\'ve successfully completed your order. Please check your email for a confirmation.'
        OrderMailer.confirmation(current_user, @order).deliver_now
        OrderMailer.lab_rental_notification(current_user, order_pods).deliver_now if order_pods.any?
        return redirect_to confirmation_orders_path(@order)
      else
        render 'new'
      end
    elsif params[:x_response_code] == '2'
      flash[:alert] = 'Your payment was declined.'
      return redirect_to new_order_path
    elsif params[:x_response_code] == '3'
      flash[:alert] = 'There was an error during the payment process.'
      return redirect_to new_order_path
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def valid_input_values?
    # TODO: Review mothod's accuracy as it relates to the clc evaluation

    price = nil

    if permitted_params.order[:discount_id].present?
      discount = Discount.find(permitted_params.order[:discount_id])
      discount = discount.try(:active_and_within_bounds?) ? discount : nil

      price = discounted_total(@cart, discount) if discount
      price ||= @cart.total_price
    else
      price = @cart.total_price
    end

    price.to_s == permitted_params.credit_card[:paid] || @cart.credits_required_for_total_applicable_for_credits.to_s == permitted_params.cisco_learning_credits[:clc_quantity]
  end

  def handle_credit_card_payment
    payment_result = Payment::CreateService.new(permitted_params.order, permitted_params.credit_card).call
    response = payment_result.data

    if payment_result.success?
      puts "Successful charge (auth + capture) (authorization code: #{response[:auth_code]})"

      @order.auth_code = response[:auth_code]
      @order.paid = response[:amount]

      return ResultObjects::Success.new(response)
    else
      return ResultObjects::Failure.new(response)
    end
  end

  def get_error_msg(response)
    transaction_res = response.transactionResponse
    error_exists = response && transaction_res && transaction_res.errors && transaction_res.errors.errors[0]

    error = error_exists ? transaction_res.errors.errors[0].errorText : nil
    error || "Failed to charge card."
  end

  def confirm_with_rep?
    params[:confirm_with_rep] == 'true'
  end

  def order_pods
    pods = []
    @order.order_items.each do |order_item|
      if order_item.orderable_type == 'LabRental' && order_item.orderable.level != "partner"
        pods << order_item.orderable
      end
    end
    return pods
  end
end
