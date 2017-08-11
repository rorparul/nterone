require 'rails_helper'

describe OrdersController do
  let(:user) { create(:user, cart: cart) }
  let(:price) { 100.0 }

  let(:cart) { create(:cart, order_items: [order_item]) }
  let(:order_item) { create(:order_item, price: price) }

  let(:params) {
    attributes_for(:user)
      .merge(paid: price.to_s)
      .merge(clc_quantity: "0")
  }

  it "updates user information" do
    request.cookies['cart_id'] = cart.id
    sign_in user

    post :create, order: params

    expect(assigns(:cart).total_price).to eq price
    user.reload
    expect(user.billing_first_name).to eq params[:billing_first_name]
  end

  it ""

end
