# == Schema Information
#
# Table name: contact_infos
#
#  id            :integer          not null, primary key
#  first_name    :string
#  last_name     :string
#  email         :string
#  message       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resume_upload :string
#

class ContactInfo < ActiveRecord::Base
  mount_uploader :resume_upload, ResumeUploader
  validates :email, :first_name, :last_name ,:resume_upload,  presence: :true
  after_create :send_email_to_admin


  def send_email_to_admin
    ContactUsMailer.contact_info_email(self).deliver_now
  end
  

end
