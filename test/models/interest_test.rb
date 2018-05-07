# == Schema Information
#
# Table name: interests
#
#  id                               :integer          not null, primary key
#  user_id                          :integer
#  data_center                      :boolean
#  collaboration                    :boolean
#  network                          :boolean
#  security                         :boolean
#  associate_level_certification    :boolean
#  professional_level_certification :boolean
#  expert_level_certification       :boolean
#  other                            :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  origin_region                    :integer
#  active_regions                   :text             default([]), is an Array
#
# Indexes
#
#  index_interests_on_origin_region  (origin_region)
#

require 'test_helper'

class InterestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
