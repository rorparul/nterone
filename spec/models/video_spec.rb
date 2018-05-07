# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  video_module_id :integer
#  title           :string
#  url             :string
#  embed_code      :text
#  free            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  position        :integer          default(0)
#  slug            :string
#  origin_region   :integer
#  active_regions  :text             default([]), is an Array
#
# Indexes
#
#  index_videos_on_origin_region  (origin_region)
#

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
