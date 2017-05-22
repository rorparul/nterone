class CustomMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default from: "'NterOne Web' <email@nterone.#{Rails.application.config.tld}>"

  def welcome_experts_exchange(user)
    @tld  = Rails.application.config.tld
    @user = user

    mad360_emails = {
      ca: 'marketing360+m10780@bcc.mad360.net',
      com: 'marketing360+m9874@bcc.mad360.net',
      la: 'marketing360+m10794@bcc.mad360.net'
    }

    mail(
      to: @user.email,
      bcc: [
        "bob@nterone.com",
        "sales@nterone.#{@tld}",
        "helpdesk@nterone.#{@tld}",
        "billing@nterone.#{@tld}",
        'stephanie.pouse@madwiremedia.com',
        mad360_emails[@tld.to_sym]
      ],
      subject: "Welcome to #{t'website'}!"
    )
  end

  def welcome(user)
    @tld  = Rails.application.config.tld
    @user = user

    mad360_emails = {
      ca: 'marketing360+m10780@bcc.mad360.net',
      com: 'marketing360+m9874@bcc.mad360.net',
      la: 'marketing360+m10794@bcc.mad360.net'
    }

    mail(
      to: @user.email,
      bcc: [
        "sales@nterone.#{@tld}",
        "helpdesk@nterone.#{@tld}",
        "billing@nterone.#{@tld}",
        'stephanie.pouse@madwiremedia.com',
        mad360_emails[@tld.to_sym]
      ],
      subject: "Welcome to #{t'website'}!"
    )
  end
end
