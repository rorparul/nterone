class CartsController < ApplicationController
  def calculator
    @credits = params[:quantity].to_i * 100
    @total   = @cart.total_price_after_credits(params[:quantity])
  end
end
