# == Schema Information
#
# Table name: contact_us_submissions
#
#  id         :integer          not null, primary key
#  name       :string
#  phone      :string
#  email      :string
#  inquiry    :string
#  feedback   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipient  :string
#  subject    :string
#

class ContactUsSubmission < ActiveRecord::Base
  
end
