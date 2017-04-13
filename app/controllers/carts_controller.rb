class CartsController < ApplicationController
  include DiscountApplicator

  def calculator
    @credits = params[:quantity].to_i * 100
    @total   = @cart.total_price_after_credits(params[:quantity])
  end

  def render_discount
    @discount = Discount.find_by("lower(code) = ?", params[:discount_code].downcase)
    @discount = @discount.try(:active_and_within_bounds?) ? @discount : nil

    @price ||= discounted_total(@cart, @discount) if @discount
    @price ||= @cart.total_price

    if params[:form] == 'ca'
      @x_amount        = view_context.number_with_precision(@price, precision: 2)
      @x_login         = 'HCO-NTERO-710'
      @transaction_key = 'DTxm3lRAIaSfWHwTGnsN'
      @x_currency_code = 'CAD'
      @x_fp_sequence   = ((rand*100000).to_i + 2000).to_s
      @x_fp_timestamp  = Time.now.to_i.to_s
      @hmac_data       = "#{@x_login}^#{@x_fp_sequence}^#{@x_fp_timestamp}^#{@x_amount}^#{@x_currency_code}"
      @x_fp_hash       = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('md5'), @transaction_key, @hmac_data)

      return render 'render_discount_for_ca'
    end
  end

  def show
    @cart = Cart.find(params[:id])
    @order_items = @cart.order_items
  end

  def destroy
    cart = Cart.find(params[:id])
    cart.destroy
    redirect_to :back
  end
end
