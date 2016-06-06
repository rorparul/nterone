require 'rails_helper'

describe Payment::CreateService do
  context 'with correct data' do
    before :each do
      stub_class_correct
    end

    it 'should create new payment' do
      service_result = described_class.new(order_params, cc_params).call
      expect(service_result.success?).to be_truthy
    end

    it 'should return response data' do
      service_result = described_class.new(order_params, cc_params).call

      expect(service_result.data).to be_kind_of(Hash)
      expect(service_result.data[:auth_code]).not_to be(nil)
      expect(service_result.data[:amount]).not_to be(nil)
    end
  end

  context 'with incorrect data' do
    before :each do
      stub_class_incorrect
    end

    it 'should return failure result' do
      service_result = described_class.new(order_params, cc_params).call
      expect(service_result.failure?).to be_truthy
    end
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

  def stub_class_correct
    allow_any_instance_of(described_class).to receive(:create_transaction).and_return({})
    allow_any_instance_of(described_class).to receive(:successfull_response?).and_return(true)
    allow_any_instance_of(described_class).to receive(:response_data)
      .and_return({ auth_code: '', amount: 10 })
  end

  def stub_class_incorrect
    allow_any_instance_of(described_class).to receive(:call)
      .and_return(ResultObjects::Failure.new({}))
  end
end
