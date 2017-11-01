FactoryGirl.define do
  factory :subject do
    title { Faker::Lorem.sentence }
    abbreviation { Faker::Lorem.sentence }
    categories { [create(:category)] }
    image
  end
end