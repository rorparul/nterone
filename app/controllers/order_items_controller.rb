class OrderItemsController < ApplicationController
  before_action :authenticate_user!

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
    if true?(params[:create_waiting])
      opportunity = @order_item.order.opportunity

      if opportunity.present?
        opportunity.update(
          waiting: true
        )
      else
        opportunity = Opportunity.create(
          employee_id: @order_item.order.seller_id,
          customer_id: @order_item.order.buyer_id,
          # account_id: ,
          # title: @order_item.orderable.full_title,
          stage: 100,
          amount: @order_item.price,
          # kind: ,
          # payment_kind: ,
          # billing_street: ,
          # billing_city: ,
          # billing_state: ,
          # billing_zip_code: ,
          # partner_id: ,
          # date_closed: ,
          course_id: @order_item.orderable.course.id,
          # event_id: ,
          # email_optional: ,
          waiting: true
        )

        @order_item.order.update(opportunity_id: opportunity.id)
      end

      #  id                   :integer          not null, primary key
      #  created_at           :datetime         not null
      #  updated_at           :datetime         not null
      #  orderable_id         :integer
      #  orderable_type       :string
      #  cart_id              :integer
      #  price                :decimal(8, 2)    default(0.0)
      #  order_id             :integer
      #  user_id              :integer
      #  sent_webex_invite    :boolean          default(FALSE)
      #  sent_course_material :boolean          default(FALSE)
      #  sent_lab_credentials :boolean          default(FALSE)
      #  status               :string
      #  note                 :text


      #  id                      :integer          not null, primary key
      #  created_at              :datetime         not null
      #  updated_at              :datetime         not null
      #  auth_code               :string
      #  first_name              :string
      #  last_name               :string
      #  shipping_street         :string
      #  shipping_city           :string
      #  shipping_state          :string
      #  shipping_zip_code       :string
      #  shipping_country        :string
      #  email                   :string
      #  clc_number              :string
      #  billing_name            :string
      #  billing_zip_code        :string
      #  paid                    :decimal(8, 2)    default(0.0)
      #  billing_street          :string
      #  billing_city            :string
      #  billing_state           :string
      #  seller_id               :integer
      #  buyer_id                :integer
      #  status                  :string           default("Uninvoiced")
      #  total                   :decimal(8, 2)    default(0.0)
      #  billing_country         :string
      #  payment_type            :string
      #  clc_quantity            :integer          default(0)
      #  billing_first_name      :string
      #  billing_last_name       :string
      #  shipping_company        :string
      #  billing_company         :string
      #  same_addresses          :boolean          default(FALSE)
      #  shipping_first_name     :string
      #  shipping_last_name      :string
      #  po_number               :string
      #  po_paid                 :decimal(8, 2)    default(0.0)
      #  verified                :boolean          default(FALSE)
      #  invoiced                :boolean          default(FALSE)
      #  invoice_number          :string
      #  status_position         :integer
      #  reviewed                :boolean          default(FALSE)
      #  balance                 :decimal(8, 2)    default(0.0)
      #  referring_partner_email :string
      #  gilmore_order_number    :string
      #  gilmore_invoice         :string
      #  royalty_id              :string
      #  closed_date             :date
      #  source                  :integer          default(0)
      #  other_source            :string
      #  discount_id             :integer
      #  opportunity_id          :integer

      if opportunity.present? && @order_item.destroy
        flash[:success] = 'Successfully added to waiting list.'
      else
        flash[:alert] = 'Failed to add to waiting list.'
      end
    else
      if @order_item.destroy
        flash[:success] = 'Successfully removed from cart.'
      else
        flash[:alert] = 'Failed to remove from cart.'
      end
    end

    redirect_to :back
  end

  def get_link
    @cart = Cart.new
    @cart.order_items << find_orderable.order_items.build
    @cart.save
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
