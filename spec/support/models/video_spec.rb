require 'rails_helper'

describe Video, type: :model do
  describe 'associacions' do
    it { is_expected.to belong_to(:video_module) }
    it { is_expected.to have_many(:watched_videos).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:watched_videos) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:embed_code) }
  end

  describe 'instance methods' do
    describe '#permit_user?' do
      
    end
  end
end
