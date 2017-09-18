class LeadMailer < ApplicationMailer
  helper GeneralHelper

  def new_lead(lead)
    @lead = lead
    @url  = leads_url
    @tld  = Rails.application.config.tld

    mail(to: "nci@nterone.#{@tld}", subject: 'New Lead!')
  end
end
