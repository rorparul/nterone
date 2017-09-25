require 'rails_helper'

describe Db::MergeService do
  let(:database1) { :"nterone-test-la" }
  let(:database2) { :"nterone-test-ca" }

  let(:service1) { Db::MergeService.new database1 }
  let(:service2) { Db::MergeService.new database2 }

  before do
    ActiveRecord::Base.establish_connection :test
    begin
        ActiveRecord::Base.connection.execute("DROP DATABASE \"#{database1}\";")
    rescue
    end
    ActiveRecord::Base.connection.execute("CREATE DATABASE \"#{database1}\" WITH TEMPLATE nterone_test OWNER postgres;")
  end

  context '#merge_post_updates' do
    before do
      service1.merge_post_updates 'User', { a: [4, 5, 7], b: [4, 5, 8], d: [1, 2, 3] }
      service1.merge_post_updates 'User', { a: [1, 2, 3], b: [4, 5, 6], c: [7, 8, 9] }
    end

    it 'concatinates inner arrays' do
      expect(service1.post_updates['User'][:a]).to match_array [1, 2, 3, 4, 5, 7]
    end

    it 'uniq inner arrays' do
      expect(service1.post_updates['User'][:b]).to match_array [4, 5, 6, 8]
    end
  end

  context '#merge_model' do
    before do
      ActiveRecord::Base.establish_connection database1
      create_list :event, 3

      ActiveRecord::Base.establish_connection database2
      create_list :event, 3

      ActiveRecord::Base.establish_connection :test
      service1.merge_model(Event)
      service2.merge_model(Event)
    end

    it 'sets origin_region' do
      expect(Event.unscoped.all.map(&:origin_region).uniq).to match_array ['latin_america', 'canada']
    end

    it 'fills post_updates' do
      expect(service1.post_updates).to be_any
    end

    it 'checks belongs_to relations' do
      expect(service1.post_updates['Event']['event_id']).to match_array \
        ["Registration", "PublicFeaturedEvent", "Opportunity"]
    end
  end

  context '#post_update' do
    before do
      ActiveRecord::Base.establish_connection database1
      create :event
      create :video_on_demand

      create :registration, event: Event.last

      create :order_item, orderable: Event.last
      create :order_item, orderable: VideoOnDemand.last

      ActiveRecord::Base.establish_connection :test
      service1.merge_model(Event)
      service1.merge_model(Registration)
      service1.merge_model(OrderItem)
      service1.merge_model(VideoOnDemand)
      service1.post_update
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

  context '#'

end
