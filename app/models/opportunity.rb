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

  before_save :update_date_closed, if: proc { |model| model.stage_changed? }

  private

  def update_date_closed
    if stage == 0 || stage == 100
      self.date_closed = Date.today
    else
      self.date_closed = nil
    end
  end
end
