class ContactUsMailer < ApplicationMailer
  def contact_us(params)
    @tld           = Rails.application.config.tld
    @recipient     = params[:recipient]
    @subject       = params[:subject].present? ? params[:subject] : "#{Setting.formatted_domain} Contact Us"
    @m360          = params['M360-Source']
    @name          = params[:name]
    @phone         = params[:phone]
    @email         = params[:email]
    @inquiry       = params[:inquiry]
    @feedback      = params[:feedback]
    @mad360_emails = {
      ca: 'marketing360+m10780@bcc.mad360.net',
      com: 'marketing360+m9874@bcc.mad360.net',
      la: 'marketing360+m10794@bcc.mad360.net'
    }

    deliver_internal.deliver
    deliver_external
  end

  def deliver_internal
    @destination = 'internal'

    mail(
      to: [@recipient, 'stephanie.pouse@madwiremedia.com', @mad360_emails[@tld.to_sym]],
      subject: @subject
    )
  end

  def deliver_external
    @destination = 'external'

    mail(
      to: @email,
      subject: @subject
    )
  end
end
