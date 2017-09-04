FactoryGirl.define do
  factory :order_item do
    orderable { create :event }
    price { 100.0 }
  end
end
