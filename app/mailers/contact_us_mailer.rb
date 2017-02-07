class ContactUsMailer < ApplicationMailer
  def contact_us(params)
    @name      = params[:name]
    @phone     = params[:phone]
    @email     = params[:email]
    subject    = params[:subject].present? ? params[:subject] : "#{Setting.formatted_domain} Contact Us"
    @inquiry   = params[:inquiry]
    @feedback  = params[:feedback]

    mail(
      to: params[:recipient],
      bcc: ['stephanie.pouse@madwiremedia.com', 'marketing360+m9874@bcc.mad360.net'],
      subject: subject
    )
  end
end
