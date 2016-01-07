class OrderItemsController < ApplicationController
  skip_before_action :authorize, only: :create
  # include CurrentCart
  # before_action :set_cart, only: [:create]
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  def create
    @cart.order_items << find_orderable.order_items.build
    if @cart.save
      flash[:success] = 'Item successfully added to cart!'
    else
      flash[:alert] = "Item failed to add to cart!"
    end
    redirect_to :back
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
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
      params.require(:order_item).permit(:event_id, :video_on_demand_id)
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
