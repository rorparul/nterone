FactoryGirl.define do
    factory :user do
        email { FFaker::Internet.free_email }
        password { "qweQwe123" }
        billing_first_name { FFaker::Name.first_name }
    end
end
