class LabReservationMailerPreview < ActionMailer::Preview
  def create_reservation
    user = User.first
    user_email = user.email
    reservation = LabRental.first
    LabReservationMailer.create_reservation(user, reservation)
  end
end
