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
#  forem_admin             :boolean          default(FALSE)
#  forem_state             :string           default("pending_review")
#  forem_auto_subscribe    :boolean          default(FALSE)
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
#

class User < ActiveRecord::Base
  include RailsSettings::Extend
  include ModelSearch

  belongs_to :company

  has_one :interest,          dependent:  :destroy


  has_many :planned_subjects, dependent:  :destroy
  has_many :subjects,         through:    :planned_subjects
  has_many :chosen_courses,   dependent:  :destroy
  has_many :courses,          through:    :chosen_courses
  has_many :passed_exams,     dependent:  :destroy
  has_many :exams,            through:    :passed_exams

  #TODO: track leads through relationships instead
  has_many :seller_leads,     class_name: "Lead", foreign_key: "seller_id"
  has_many :buyer_leads,      class_name: "Lead", foreign_key: "buyer_id", dependent: :destroy
  # has_many :selling,        through: :seller_leads, source: :leads
  # has_many :buying,         through: :buyer_leads,  source: :leads

  has_many :lab_rentals # TODO: Consider the dependencies

  has_many :messages,             dependent:   :destroy
  has_many :posts
  has_many :roles,                dependent:   :destroy
  has_many :seller_orders,        class_name:  'Order',
                                  foreign_key: 'seller_id'
  has_many :buyer_orders,         class_name:  'Order',
                                  foreign_key: 'buyer_id'
  has_many :order_items
  has_many :events,               through:     :order_items,
                                  source:      :orderable,
                                  source_type: 'Event'
  has_many :video_on_demands,     through:     :order_items,
                                  source:      :orderable,
                                  source_type: 'VideoOnDemand'
  has_many :watched_videos,       dependent:   :destroy
  has_many :videos,               through:     :watched_videos
  has_many :seller_relationships, class_name:  'Relationship',
                                  foreign_key: 'seller_id'
  has_many :prospects,            through:     :seller_relationships,
                                  source:      :buyer

  accepts_nested_attributes_for :interest
  accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true

  devise :database_authenticatable,
         :invitable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  validate :password_complexity

  def password_complexity
    if password.present? and not password.match(/(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit"
    end
  end

  def forem_name
    full_name
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

  def self.only_students
    joins(:roles).where(roles: {role: 4}).distinct
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

  def upcoming_events
    events.where('start_date >= ?', Date.today).order(:start_date)
  end

  def past_events
    events.where('end_date < ?', Date.today).order(:end_date)
  end

  def active_video_on_demands
    order_items.where('orderable_type = ? and created_at >= ?', 'VideoOnDemand', Date.today - 365.day).collect do |order_item|
      order_item.orderable
    end
  end

  def inactive_video_on_demands
    order_items.where('orderable_type = ? and created_at < ?', 'VideoOnDemand', Date.today - 365.day).collect do |order_item|
      order_item.orderable
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
      sales_rep:     "Sales Rep",
      member:        "Member",
      lms_manager:   "LMS Manager",
      lms_student:   "LMS Student"
    }
    roles.each do |role|
      roles_collection += "#{normalized_roles[role.role.to_sym]}, "
    end
    roles_collection[0...-2]
  end

  def admin?
    has_role? :admin
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

  def has_role?(role_param)
    roles.any? { |role| role.role.to_sym == role_param }
  end

  def can_resend_invitation?
    admin? || sales_rep?
  end
end
