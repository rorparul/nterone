class LabRentalsController < ApplicationController

	def new

	end

	def create
		lab_rental = LabRental.new(lab_rental_params)
		if lab_rental.save
			redirect_to admin_lab_rentals_path
		else
			render 'new'
		end
	end

	private

	def lab_rental_params
    params.require(:lab_rental).permit(:course_id,
                                 :first_day,
                                 :num_of_students,
                                 :start_time,
                                 :instructor,
                                 :instructor_email,
                                 :instructor_phone,
                                 :notes,
                                 :location,
                                 :confirmed)
  end
end