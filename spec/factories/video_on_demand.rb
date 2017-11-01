FactoryGirl.define do
  factory :video_on_demand do
    abbreviation { FFaker::Lorem.sentence }
    title { FFaker::Lorem.sentence }
    image
  end
end
