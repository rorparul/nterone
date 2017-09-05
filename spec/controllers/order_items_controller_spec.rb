require 'rails_helper'

describe OrderItemsController do
  let(:user) { create :user }

  context 'POST get_link' do
    let(:event) { create :event }

    before do
      request.env["HTTP_REFERER"] = '/'
      sign_in user
    end

    it 'creates cart with token' do
      post :get_link, { order_item: { event_id: event.id }, format: :js }
      expect(Cart.last.order_items.first.orderable.course.full_title).to eq event.course.full_title
    end
  end
end
