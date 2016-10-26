class CartsController < ApplicationController

  def show
    @cart = Cart.find(params[:cart_id])
    @order_items = @cart.order_items
  end

  def calculator
    @credits = params[:quantity].to_i * 100
    @total   = @cart.total_price_after_credits(params[:quantity])
  end
end
