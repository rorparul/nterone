class LabRentalsController < ApplicationController
	include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  # before_action :authenticate_user!

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

	def index
		if !current_user
			redirect_to new_user_session_path
		elsif current_user && !self.has_company?
			redirect_to root_path
		else
			render 'index'
		end
	end

	def destroy
		LabRental.find(params[:id]).destroy
		redirect_to admin_lab_rentals_path
	end

	protected

	def has_company?
		if current_user
			current_user.company ? true : false
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
