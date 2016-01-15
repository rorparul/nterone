class ContactUsMailer < ApplicationMailer
  def contact_us(params)
    @name     = params[:name]
    @phone    = params[:phone]
    @email    = params[:email]
    @inquiry  = params[:inquiry]
    @feedback = params[:feedback]
    mail(to: 'helpdesk@nterone.com', subject: 'NCI Contact Us')
  end
end
