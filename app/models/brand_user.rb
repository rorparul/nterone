class BrandUser < ActiveRecord::Base
  extend Enumerize
  enumerize :role, in: { member: 1, sales: 2, sales_manager: 3, brand_admin: 4 }, default: :member, predicates: true

  belongs_to :brand
  belongs_to :user

  validates             :user_id, uniqueness: { scope: :brand_id }
  # validates_presence_of :user

  delegate :super_admin?, to: :user

  def formatted_role
    normalized_roles = {
      member:        "Member",
      sales:         "Sales",
      sales_manager: "Sales Manager",
      brand_admin:   "Brand Admin"
    }
    normalized_roles[self.role.to_sym]
  end

  def self.selectable_roles
    [
      ["Member", "member"],
      ["Sales", "sales"],
      ["Sales Manager", "sales_manager"],
      ["Brand Admin", "brand_admin"]
    ]
  end

  def self.roles
    BrandUser.select(:role).map(&:role).uniq
  end
end
