require 'rails_helper'

describe Api::V1::UsersController do
  let(:user) { create :user }

  context "without authenticate" do
    before do
      get :show, { id: user.id, format: :json }
    end

    it { expect(response.status).to_not eq 200 }
  end

  context "with authentication" do
    before do
      sign_in user

      get :show, { id: user.id, format: :json }
    end

    it { expect(response.status).to eq 200 }
  end
  
end