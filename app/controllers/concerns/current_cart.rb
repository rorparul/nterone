module CurrentCart
  extend ActiveSupport::Concern

  private

  def set_cart
    if user_signed_in?
      @cart = current_user.cart

      if @cart.nil?
        begin
          @cart = Cart.find(cookies[:cart_id])
          @cart.update(user_id: current_user.id)
        rescue ActiveRecord::RecordNotFound
          @cart = Cart.create(user_id: current_user.id)
        end
      end
    else
      begin
        @cart = Cart.find(cookies[:cart_id])
      rescue ActiveRecord::RecordNotFound
        @cart = Cart.create
        cookies[:cart_id] = @cart.id
      end
    end
  end
end
