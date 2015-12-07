class User < ActiveRecord::Base
  has_many :brand_users,      dependent:  :destroy
  has_many :planned_subjects, dependent:  :destroy
  has_many :subjects,         through:    :planned_subjects
  has_many :chosen_courses,   dependent:  :destroy
  has_many :courses,          through:    :chosen_courses
  has_many :passed_exams,     dependent:  :destroy
  has_many :exams,            through:    :passed_exams
  has_many :seller_leads,     class_name: "Lead", foreign_key: "seller_id"
  has_many :buyer_leads,      class_name: "Lead", foreign_key: "buyer_id", dependent: :destroy
  # has_many :selling,        through: :seller_leads, source: :leads
  # has_many :buying,         through: :buyer_leads,  source: :leads
  has_many :messages,         dependent:  :destroy
  has_many :posts

  devise :confirmable,
         :database_authenticatable,
         :invitable,
        #  :lockable,
        #  :omniauthable,
         :registerable,
         :recoverable,
         :rememberable,
        #  :timeoutable,
         :trackable,
         :validatable

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def my_plan_grand_total
    planned_unattended_courses.inject(0) {|sum, course| sum + course.price.to_f}
  end

  def planned_unattended_courses
    courses = []
    potential_courses = []
    self.planned_subjects.where(active: true).each do |planned_subject|
      planned_subject.subject.courses.each do |potential_course|
        potential_courses << potential_course
      end
    end
    self.chosen_courses.where(planned: true).where.not(attended: true).each do |chosen_course|
      course = chosen_course.course
      courses << course if potential_courses.include?(course)
    end
    courses
  end

  def new_message_count
    count = 0
    self.messages.where(read: false).each do |message|
      count += 1 if message.announcement.status == 'open'
    end
    count
  end

  def new_my_plan_count
    self.planned_subjects.where(active: true, read: false).count
  end

  def full_name
    if !self.first_name.blank? && !self.last_name.blank?
      "#{self.first_name} #{self.last_name}"
    else
      nil
    end
  end

  def option_class(subject)
    self.planned.include?(subject) ? " (planned)" : ""
  end

  def attended_courses
    attended = []
    self.planned_subjects.where(active: true).each do |planned_subject|
      planned_subject.chosen_courses.where(attended: true).each do |chosen_course|
        attended << chosen_course.course
      end
    end
    attended
  end

  def planned
    planned_subjects = []
    self.planned_subjects.where(active: true).each do |planned_subject|
      planned_subjects << planned_subject.subject
    end
    planned_subjects
  end

  def role
    roles = ""
    normalized_roles = {
      member:        "Member",
      sales:         "Sales",
      sales_manager: "Sales Manager",
      brand_admin:   "Brand Admin"
    }
    brand_users.each do |brand_user|
      roles += "#{normalized_roles[brand_user.role.to_sym]}, "
    end
    roles[0...-2]
  end

  def super_admin?
    admin
  end

  def brand_admin?
    has_role? :brand_admin
  end

  def any_admin?
    super_admin? || brand_admin?
  end

  def sales_manager?
    has_role? :sales_manager
  end

  def sales?
    has_role? :sales
  end

  def any_sales?
    sales_manager? || sales?
  end

  def any_sales_or_admin?
    any_sales? || any_admin?
  end

  def member?
    has_role? :member
  end

  def has_role?(role)
    brand_roles = BrandUser.role.values
    return false unless brand_roles.include?(role) || brand_roles.map(&:to_sym).include?(role)
    return false unless brand_users.present?

    brand_users.each { |brand_user| return true if brand_user.send("#{role}?") }
    false
  end
end
