# == Schema Information
#
# Table name: companies
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  title          :string
#  form_type      :integer
#  slug           :string
#  user_id        :integer
#  kind           :string
#  street         :string
#  city           :string
#  state          :string
#  zip_code       :string
#  phone          :string
#  website        :string
#  parent_id      :integer
#  industry_code  :string
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#  sales_force_id :string
#
# Indexes
#
#  index_companies_on_origin_region  (origin_region)
#

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
