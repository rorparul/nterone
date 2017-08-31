FactoryGirl.define do
  factory :order_item do
    orderable { create :event }
  end
end
