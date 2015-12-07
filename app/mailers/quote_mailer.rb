class QuoteMailer < ApplicationMailer
  def pdf_attachment(brand, lead)
    @lead = lead
    @brand = brand
    mail(to: @lead.buyer.email, subject: "Please see attached PDF for your #{brand.title} quote.")
      .attachments["quote.pdf"] = WickedPdf.new.pdf_from_string(
        render_to_string(pdf: 'quote',
                         margin: { bottom: 32 },
                         template: 'leads/quote.html.slim',
                         locals: { brand: brand, lead: @lead },
                         footer:  { html: { template:'layouts/_footer.html.slim'}})
      )
  end
end
