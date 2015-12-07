class LeadMailer < ApplicationMailer
  def new_lead(lead)
    @lead = lead
    @url  = leads_url
    mail(to: 'nci@nterone.com', subject: 'New Lead!')
  end
end
