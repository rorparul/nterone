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
end
