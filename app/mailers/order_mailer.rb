class OrderMailer < ApplicationMailer
  def confirmation(user, order, m360 = nil)
    @tld           = Rails.application.config.tld
    @m360          = m360
    @user          = user
    @order         = order
    @mad360_emails = {
      ca: 'marketing360+m10780@bcc.mad360.net',
      com: 'marketing360+m9874@bcc.mad360.net',
      la: 'marketing360+m10794@bcc.mad360.net'
    }

    attachments['nterone_receipt.pdf'] = WickedPdf.new.pdf_from_string(
      render_to_string(
        pdf: 'NterOne Receipt',
        margin: { bottom: 32 },
        template: 'orders/receipt.html.slim',
        locals: { order: @order },
        footer:  { html: { template: 'layouts/_footer.html.slim' } }
      )
    )

    deliver_internal.deliver
    deliver_external
  end

  def deliver_internal
    @destination = 'internal'

    mail(
      to: @user.email,
      bcc: [
        "sales@nterone.#{@tld}",
        "helpdesk@nterone.#{@tld}",
        "billing@nterone.#{@tld}"
      ],
      subject: "NterOne.#{@tld} Order Confirmation"
    )
  end

  def deliver_external
    @destination = 'external'

    mail(
      to: [
        'stephanie.pouse@madwiremedia.com',
        @mad360_emails[@tld.to_sym]
      ],
      subject: "NterOne.#{@tld} Order Confirmation"
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
