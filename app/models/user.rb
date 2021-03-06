# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :inet
#  last_sign_in_ip         :inet
#  created_at              :datetime
#  updated_at              :datetime
#  company_name            :string
#  first_name              :string
#  last_name               :string
#  contact_number          :string
#  country                 :string
#  website                 :string
#  street                  :string
#  city                    :string
#  state                   :string
#  zipcode                 :string
#  archived                :boolean          default(FALSE)
#  confirmation_token      :string
#  confirmed_at            :datetime
#  confirmation_sent_at    :datetime
#  unconfirmed_email       :string
#  invitation_token        :string
#  invitation_created_at   :datetime
#  invitation_sent_at      :datetime
#  invitation_accepted_at  :datetime
#  invitation_limit        :integer
#  invited_by_id           :integer
#  invited_by_type         :string
#  invitations_count       :integer          default(0)
#  last_active_at          :datetime
#  billing_street          :string
#  billing_city            :string
#  billing_state           :string
#  billing_zip_code        :string
#  same_addresses          :boolean          default(FALSE)
#  billing_first_name      :string
#  billing_last_name       :string
#  shipping_first_name     :string
#  shipping_last_name      :string
#  shipping_street         :string
#  shipping_city           :string
#  shipping_state          :string
#  shipping_zip_code       :string
#  shipping_company        :string
#  billing_company         :string
#  referring_partner_email :string
#  company_id              :integer
#  about                   :text
#  status                  :integer          default(0)
#  onsite_daily_rate       :decimal(8, 2)    default(0.0)
#  video_bio               :text
#  source_name             :string
#  source_user_id          :string
#  parent_id               :integer
#  salutation              :string
#  business_title          :string
#  do_not_call             :boolean
#  do_not_email            :boolean
#  email_alternative       :string
#  phone_alternative       :string
#  notes                   :text
#  aasm_state              :string
#  origin_region           :integer
#  active_regions          :text             default([]), is an Array
#  active                  :boolean          default(TRUE)
#  archive                 :boolean          default(FALSE)
#  sales_force_id          :string
#  customer_type           :integer
#  online_daily_rate       :decimal(8, 2)    default(0.0)
#  employement_type        :integer
#  rating                  :integer
#
# Indexes
#
#  index_users_on_company_id            (company_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_origin_region         (origin_region)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#

require 'roo'

class User < ActiveRecord::Base
  extend  ActsAsTree::TreeView
  extend  ActsAsTree::TreeWalker
  include RailsSettings::Extend
  include SearchCop
  include Regions

  acts_as_tree order: 'last_name'

  enum customer_type: { direct_customer: 0, partner_customer: 1 }
  enum employement_type: { employee: 0, contractor: 1 }
  enum status: { open: 0, contacted: 1, pending_class: 2, qualified: 3, closed: 4 }

  belongs_to :company

  has_one :interest,                 dependent:  :destroy
  has_one :cart,                     dependent:  :destroy
  has_one :lms_managers_associacion, foreign_key: :user_id, class_name: 'LmsManagedStudent'
  has_one :lms_manager,              through: :lms_managers_associacion, source: 'manager'

  has_many :planned_subjects,         dependent:  :destroy
  has_many :subjects,                 through:    :planned_subjects
  has_many :chosen_courses,           dependent:  :destroy
  has_many :courses,                  through:    :chosen_courses
  has_many :passed_exams,             dependent:  :destroy
  has_many :exams,                    through:    :passed_exams
  has_many :assigned_items,           foreign_key: 'student_id'
  has_many :assigned_vods,            through: :assigned_items, source: :item, source_type: 'VideoOnDemand'
  has_many :seller_leads,             class_name: "Lead", foreign_key: "seller_id"
  has_many :buyer_leads,              class_name: "Lead", foreign_key: "buyer_id", dependent: :destroy
  has_many :lab_rentals
  has_many :individual_lab_rentals,   through: :order_items, source: :orderable, source_type: 'LabRental'
  has_many :posts
  has_many :roles,                    dependent: :destroy
  has_many :seller_orders,            class_name: 'Order', foreign_key: 'seller_id'
  has_many :buyer_orders,             class_name: 'Order', foreign_key: 'buyer_id'
  has_many :order_items
  has_many :events,                   through: :order_items, source: :orderable, source_type: 'Event'
  has_many :video_on_demands,         through: :order_items, source: :orderable, source_type: 'VideoOnDemand'
  has_many :watched_videos,           dependent: :destroy
  has_many :videos,                   through: :watched_videos
  has_many :seller_relationships,     class_name: 'Relationship', foreign_key: 'seller_id'
  has_many :prospects,                through: :seller_relationships, source: :buyer
  has_many :lms_students,             through: :lms_students_associacion, source: 'user'
  has_many :lms_students_associacion, foreign_key: :manager_id, class_name: 'LmsManagedStudent'
  has_many :taught_events,            class_name: 'Event', foreign_key: 'instructor_id'
  has_many :taught_video_on_demands,  class_name: 'VideoOnDemand', foreign_key: 'instructor_id'
  has_many :hacp_requests,            dependent: :destroy
  has_many :companies,                dependent: :nullify
  has_many :opportunities,            class_name: 'Opportunity', foreign_key: 'employee_id'
  has_many :tasks
  has_many :rep_tasks,                class_name: 'Task', foreign_key: 'rep_id'
  has_many :employments,              class_name: 'ResourceEvent', foreign_key: 'instructor_id'
  has_many :event_requests,           class_name: 'Event', foreign_key: 'sales_rep_id'

  accepts_nested_attributes_for :interest
  accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :chosen_courses, reject_if: :all_blank, allow_destroy: true

  scope :active_sales,            -> { joins(:roles).where(roles: { role: [2, 3] }).where.not(archive: true).order(:last_name) }
  scope :all_instructors,         -> { joins(:roles).where(roles: { role: 7 }).order('last_name').order("onsite_daily_rate asc").distinct }
  scope :all_instructors_by_rate, -> { joins(:roles).where(roles: { role: 7 }).order("onsite_daily_rate asc").distinct }
  scope :all_sales,               -> { joins(:roles).where(roles: { role: [2, 3] }).order(:last_name) }
  scope :admins,                  -> { joins(:roles).where(roles: { role: 1 }).distinct }
  scope :students,                -> { joins(:roles).where(roles: { role: 4 }).distinct }
  scope :members,                 -> { joins(:roles).where(roles: { role: 4 }).distinct }
  scope :instructors,             -> { joins(:roles).where(roles: { role: 7 }).distinct }
  scope :partners,                -> { joins(:roles).where(roles: { role: 9 }).distinct }
  scope :leads,                   -> { where.not(status: [3, 4]) }
  scope :contacts,                -> { where(status: [3, 4]) }
  scope :all_stage,               -> { where(status: [0, 1, 2, 3, 4]) }
  scope :direct_customer,         -> { where(customer_type: 0) }
  scope :private_customer,        -> { where(customer_type: 1) }

  search_scope :custom_search do
    attributes :first_name, :last_name, :email
  end

  devise :database_authenticatable,
         :invitable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  validate :password_complexity
  validates_uniqueness_of :source_user_id, allow_blank: true

  after_save do
    if onsite_daily_rate_changed? || online_daily_rate_changed?
      update_instructor_costs
    end
  end

  Ratings = [ ['1',1],['2',2],['3',3],['4',4],['5',5]]

  def developer?
    email == 'ryan@storberg.net'
  end

  def active_for_authentication?
    super && active?
  end

  def carted_items(args = {})
    items = order_items.includes(:orderable).where(order_id: nil).where.not(cart_id: nil)
    args[:orderables] ? items.map(&:orderable) : items
  end

  def purchased_items(args = {})
    items = order_items.includes(:orderable).where(cart_id: nil).where.not(order_id: nil)
    args[:orderables] ? items.map(&:orderable) : items
  end

  def purchase?(orderable)
    order_items.where(cart_id: nil).where.not(order_id: nil).map(&:orderable).include?(orderable)
  end

  def self.lms_students_all
    User.includes(:roles).where(roles: { role: 6 })
  end

  def self.lms_managers_all
    User.includes(:roles).where(roles: { role: 5 })
  end

  def self.members_engaged
    members_who_have_logged_in = joins(:roles).where(roles: { role: 4 }, customer_type: [nil, 0]).where.not(last_sign_in_at: nil)
    members_who_have_an_order  = joins(:roles, :buyer_orders).where(roles: { role: 4 }, customer_type: [nil, 0])
    (members_who_have_logged_in + members_who_have_an_order).uniq
  end

  def password_complexity
    if password.present? and not password.match(/(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit"
    end
  end

  def my_plan_total_low
    planned_unattended_courses.inject(0) do |sum, course|
      event = course.events.where('active = ? and start_date >= ?', true, Date.today).order(:price).first
      if event
        sum + event.price
      else
        sum + 0
      end
    end
  end

  def taught_events_in_range(start_date, end_date)
    self.taught_events.where(start_date: start_date..end_date)
  end

  def my_plan_total_high
    planned_unattended_courses.inject(0) do |sum, course|
      event = course.events.where('active = ? and start_date >= ?', true, Date.today).order(:price).last
      if event
        sum + event.price
      else
        sum + 0
      end
    end
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

  def show_tasks?
    return false unless self.has_any_role? [:sales_manager, :sales_rep]
    return true if settings.task_popup_time && settings.task_popup_time < (Time.now - 6.hours)
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

  def name_initials
    if !self.first_name.blank? && !self.last_name.blank?
      "#{self.first_name[0]} #{self.last_name[0]}"
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

  def upcoming_events
    events.where('start_date >= ?', Date.today).order(:start_date)
  end

  def past_events
    events.where('start_date < ?', Date.today).order(:end_date)
  end

  def active_video_on_demands
    order_items.where(orderable_type: 'VideoOnDemand').each_with_object([]) do |order_item, array|
      array << order_item.orderable if order_item.order.created_at >= Date.today - 365.day
    end
  end

  def inactive_video_on_demands
    order_items.where(orderable_type: 'VideoOnDemand').each_with_object([]) do |order_item, array|
      array << order_item.orderable if order_item.order.created_at < Date.today - 365.day
    end
  end

  def completed_events_and_video_on_demands
    past_events + inactive_video_on_demands
  end

  def planned
    planned_subjects = []
    self.planned_subjects.where(active: true).each do |planned_subject|
      planned_subjects << planned_subject.subject
    end
    planned_subjects
  end

  def role
    roles_collection = ""

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

    roles.each do |role|
      roles_collection += "#{normalized_roles[role.role.to_sym]}, "
    end

    roles_collection[0...-2]
  end

  def only_role?(role)
    role = role.to_s + "?"
    if self.send(role)
      return self.roles.count == 1 ? true : false
    else
      return false
    end
  end

  def admin?
    has_role? :admin
  end

  def partner?
    has_role? :partner_admin
  end

  def lms_manager?
    has_role? :lms_manager
  end

  def lms_student?
    has_role? :lms_student
  end

  def lms_business?
    has_role? :lms_business
  end

  def lms?
    lms_student? || lms_manager? || lms_business?
  end

  def sales_manager?
    has_role? :sales_manager
  end

  def sales_rep?
    has_role? :sales_rep
  end

  def sales?
    sales_manager? || sales_rep?
  end

  def employee?
    admin? || sales?
  end

  def member?
    has_role? :member
  end

  def instructor?
    has_role? :instructor
  end

  def marketing?
    has_role? :marketing
  end

  def has_role?(role_param)
    roles.any? { |role| role.role.to_sym == role_param }
  end

  def has_any_role?(roles_param)
    roles_param.any? { |role_param| roles.any? { |role| role.role.to_sym == role_param } }
  end

  def full_address
    [street, city, state, zipcode, country].compact.join(", ")
  end

  def daily_rate(event=nil)
    if event.present?
      Event::LIVE_ONLINE_FORMATS.include?(event.format) ? self.online_daily_rate : self.onsite_daily_rate
    else
      self.onsite_daily_rate
    end
  end

  def self.unsubscribe_from_email(file)
    spreadsheet = self.open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = find_by_email(row["Email"])
      user.update_attributes(do_not_email: true) if user.present?
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def next_upcoming_event
    events.where("start_date >= :start_date", { start_date: Date.today }).order(:start_date).first
  end

  def total_work_days
    sum = 0;
    past_events.map{|event| sum += event.length}
    return sum
  end

  def total_instructor_cost
    past_events.sum(:cost_instructor).to_f
  end

  def self.instructor_events_and_lab_rentals(instructors)
    events = []
    instructors.includes(:events, :lab_rentals).each do |ins|
      ins.events.each{|e| events << e} unless ins.events.blank?
    end
    return events
  end

  def self.exclude_instructor_already_assigned(event)
    ins =    all_instructors_by_rate.joins(:events).where("events.start_date >= ? AND events.end_date <= ?",event.start_date,event.end_date).uniq.map(&:id)
    lab =   all_instructors_by_rate.joins(:lab_rentals).where("(lab_rentals.first_day >= ? AND lab_rentals.last_day <= ?)",event.start_date, event.end_date).uniq.map(&:id)
    all_instructor = User.all_instructors_by_rate.where.not(:id=>[ins, lab])
    return all_instructor
  end

  def instructor_employment_date
    dates = self.employments.map{|emp| [emp.start_date, emp.end_date]}.uniq
    employment_date = ""
    dates.each_with_index do |emp, index|
      if index == 0
        employment_date << "#{emp[0].to_formatted_s(:rfc822)}"+" to "+"#{emp[1].to_formatted_s(:rfc822)}"
      else
        employment_date << + "," + "#{emp[0].to_formatted_s(:rfc822)}"+" to "+"#{emp[1].to_formatted_s(:rfc822)}"
      end
    end
    return employment_date
  end

  private

  def update_instructor_costs
    if self.instructor?
      events = Event.upcoming_events.where(instructor_id: self.id)
      events.each do |event|
        if event.autocalculate_instructor_costs && event.end_date != nil
          event.cost_instructor = self.daily_rate(event) * event.length
          event.save
        end
      end
    end
  end
end
