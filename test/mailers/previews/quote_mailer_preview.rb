class QuoteMailerPreview < ActionMailer::Preview
  def pdf_attachment
    lead = Lead.first
    QuoteMailer.pdf_attachment(lead)
  end
end
