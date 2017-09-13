require 'rails_helper'

describe OrdersController do
  let(:user) { create(:user, cart: cart) }


  context "POST create" do

    let(:price) { 100.0 }
    let(:cart) { create(:cart, order_items: [order_item]) }
    let(:order_item) { create(:order_item, price: price) }

    let(:credit_card) { {
      payment_type: "Credit Card",
      credit_card_number: '4007000000027',
      security_code: '123',
      expiration_month: '11',
      expiration_year: '2020',
      paid: price
    } }

    let(:params) {
      attributes_for(:user)
        .merge(paid: price.to_s)
        .merge(clc_quantity: "0")
        .merge(credit_card)
    }

    before(:each) do
      request.env['HTTP_REFERER'] = '/'
      request.cookies['cart_id'] = cart.id
      sign_in user

      post :create, order: params
      user.reload
    end

    it "updates cart" do
      expect(assigns(:cart).total_price).to eq price
    end

    it "updates user information" do
      expect(user.billing_first_name).to eq params[:billing_first_name]
    end

    it "uses credit card" do
      expect(assigns(:order).auth_code).to_not be_nil
    end

    it "redirects to confirmation" do
      expect(response).to redirect_to(confirmation_orders_path(assigns(:order).id))
    end

  end

end
