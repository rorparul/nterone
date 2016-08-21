class Role < ActiveRecord::Base
  extend Enumerize
  enumerize :role, in: { admin: 1,
                         sales_manager: 2,
                         sales_rep: 3,
                         member: 4,
                         lms_manager: 5,
                         lms_student: 6,
                         instructor: 7 },
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
      instructor:   "Instructor"
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
      ["Instructor", "instructor"]
    ]
  end

  def self.roles
    Role.select(:role).map(&:role).uniq
  end
end
