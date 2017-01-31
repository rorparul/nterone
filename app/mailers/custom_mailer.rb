class CustomMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default from: "'NterOne Web' <nci@nterone.com>"

  def welcome(user)
    @user = user
    mail(to: @user.email,
         bcc: ["sales@nterone.#{Setting.tld}", "helpdesk@nterone.#{Setting.tld}", "billing@nterone.#{Setting.tld}", 'stephanie.pouse@madwiremedia.com', 'marketing360+m9874@bcc.mad360.net'],
         subject: "Welcome to #{Setting.formatted_domain}!")
  end
end
