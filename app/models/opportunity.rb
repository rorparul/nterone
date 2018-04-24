# == Schema Information
#
# Table name: opportunities
#
#  id                 :integer          not null, primary key
#  employee_id        :integer
#  customer_id        :integer
#  account_id         :integer
#  title              :string
#  stage              :integer
#  amount             :decimal(8, 2)    default(0.0)
#  kind               :string
#  reason_for_loss    :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  waiting            :boolean          default(FALSE)
#  payment_kind       :string
#  billing_street     :string
#  billing_city       :string
#  billing_state      :string
#  billing_zip_code   :string
#  partner_id         :integer
#  date_closed        :date
#  course_id          :integer
#  event_id           :integer
#  email_optional     :string
#  notes              :text
#  origin_region      :integer
#  active_regions     :text             default([]), is an Array
#  video_on_demand_id :integer
#
# Indexes
#
#  index_opportunities_on_origin_region  (origin_region)
#

class Opportunity < ActiveRecord::Base
  include SearchCop
  include Regions

  belongs_to :account,  class_name: 'Company'
  belongs_to :course
  belongs_to :customer, class_name: 'User'
  belongs_to :employee, class_name: 'User'
  belongs_to :event
  belongs_to :video_on_demand
  belongs_to :partner,  class_name: 'Company'

  has_one :order, dependent: :destroy

  scope :pending, -> { where(stage: [10, 50, 75, 90]) }
  scope :won,     -> { where(stage: 100) }
  scope :lost,    -> { where(stage: 0) }
  scope :closed,  -> { where(stage: [100, 0]) }
  scope :waiting, -> { where(waiting: true) }
  scope :for_company_kind, ->(kind) { joins(:account).where(companies: {kind: kind})}

  search_scope :custom_search do
    attributes :title
    attributes account:  ['account.title', 'account.industry_code']
    attributes course:   ['course.abbreviation', 'course.title']
    attributes customer: ['customer.first_name', 'customer.last_name', 'customer.email']
    attributes partner:  ['partner.title', 'partner.industry_code']
  end

  validates_presence_of :employee_id
  validates_presence_of :account_id, unless: :account_id_required?

  before_save :update_title, if: proc { |model| model.title.blank? && model.course.present? }
  before_save :confirm_amount_equals_integer

  after_save :create_order,  if: proc { |model| model.stage_changed? && model.stage == 100 && model.course.present? && (model.event.present? || model.video_on_demand.present?) }
  after_save :update_order,  if: proc { |model| model.id_was.present? && (model.event_id_changed? || model.video_on_demand_id_changed?) && model.stage == 100 && model.order.present? }
  after_save :destroy_order, if: proc { |model| model.stage_changed? && model.stage_was == 100 && model.order.present? }

  def self.amount_open
    pending.sum(:amount)
  end

  def self.total_amount
    sum(:amount)
  end

  def self.get_company_total_amount opportunities, company_id
    opportunities = opportunities.select do |opportunity|
                    opportunity.account_id == company_id
                  end
    opportunities.sum(&:amount)
  end

  def self.group_by_months
    self.order("date_closed").group_by{ |opportunity| opportunity.date_closed.beginning_of_month }
  end

  def self.amount_waiting
    waiting.sum(:amount)
  end

  def self.amount_won_mtd
    won.where('date_closed >= ?', Date.today.beginning_of_month).sum(:amount)
  end

  def self.amount_won_last_month
    won.where('date_closed >= ? and date_closed <= ?', Date.today.last_month.beginning_of_month, Date.today.last_month.end_of_month).sum(:amount)
  end

  def self.amount_won_ytd
    won.where('date_closed >= ?', Date.today.beginning_of_year).sum(:amount)
  end

  def self.amount_won_last_year
    won.where('date_closed >= ? and date_closed <= ?', Date.today.last_year.beginning_of_year, Date.today.last_year.end_of_year).sum(:amount)
  end

  def closed?
    [0, 100].include?(stage)
  end

  private

  def confirm_amount_equals_integer
    self.amount = 0.00 if amount.nil?
  end

  def update_title
    self.title = course.full_title
  end

  def create_order
    order = Order.new(
      seller_id: employee.try(:id),
      buyer_id: customer.try(:id),
      opportunity_id: id,
      first_name: customer.try(:first_name),
      last_name: customer.try(:last_name),
      referring_partner_email: email_optional
    )

    order_items = []

    order_items << order.order_items.new(
      user_id: customer.try(:id),
      orderable_type: 'Event',
      orderable_id: event.try(:id),
      price: amount
    ) if event.present?

    order_items << order.order_items.new(
      user_id: customer.try(:id),
      orderable_type: 'VideoOnDemand',
      orderable_id: video_on_demand.try(:id),
      price: amount
    ) if video_on_demand.present?

    if order.save
      RegistrationMailer.create(order).deliver_now
    end
  end

  def update_order
    order_items = []

    if waiting
      order_items << order.order_items.create(
        user_id: customer.try(:id),
        orderable_type: 'Event',
        orderable_id: event.try(:id),
        price: amount
      ) if event.present?

      order_items << order.order_items.create(
        user_id: customer.try(:id),
        orderable_type: 'VideoOnDemand',
        orderable_id: video_on_demand.try(:id),
        price: amount
      ) if event.present?

      self.update_column(:waiting, false)
    else
      if event_id_changed?
        order_item = order.order_items.find_by(
          orderable_type: 'Event',
          orderable_id: event_id_was
        )

        order_item.update(
          orderable_id: event_id
        )

        order_items << order_item
      end

      if video_on_demand_id_changed?
        order_item = order.order_items.find_by(
          orderable_type: 'VideoOnDemand',
          orderable_id: video_on_demand_id_was
        )

        order_item.update(
          orderable_id: video_on_demand_id
        )

        order_items << order_item
      end
    end

    RegistrationMailer.create(order).deliver_now
  end

  def destroy_order
    order.destroy
  end

  def account_id_required?
    self.waiting_changed? && (self.waiting == true) ? true : false
  end
end
