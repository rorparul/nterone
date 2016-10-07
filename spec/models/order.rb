require 'rails_helper'

describe Video, type: :model do
  describe 'associacions' do
    it { is_expected.to belong_to(:seller) }
    it { is_expected.to belong_to(:buyer) }

    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:watched_videos) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:buyer) }
    it { is_expected.to validate_presence_of(:clc_number) }
  end

  describe 'instance methods' do
    describe '#confirm_with_partner' do

    end
  end
end
