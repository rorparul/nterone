FactoryGirl.define do
    factory :user do
        email { FFaker::Internet.free_email }
        password { "qweQwe123" }

        billing_company ""
        billing_first_name "Test"
        billing_last_name "Test"
        billing_street "Test"
        billing_city "Test"
        billing_state "Test"
        billing_zip_code "190190"
    end
end
