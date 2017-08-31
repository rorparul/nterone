FactoryGirl.define do
    factory :user do
        email { FFaker::Internet.free_email }
        password { "qweQwe123" }

        first_name { FFaker::Name.first_name }
        last_name { FFaker::Name.last_name }

        billing_company { FFaker::Company.name }
        billing_street { FFaker::AddressUS.street_address }
        billing_city { FFaker::AddressUS.city }
        billing_state { FFaker::AddressUS.state }
        billing_zip_code { FFaker::AddressUS.zip_code }
    end
end
