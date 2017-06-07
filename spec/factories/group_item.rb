FactoryGirl.define do
    factory :group_item do
        group
        groupable { create(:event) }
    end
end