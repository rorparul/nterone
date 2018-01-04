require 'rails_helper'

describe Payment::CreateService do
  let(:user) { create :user }
  let(:order) { build(:order, buyer: user) }

  before :each do
    @order_params = order_params
    @cc_params = cc_params
  end

  subject { described_class.new(@order_params, @cc_params).call }

  context 'with correct data' do
    it { expect(subject.success?).to be_truthy }
    it { expect(subject.data).to be_kind_of(Hash) }
    it { expect(subject.data[:auth_code]).not_to be(nil) }
    it { expect(subject.data[:amount]).not_to be(nil) }
  end

  context 'with incorrect data' do
    before :each do
      @cc_params[:credit_card_number] = "462032"

      expect_any_instance_of(described_class).to receive(:log_payment_error)
    end

    it { expect(subject).to be_truthy }
  end

private
  def cc_params
    {
      credit_card_number: '4007000000027',
      security_code: '123',
      expiration_month: '11',
      expiration_year: '2020',
      paid: 20
    }
  end

  def order_params
    {
      billing_first_name: 'John',
      billing_last_name: 'Doe',
      billing_street: 'random street',
      billing_city: 'NY',
      billing_state: 'TX',
      billing_zip_code: '1344'
    }
  end
end
