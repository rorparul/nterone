require 'rails_helper'

feature 'Purchase Order Item With Link As Member' do

  let!(:cart) { create :cart }
  let!(:order_item) { create :order_item, cart: cart }

  let(:user) { create :user }
  let(:password) { "qweQwe123" }

  scenario 'with valid card' do

    # Sign in
    visit '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Login'
    expect(page.body).to have_content 'Signed in successfully.'

    # cart
    visit "/orders/new/#{cart.token}"
    expect(page.body).to have_content order_item.orderable.course.full_title

    # credit card
    fill_in 'Credit Card Number', with: '4111111111111111'
    select '01', from: 'Exp. M.'
    select '20', from: 'Exp. Y.'
    fill_in 'Code', with: '123'

    check('Shipping address is the same')

    click_button 'Place Order'
    expect(page.body).to have_content I18n.t('orders.create.success')

  end

end
