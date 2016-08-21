class LeadMailer < ApplicationMailer
  def new_lead(lead)
    @lead = lead
    @url  = leads_url
    mail(to: "nci#{I18n.t('email')}", subject: 'New Lead!')
  end
end
