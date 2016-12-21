# == Schema Information
#
# Table name: opportunities
#
#  id              :integer          not null, primary key
#  employee_id     :integer
#  customer_id     :integer
#  company_id      :integer
#  title           :string
#  stage           :integer
#  amount          :decimal(8, 2)    default(0.0)
#  kind            :string
#  reason_for_loss :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Opportunity < ActiveRecord::Base
  include SearchCop

  belongs_to :employee, class_name: 'User'
  belongs_to :customer, class_name: 'User'

  search_scope :custom_search do
    attributes :title, :industry_code
    attributes company: ['company.title', 'company.industry_code']
    # attributes :user => ['user.first_name', 'user.last_name', 'user.email']
  end
end
