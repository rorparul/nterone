class ApplicationMailer < ActionMailer::Base
  default from: "'NterOne Web' <nci#{I18n.t('email')}>"
  layout 'mailer'
end
