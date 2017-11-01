FactoryGirl.define do
  factory :image do
    file { File.open Rails.root.join('spec/support/images/image.png') }
  end
end