# == Schema Information
#
# Table name: opportunities
#
#  id               :integer          not null, primary key
#  employee_id      :integer
#  customer_id      :integer
#  account_id       :integer
#  title            :string
#  stage            :integer
#  amount           :decimal(8, 2)    default(0.0)
#  kind             :string
#  reason_for_loss  :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  waiting          :boolean          default(FALSE)
#  payment_kind     :string
#  billing_street   :string
#  billing_city     :string
#  billing_state    :string
#  billing_zip_code :string
#  partner_id       :integer
#  date_closed      :date
#  course_id        :integer
#  event_id         :integer
#  email_optional   :string
#

class Opportunity < ActiveRecord::Base
  include SearchCop

  belongs_to :account,  class_name: 'Company'
  belongs_to :course
  belongs_to :customer, class_name: 'User'
  belongs_to :employee, class_name: 'User'
  belongs_to :event
  belongs_to :partner,  class_name: 'Company'

  search_scope :custom_search do
    attributes :title
    attributes account: ['account.title', 'account.industry_code']
    attributes partner: ['partner.title', 'partner.industry_code']
  end

  before_save :update_title,       if: proc { |model| model.title.blank? && model.course.present? }
  before_save :update_date_closed, if: proc { |model| model.stage_changed? }

  after_save :create_order, if: proc { |model| model.stage == 100 && model.course.present? && model.event.present? }

  private

  def update_title
    self.title = course.full_title
  end

  def update_date_closed
    if stage == 0 || stage == 100
      self.date_closed = Date.today
    else
      self.date_closed = nil
    end
  end

  def create_order
    order = Order.new(
      seller_id: employee.id,
      buyer_id: customer.id,
      first_name: customer.first_name,
      last_name: customer.last_name,
      referring_partner_email: email_optional
      # shipping_street: nil,
      # shipping_city: nil,
      # shipping_state: nil,
      # shipping_zip_code: nil,
      # shipping_country: nil,
      # id: 215,
      # created_at: Thu, 22 Dec 2016 00:14:21 EST -05:00,
      # updated_at: Thu, 22 Dec 2016 00:14:21 EST -05:00,
      # auth_code: "SJDSK2",
      # email: nil,
      # clc_number: nil,
      # billing_name: nil,
      # billing_zip_code: "10301",
      # paid: #<BigDecimal:7fe6b758d900,'0.1E5',9(18)>,
      # billing_street: "610 victory blvd",
      # billing_city: "Staten Island",
      # billing_state: "NY",
      # status: "Paid in Full",
      # total: #<BigDecimal:7fe6b756a2c0,'0.1E5',9(18)>,
      # billing_country: nil,
      # payment_type: "Credit Card",
      # clc_quantity: 0,
      # billing_first_name: "sD",
      # billing_last_name: "FSADFSDF",
      # shipping_company: nil,
      # billing_company: "",
      # same_addresses: true,
      # shipping_first_name: nil,
      # shipping_last_name: nil,
      # po_number: nil,
      # po_paid: #<BigDecimal:7fe6b99bddc0,'0.0',9(18)>,
      # verified: false,
      # invoiced: false,
      # invoice_number: nil,
      # status_position: 3,
      # reviewed: false,
      # balance: #<BigDecimal:7fe6ba827668,'0.0',9(18)>,
      # gilmore_order_number: nil,
      # gilmore_invoice: nil,
      # royalty_id: nil,
      # closed_date: nil,
      # source: 0,
      # other_source: nil,
      # discount_id: nil
    )

    order_item = order.order_items.new(
      user_id: customer.id,
      orderable_type: 'Event',
      orderable_id: event.id,
      price: amount
    )

    if order.save
      RegistrationMailer.confirmation(order_item).deliver_now
    end
  end
end
