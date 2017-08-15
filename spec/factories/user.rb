FactoryGirl.define do
    factory :user do
        email { FFaker::Internet.free_email }
        password { "qweQwe123" }
    end
end
