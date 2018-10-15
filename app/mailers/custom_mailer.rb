class CustomMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default from: "'NterOne Web' <email@nterone.com>"

  def welcome_internal(user)
    @tld  = Rails.application.config.tld
    @user = user

    mail(
      to: @user.email,
      bcc: [
        "sales@nterone.#{@tld}",
        "helpdesk@nterone.#{@tld}",
        "billing@nterone.#{@tld}"
      ],
      subject: "Welcome to NterOne.#{@tld}!",
      template_name: 'welcome'
    )
  end

  def welcome_external(user, m360 = nil)
    @tld  = Rails.application.config.tld
    @user = user
    @m360 = m360

    mail(
      to: [
        'stephanie.pouse@madwiremedia.com',
        {
          ca:  'marketing360+m10780@bcc.mad360.net',
          com: 'marketing360+m9874@bcc.mad360.net',
          la:  'marketing360+m10794@bcc.mad360.net'
        }[@tld.to_sym]
      ],
      subject: "Welcome to NterOne.#{@tld}!",
      template_name: 'welcome'
    )
  end
end
