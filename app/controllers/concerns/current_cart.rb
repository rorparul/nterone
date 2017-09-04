module CurrentCart
  extend ActiveSupport::Concern

  private

  def set_cart
    if params[:cart_token]
      @cart = Cart.find_by_token(params[:cart_token])
    elsif params[:order] && params[:order][:cart_token]
      @cart = Cart.find_by_token(params[:order][:cart_token])
    end

    if @cart.nil?
      if user_signed_in?
        @cart = current_user.cart

        if @cart.nil?
          begin
            @cart = Cart.find(cookies[:cart_id])
            @cart.update(user_id: current_user.id)
          rescue ActiveRecord::RecordNotFound
            @cart = Cart.create(user_id: current_user.id)
          end
        elsif params[:cart_token].nil? && @cart.id != cookies[:cart_id].to_i
          begin
            combine_carts(@cart, Cart.find(cookies[:cart_id]))
            cookies[:cart_id] = @cart.id
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

  def combine_carts(cart_nterone, cart_external_source)
    items_nterone   = cart_nterone.order_items.to_a
    items_external  = cart_external_source.order_items.to_a

    items_external.each_with_index do |item_external, index_external|
      items_nterone.each_with_index do |item_nterone, index_nterone|
        if item_external.orderable == item_nterone.orderable && item_external.price < item_nterone.price
          item_nterone.destroy
          item_external.update_attribute(:cart_id, cart_nterone.id)
          items_external[index_external] = nil
        elsif item_external.orderable == item_nterone.orderable && !(item_external.price < item_nterone.price)
          item_external.destroy
          items_external[index_external] = nil
        end
      end
    end

    items_external.compact!
    items_external.each { |item| item.update_attribute(:cart_id, cart_nterone.id) }
  end
end
