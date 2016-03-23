class User < ActiveRecord::Base
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
      sales_rep:     "Sales",
      member:        "Member"
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
end
