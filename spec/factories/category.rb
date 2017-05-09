FactoryGirl.define do
  factory :category do
    title { FFaker::Lorem.sentence }
  end
end
