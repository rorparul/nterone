# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  seller_id  :integer
#  buyer_id   :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_relationships_on_buyer_id                (buyer_id)
#  index_relationships_on_seller_id               (seller_id)
#  index_relationships_on_seller_id_and_buyer_id  (seller_id,buyer_id) UNIQUE
#

class Relationship < ActiveRecord::Base
  belongs_to :seller, class_name: "User"
  belongs_to :buyer,  class_name: "User"
end
