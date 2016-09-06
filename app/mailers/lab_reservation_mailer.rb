class LabReservationMailer < ApplicationMailer
  def create_reservation(user, reservation)
    @user        = user
    user_email   = user.email if user
    @reservation = reservation

    if user_email
      mail(
        to: user_email,
        bcc: 'techsupport@nterone.com',
        subject: "Lab Reservation Requested (##{@reservation.id})",
        template_path: 'lab_rentals/mailers',
        template_name: 'reservation'
      )
    else
      mail(
        bcc: 'techsupport@nterone.com',
        subject: "Lab Reservation Requested (##{@reservation.id})",
        template_path: 'lab_rentals/mailers',
        template_name: 'reservation'
      )
    end

    if @reservation.lab_students.any?
      @reservation.lab_students.each do |lab_student|
        @lab_student = lab_student

        mail(
          to: lab_student.email,
          subject: "Lab Reservation Requested (##{@reservation.id})",
          template_path: 'lab_rentals/mailers',
          template_name: 'reservation_for_student'
        )
      end
    end
  end

  def update_reservation(user, reservation)
    @user        = user
    user_email   = user.email if user
    @reservation = reservation

    if user_email
      mail(
        to: user_email,
        bcc: 'techsupport@nterone.com',
        subject: "Lab Reservation Modified (##{@reservation.id})",
        template_path: 'lab_rentals/mailers',
        template_name: 'reservation'
      )
    else
      mail(
        bcc: 'techsupport@nterone.com',
        subject: "Lab Reservation Modified (##{@reservation.id})",
        template_path: 'lab_rentals/mailers',
        template_name: 'reservation'
      )
    end

    if @reservation.lab_students.any?
      @reservation.lab_students.each do |lab_student|
        @lab_student = lab_student

        mail(
          to: lab_student.email,
          subject: "Lab Reservation Modified (##{@reservation.id})",
          template_path: 'lab_rentals/mailers',
          template_name: 'reservation_for_student'
        )
      end
    end
  end

  def destroy_reservation(user, reservation)
    @user        = user
    user_email   = user.email if user
    @reservation = reservation

    if user_email
      mail(
        to: @user.email,
        bcc: 'techsupport@nterone.com',
        subject: "Lab Reservation Canceled (##{@reservation.id})",
        template_path: 'lab_rentals/mailers',
        template_name: 'reservation'
      )
    else
      mail(
        to: user_email,
        bcc: 'techsupport@nterone.com',
        subject: "Lab Reservation Canceled (##{@reservation.id})",
        template_path: 'lab_rentals/mailers',
        template_name: 'reservation'
      )
    end

    if @reservation.lab_students.any?
      @reservation.lab_students.each do |lab_student|
        @lab_student = lab_student
        
        mail(
          to: lab_student.email,
          subject: "Lab Reservation Canceled (##{@reservation.id})",
          template_path: 'lab_rentals/mailers',
          template_name: 'reservation_for_student'
        )
      end
    end
  end
end
