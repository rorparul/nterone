class CartsController < ApplicationController
  # skip_before_action :authorize, only: [:create, :update, :destroy]
  # before_action :set_cart, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  def calculator
    credits = params[:quantity].to_f * 100
    if credits <= @cart.total_event_price
      @credits = credits
      @total   = @cart.total_price_after_credits(@credits)
    else
      render nothing: true
    end
  end
end
