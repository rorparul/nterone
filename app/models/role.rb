# == Schema Information
#
# Table name: roles
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  role           :integer
#  created_at     :datetime
#  updated_at     :datetime
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_roles_on_origin_region  (origin_region)
#

class Role < ActiveRecord::Base
  extend Enumerize
  # include Regions

  enumerize :role, in: {
    admin:         1,
    sales_manager: 2,
    sales_rep:     3,
    member:        4,
    lms_manager:   5,
    lms_student:   6,
    instructor:    7,
    lms_business:  8,
    partner_admin: 9,
    marketing:     10,
    webmaster:     11,
    lab_admin:     12
  },
    default: :member,
    predicates: true

  belongs_to :user

  validates :user, :role, presence: true

  def formatted_role
    normalized_roles = {
      admin:         "Admin",
      sales_manager: "Sales Manager",
      sales_rep:     "Sales",
      member:        "Member",
      lms_manager:   "LMS Manager",
      lms_student:   "LMS Student",
      instructor:    "Instructor",
      lms_business:  "LMS Business",
      partner_admin: "Partner",
      marketing:     "Marketing",
      webmaster:     "Webmaster",
      lab_admin:     "Lab Admin"
    }

    normalized_roles[self.role.to_sym]
  end

  def self.selectable_roles
    [
      ["Admin", "admin"],
      ["Sales Manager", "sales_manager"],
      ["Sales Rep", "sales_rep"],
      ["Member", "member"],
      ["LMS Manager", "lms_manager"],
      ["LMS Student", "lms_student"],
      ["Instructor", "instructor"],
      ['LMS Business', 'lms_business'],
      ["Partner", "partner_admin"],
      ["Marketing", "marketing"],
      ["Webmaster", "webmaster"],
      ["Lab Admin", "lab_admin"]
    ]
  end

  def self.roles
    Role.select(:role).map(&:role).uniq
  end
end
