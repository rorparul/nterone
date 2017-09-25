require 'rails_helper'

describe Db::MergeService do
  let(:database) { "nterone-test-la" }

  subject { Db::MergeService.new database }

  before do
    ActiveRecord::Base.establish_connection :test
    begin
        ActiveRecord::Base.connection.execute("DROP DATABASE \"#{database}\";")
    rescue
    end
    ActiveRecord::Base.connection.execute("CREATE DATABASE \"#{database}\" WITH TEMPLATE nterone_test OWNER postgres;")
  end

  context '#merge_post_updates' do
    before do
      subject.merge_post_updates 'User', { a: [4, 5, 7], b: [4, 5, 8], d: [1, 2, 3] }
      subject.merge_post_updates 'User', { a: [1, 2, 3], b: [4, 5, 6], c: [7, 8, 9] }
    end

    it 'concatinates inner arrays' do
      expect(subject.post_updates['User'][:a]).to match_array [1, 2, 3, 4, 5, 7]
    end

    it 'uniq inner arrays' do
      expect(subject.post_updates['User'][:b]).to match_array [4, 5, 6, 8]
    end
  end

  context '#merge_model' do
    before do
      ActiveRecord::Base.establish_connection database.to_sym
      create_list :event, 3

      ActiveRecord::Base.establish_connection :test
      subject.merge_model(Event)
    end

    it 'sets origin_region' do
      expect(Event.all.map(&:origin_region).uniq).to eq ['latin_america']
    end

    it 'fills post_updates' do
      expect(subject.post_updates).to be_any
    end

    it 'checks belongs_to relations' do
      expect(subject.post_updates['Event']['event_id']).to match_array \
        ["Registration", "PublicFeaturedEvent", "Opportunity"]
    end
  end

  context '#post_update' do
    before do
      ActiveRecord::Base.establish_connection database.to_sym
      create :event
      create :video_on_demand

      create :registration, event: Event.last

      create :order_item, orderable: Event.last
      create :order_item, orderable: VideoOnDemand.last

      ActiveRecord::Base.establish_connection :test
      subject.merge_model(Event)
      subject.merge_model(Registration)
      subject.merge_model(OrderItem)
      subject.merge_model(VideoOnDemand)
      subject.post_update
    end

    it 'updates belongs_to relations' do
      expect(Registration.first.event.id).to eq Event.last.id
    end

    it 'updates polymorphic relations' do
      expect(OrderItem.order('id desc').offset(1).first.orderable_type).to eq 'Event'
      expect(OrderItem.order('id desc').offset(1).first.orderable.id).to eq Event.last.id

      expect(OrderItem.order('id desc').first.orderable_type).to eq 'VideoOnDemand'
      expect(OrderItem.order('id desc').first.orderable.id).to eq VideoOnDemand.last.id
    end
  end

end
