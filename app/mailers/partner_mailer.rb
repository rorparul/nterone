class PartnerMailer < ApplicationMailer
  def student_added(user, partner_email)
    @user = user
    mail(to: partner_email,
         subject: 'NterOne Web Student Added Confirmation',
         template_path: 'mailers',
         template_name: 'student_added')
  end
end
