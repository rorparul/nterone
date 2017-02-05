class OrderMailer < ApplicationMailer
  def confirmation(user, order)
    @user  = user
    @order = order
    mail(to: @user.email,
         bcc: ["sales#{I18n.t('email')}", "helpdesk#{I18n.t('email')}", "billing#{I18n.t('email')}", 'stephanie.pouse@madwiremedia.com', 'marketing360+m9874@bcc.mad360.net'],
         subject: 'NterOne.com Order Confirmation')
  end

  def lab_rental_confirmation(user, order)
    @user   = user
    @order  = order
    @order.order_items.each do |order_item|
      if order_item.orderable_type == 'LabRental' && order_item.orderable.level == 'individual'
        mail(to: ['helpdesk@nterone.com', 'techsupport@nterone.com'],
             subject: 'POD Rental')
        return
      end
    end
  end
end
