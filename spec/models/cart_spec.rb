require 'rails_helper'

describe Cart do

  let(:cart) { create :cart }

  it { expect(cart).to_not be_nil }

end
