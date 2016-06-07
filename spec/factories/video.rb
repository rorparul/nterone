FactoryGirl.define do
  factory :video do |video|
    title
    position
    url
    embed_code
    free { generate(:boolean_value) }
  end
end
