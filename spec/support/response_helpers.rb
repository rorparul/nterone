RSpec::Matchers.define :have_status do |type, message = nil|
  match do |_response|
    assert_response type, message
  end
end
