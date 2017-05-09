# == Schema Information
#
# Table name: hacp_requests
#
#  id            :integer          not null, primary key
#  aicc_sid      :string
#  used          :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#  origin_region :integer
#

class HacpRequest < ActiveRecord::Base
  include Regions

  belongs_to :user
end
