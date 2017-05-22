class ContactUsMailer < ApplicationMailer
  def contact_us(params)
    @tld       = Rails.application.config.tld
    @name      = params[:name]
    @phone     = params[:phone]
    @email     = params[:email]
    subject    = params[:subject].present? ? params[:subject] : "#{Setting.formatted_domain} Contact Us"
    @inquiry   = params[:inquiry]
    @feedback  = params[:feedback]

    mad360_emails = {
      ca: 'marketing360+m10780@bcc.mad360.net',
      com: 'marketing360+m9874@bcc.mad360.net',
      la: 'marketing360+m10794@bcc.mad360.net'
    }

    mail(
      to: params[:recipient],
      bcc: [
        'stephanie.pouse@madwiremedia.com',
        mad360_emails[@tld.to_sym]
      ],
      subject: subject
    )
  end
end
