class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:edit, :update, :destroy]

  def create
    @cart.order_items << find_orderable.order_items.build
    if @cart.save
      flash[:success] = "Item successfully added to cart! Please go to #{view_context.link_to "My Cart", new_order_path} to complete transaction".html_safe
    else
      flash[:alert] = "Item failed to add to cart!"
    end
    redirect_to :back
  end

  def edit
  end

  def update
    if @order_item.update_attributes(order_item_params)
      flash[:success] = "Registration successfully updated."
    else
      flash[:alert] = "Registration failed to update."
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    if @order_item.destroy
      flash[:success] = 'Item successfully removed from cart.'
    else
      flash[:alert] = 'Item failed to remove from cart.'
    end
    redirect_to :back
  end

  private
  
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:event_id,
                                       :video_on_demand_id,
                                       :sent_webex_invite,
                                       :sent_course_material,
                                       :sent_lab_credentials,
                                       :note)
  end

  def find_orderable
    order_item_params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
