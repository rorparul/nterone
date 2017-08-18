class PermittedParams < Struct.new(:params)

  def credit_card
    params.require(:order).permit(
      :credit_card_number,
      :expiration_month,
      :expiration_year,
      :security_code,
      :paid
    )
  end

  def order
    params.require(:order).permit(
      :seller_id,
      :buyer_id,
      :status,
      :payment_type,
      :same_addresses,
      :billing_company,
      :billing_first_name,
      :billing_last_name,
      :billing_street,
      :billing_city,
      :billing_state,
      :billing_zip_code,
      :discount_id,
      :shipping_company,
      :shipping_first_name,
      :shipping_last_name,
      :shipping_street,
      :shipping_city,
      :shipping_state,
      :shipping_zip_code,
      :origin_region
    )
  end

  def user
    params.require(:order).permit(
      :same_addresses,
      :billing_first_name,
      :billing_last_name,
      :billing_street,
      :billing_city,
      :billing_state,
      :billing_zip_code,
      :shipping_first_name,
      :shipping_last_name,
      :shipping_street,
      :shipping_city,
      :shipping_state,
      :shipping_zip_code,
      :referring_partner_email
    )
  end

  def cisco_learning_credits
    params.require(:order).permit(
      :clc_number,
      :clc_quantity
    )
  end

  def order_admin
    params.require(:order).permit(
      :seller_id,
      :buyer_id,
      :clc_number,
      :clc_quantity,
      :payment_type,
      :paid,
      :po_paid,
      :invoice_number,
      :reviewed,
      :gilmore_order_number,
      :gilmore_invoice,
      :royalty_id,
      :po_number,
      :closed_date,
      :referring_partner_email,
      :same_addresses,
      :billing_company,
      :billing_first_name,
      :billing_last_name,
      :billing_street,
      :billing_city,
      :billing_state,
      :billing_zip_code,
      :shipping_company,
      :shipping_first_name,
      :shipping_last_name,
      :shipping_street,
      :shipping_city,
      :shipping_state,
      :shipping_zip_code,
      :source,
      :other_source,
      :origin_region,
      order_items_attributes: [
        :id,
        :user_id,
        :orderable_id,
        :orderable_type,
        :price,
        :_destroy
      ]
    )
  end

end
