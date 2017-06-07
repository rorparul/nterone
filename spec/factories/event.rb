FactoryGirl.define do
    factory :event do
        course
        format { "Live" }
        start_date { 3.days.ago }
        end_date { 3.days.from_now }
        start_time { "8:00" }
        end_time { "9:00" }
    end
end