class OrderMailer < ApplicationMailer
  def confirmation_internal(user, order)
    @tld   = Rails.application.config.tld
    @user  = user
    @order = order

    attachments['nterone_receipt.pdf'] = generate_pdf_receipt(@order)

    mail(
      to: @user.email,
      bcc: [
        "sales@nterone.#{@tld}",
        "helpdesk@nterone.#{@tld}",
        "billing@nterone.#{@tld}"
      ],
      subject: "NterOne.#{@tld} Order Confirmation",
      template_name: 'confirmation'
    )
  end

  def confirmation_external(user, order, m360 = nil)
    @tld   = Rails.application.config.tld
    @m360  = m360
    @user  = user
    @order = order

    attachments['nterone_receipt.pdf'] = generate_pdf_receipt(@order)

    mail(
      to: [
        'stephanie.pouse@madwiremedia.com',
        {
          ca: 'marketing360+m10780@bcc.mad360.net',
          com: 'marketing360+m9874@bcc.mad360.net',
          local: 'marketing360+m10794@bcc.mad360.net'
        }[@tld.to_sym]
      ],
      subject: "NterOne.#{@tld} Order Confirmation",
      template_name: 'confirmation'
    )
  end

  def generate_pdf_receipt(order)
    WickedPdf.new.pdf_from_string(
      render_to_string(
        pdf: 'NterOne Receipt',
        margin: { bottom: 32 },
        template: 'orders/receipt.html.slim',
        locals: { order: order },
        footer:  { html: { template: 'layouts/_footer.html.slim' } }
      )
    )
  end

  def lab_rental_notification(user, order_pods)
    @user = user
    @pods = order_pods

    mail(
      to: ['helpdesk@nterone.com', 'techsupport@nterone.com'],
      subject: 'POD Rental'
    )
  end

  def you_have_left_order_items cart
    @cart = cart
    @user = cart.try(:user)

    if @cart && @user
      mail(
        to: @user.email,
        subject: t('.subject')
      )
    end
  end
end
