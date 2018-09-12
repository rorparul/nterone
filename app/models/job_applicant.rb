# == Schema Information
#
# Table name: job_applicants
#
#  id            :integer          not null, primary key
#  first_name    :string
#  last_name     :string
#  email         :string
#  message       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resume_upload :string
#  phone         :string           default("")
#

class JobApplicant < ActiveRecord::Base
  mount_uploader :resume_upload, ResumeUploader
  validates :email, :first_name, :last_name, :phone, :resume_upload,  presence: :true
  after_create :send_email_to_admin
  include SearchCop

  search_scope :custom_search do
    attributes :email, :first_name, :last_name
  end

  def send_email_to_admin
    ContactUsMailer.contact_info_email(self).deliver_now
  end
end