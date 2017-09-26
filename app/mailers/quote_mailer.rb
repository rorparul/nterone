class QuoteMailer < ApplicationMailer
  def pdf_attachment(lead)
    @lead = lead

    mail(to: @lead.buyer.email, subject: "Your NterOne.com Sales Quotation")
      .attachments["quote.pdf"] = WickedPdf.new.pdf_from_string(
        render_to_string(pdf: 'quote',
                         margin: { bottom: 32 },
                         template: 'leads/quote.html.slim',
                         locals: { lead: @lead },
                         footer:  { html: { template:'layouts/_footer.html.slim'}})
      )
  end
end
