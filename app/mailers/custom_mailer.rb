class CustomMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default from: "'NterOne Web' <email@nterone.#{Rails.application.config.tld}>"

  def welcome_experts_exchange(user)
    @user = user
    mail(
      to: @user.email,
      bcc: [
        "bob@nterone.com",
        "sales@nterone.#{Rails.application.config.tld}",
        "helpdesk@nterone.#{Rails.application.config.tld}",
        "billing@nterone.#{Rails.application.config.tld}",
        'stephanie.pouse@madwiremedia.com',
        'marketing360+m9874@bcc.mad360.net',
        'marketing360+M10780@bcc.mad360.net',
        'marketing360+M10794@bcc.mad360.net'
      ],
      subject: "Welcome to #{t'website'}!"
    )
  end

  def welcome(user)
    @user = user
    mail(
      to: @user.email,
      bcc: [
        "sales@nterone.#{Rails.application.config.tld}",
        "helpdesk@nterone.#{Rails.application.config.tld}",
        "billing@nterone.#{Rails.application.config.tld}",
        'stephanie.pouse@madwiremedia.com',
        'marketing360+m9874@bcc.mad360.net',
        'marketing360+M10780@bcc.mad360.net',
        'marketing360+M10794@bcc.mad360.net'
      ],
      subject: "Welcome to #{t'website'}!"
    )
  end
end
