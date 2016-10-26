class CartsController < ApplicationController
  include DiscountApplicator

  def calculator
    @credits = params[:quantity].to_i * 100
    @total   = @cart.total_price_after_credits(params[:quantity])
  end

  def render_discount
    @discount = Discount.find_by(code: params[:discount_code])
    @discount = @discount.try(:active_and_within_bounds?) ? @discount : nil

    @price ||= discounted_total(@cart, @discount) if @discount
    @price ||= @cart.total_price
  end
end
