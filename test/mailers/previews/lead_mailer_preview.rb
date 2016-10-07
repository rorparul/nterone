class LeadMailerPreview < ActionMailer::Preview
  def new_lead
    lead = Lead.first
    LeadMailer.new_lead(lead)
  end
end
