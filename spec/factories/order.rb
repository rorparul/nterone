FactoryGirl.define do
  factory :order do
    association :buyer, factory: :user
  end
end
