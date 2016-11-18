# == Schema Information
#
# Table name: hacp_requests
#
#  id         :integer          not null, primary key
#  aicc_sid   :string
#  used       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class HacpRequest < ActiveRecord::Base
end
