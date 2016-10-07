class LabReservationMailerPreview < ActionMailer::Preview
  def create_reservation
    user = User.first
    user_email = user.email
    reservation = LabRental.first
    LabReservationMailer.create_reservation(user, reservation)
  end

  def update_reservation
    user = User.first
    user_email = user.email
    reservation = LabRental.first
    LabReservationMailer.update_reservation(user, reservation)
  end

  def destroy_reservation
    user = User.first
    user_email = user.email
    reservation = LabRental.first
    LabReservationMailer.destroy_reservation(user, reservation)
  end
end
