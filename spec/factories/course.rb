FactoryGirl.define do
  factory :course do
    title { FFaker::Lorem.sentence }
    abbreviation { FFaker::Lorem.word }
    categories { [create(:category)] }
  end
end
