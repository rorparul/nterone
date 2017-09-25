# == Schema Information
#
# Table name: relationships
#
#  id             :integer          not null, primary key
#  seller_id      :integer
#  buyer_id       :integer
#  status         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_relationships_on_buyer_id                (buyer_id)
#  index_relationships_on_origin_region           (origin_region)
#  index_relationships_on_seller_id               (seller_id)
#  index_relationships_on_seller_id_and_buyer_id  (seller_id,buyer_id) UNIQUE
#

class Relationship < ActiveRecord::Base
  include Regions

  belongs_to :seller, class_name: "User"
  belongs_to :buyer,  class_name: "User"
end
