# == Schema Information
#
# Table name: carts
#
#  id                         :integer          not null, primary key
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  source_name                :string
#  source_user_id             :string
#  source_hash                :string
#  user_id                    :integer
#  origin_region              :integer
#  active_regions             :text             default([]), is an Array
#  token                      :string
#  notified_not_empty_cart_at :datetime
#
# Indexes
#
#  index_carts_on_origin_region  (origin_region)
#  index_carts_on_token          (token)
#

require 'rails_helper'

describe Cart do

  let(:cart) { create :cart }

  it { expect(cart).to_not be_nil }

end
