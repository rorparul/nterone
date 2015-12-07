class ContactUsMailer < ApplicationMailer
  def contact_us(brand, user, params)
    @user     = user
    @inquiry  = params[:inquiry]
    @feedback = params[:feedback]
    mail(to: brand.email, subject: 'NCI Contact Us')
  end
end
