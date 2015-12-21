class ContactUsMailer < ApplicationMailer
  def contact_us(user, params)
    @user     = user
    @inquiry  = params[:inquiry]
    @feedback = params[:feedback]
    mail(to: 'helpdesk@nterone.com', subject: 'NCI Contact Us')
  end
end
