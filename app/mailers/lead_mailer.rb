class LeadMailer < ApplicationMailer
  helper GeneralHelper
  def new_lead(lead)
    @lead = lead
    @url  = leads_url
    mail(to: "nci@nterone.#{Rails.application.config.tld}", subject: 'New Lead!')
  end
end
