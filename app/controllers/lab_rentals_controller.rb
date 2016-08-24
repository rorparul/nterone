class LabRentalsController < ApplicationController
	include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_user!, :verify_company

	def new
		@lab_rental = LabRental.new
	end

	def create
		@lab_rental = LabRental.new(lab_rental_params)
		if @lab_rental.save
			LabReservationMailer.new_reservation(current_user, @lab_rental).deliver_now
			redirect_to lab_rentals_path
		else
			render 'new'
		end
	end

	def index
		lab_rentals_scope  = current_user.admin? ? LabRental.joins(:company).all : current_user.company.lab_rentals
		lab_rentals_scope  = LabRental.custom_search(params[:filter]) if params[:filter]
		@lab_rentals       = smart_listing_create(
			:lab_rentals,
			lab_rentals_scope,
			partial: "lab_rentals/listing",
			sort_attributes: [[:course, "course"],
												[:company, "companies.title"],
												[:num_of_students, "num_of_students"],
												[:first_day, "first_day"],
												[:instructor, "instructor"],
												[:location, "location"],
											  [:confirmed, "confirmed"],
											  [:canceled, "canceled"]],
			default_sort: { "first_day": "desc" }
		)

		render layout: "admin" if current_user.admin?
	end

	def show
		if params[:only_note] == 'true'
			@note = LabRental.find(params[:id]).notes
		else
			render nothing: true
		end
	end

	private

	def verify_company
		redirect_to root_path if (!current_user.admin? && !current_user.company)
	end

	def lab_rental_params
    params.require(:lab_rental).permit(
			:user_id,
			:company_id,
			:course,
     	:first_day,
     	:num_of_students,
      :start_time,
     	:end_time,
     	:instructor,
     	:instructor_email,
     	:instructor_phone,
     	:notes,
     	:location,
     	:confirmed
		)
  end
end
