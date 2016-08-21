class LabReservationMailer < ApplicationMailer
  def new_reservation(user, reservation)
    @user        = user
    @reservation = reservation

    mail(
      to: @user.email,
      bcc: 'techsupport@nterone.com',
      subject: "Lab Reservation Request",
      template_path: 'lab_rentals/mailers'
    )
  end
end
