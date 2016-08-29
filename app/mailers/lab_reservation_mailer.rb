class LabReservationMailer < ApplicationMailer
  def create_reservation(user, reservation)
    @user        = user
    @reservation = reservation

    mail(
      to: @user.email,
      bcc: 'techsupport@nterone.com',
      subject: "Lab Reservation Request (##{@reservation.id})",
      template_path: 'lab_rentals/mailers',
      template_name: 'reservation'
    )
  end

  def update_reservation(user, reservation)
    @user        = user
    @reservation = reservation

    mail(
      to: @user.email,
      bcc: 'techsupport@nterone.com',
      subject: "Lab Reservation Modified (##{@reservation.id})",
      template_path: 'lab_rentals/mailers',
      template_name: 'reservation'
    )
  end
end
