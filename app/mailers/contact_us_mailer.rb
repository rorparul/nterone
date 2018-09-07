class ContactUsMailer < ApplicationMailer
  def contact_us(params)
    @tld           = Rails.application.config.tld
    @recipient     = params[:recipient]
    @subject       = params[:subject].present? ? params[:subject] : "#{Setting.formatted_domain} Contact Us"
    @m360          = params['M360-Source']
    @name          = params[:name]
    @email         = params[:email]
    @phone         = params[:phone]
    @message       = params[:message]
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
      to: @recipient,
      cc: @email,
      subject: @subject
    )
  end

  def deliver_external
    @destination = 'external'

    mail(
      to: [
        'stephanie.pouse@madwiremedia.com',
        @mad360_emails[@tld.to_sym]
      ],
      subject: @subject
    )
  end


  def contact_info_email(contact)
    @tld       = Rails.application.config.tld
    @contact   = contact
    @subject = "Applied on job"
    mail(
      to: 
        "helpdesk@nterone.#{@tld}",
    )
  end
    
end
