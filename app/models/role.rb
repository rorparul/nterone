# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role       :integer
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  extend Enumerize
  enumerize :role, in: { admin: 1,
                         sales_manager: 2,
                         sales_rep: 3,
                         member: 4,
                         lms_manager: 5,
                         lms_student: 6,
                         instructor: 7,
<<<<<<< HEAD
                         partner_admin: 8 },
=======
                         lms_business: 8 },
>>>>>>> staging
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
<<<<<<< HEAD
      instructor:    "Instructor",
      partner_admin: "Partner"
=======
      lms_business:  "LMS Business",
      instructor:    "Instructor"
>>>>>>> staging
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
<<<<<<< HEAD
      ["Instructor", "instructor"],
      ["Partner", "partner_admin"]
=======
      ['LMS Business', 'lms_business'],
      ["Instructor", "instructor"]
>>>>>>> staging
    ]
  end

  def self.roles
    Role.select(:role).map(&:role).uniq
  end
end
