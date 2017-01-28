class LabRentalsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_lab_rental, only: [:show, :edit, :update, :destroy]

  def index
    lab_rentals_scope  = current_user.admin? ? LabRental.includes(:company).all : LabRental.where(company_id: current_user.company_id)
    lab_rentals_scope  = lab_rentals_scope.custom_search(params[:filter])  if params[:filter]
    if params[:date_start].present? && params[:date_end].present?
      lab_rentals_scope  = lab_rentals_scope.where(first_day: params[:date_start]..params[:date_end])
    elsif params[:date_start].present?
      lab_rentals_scope  = lab_rentals_scope.where("first_day >= '#{params[:date_start]}'")
    elsif params[:date_end].present?
      lab_rentals_scope  = lab_rentals_scope.where("first_day <= '#{params[:date_end]}'")
    end
    lab_rentals_scope.each_with_index do |lab_rental, index|
      if lab_rental.level == 'individual'
        lab_rentals_scope[index] = nil unless OrderItem.where(orderable_type: 'LabRental', orderable_id: lab_rental.id, cart_id: nil).exists?
      end
    end
    lab_rentals_scope.to_a.compact!
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
			[:canceled, "canceled"],
			[:twenty_four_hours, "twenty_four_hours"]],
    default_sort: { "first_day": "desc" }
    )

    render layout: "admin" if current_user.admin?
  end

  def show
    if params[:show] == 'notes'
      @note = @lab_rental.notes
      render 'show_note'
    elsif params[:show] == 'students'
      @lab_students = @lab_rental.lab_students
      render 'show_lab_students'
    else
      render nothing: true
    end
  end

  def new
    company = Company.find_by(slug: params[:company_slug]) if params[:company_slug]
    company ||= Company.find_by(id: params[:company_id])   if params[:company_id]
    company ||= current_user.company                       if current_user && current_user.admin? == false
    kind    = company.try(:form_type) ? company.form_type : 1

    @lab_rental = LabRental.new(user_id: current_user.try(:id), company_id: company.try(:id), kind: kind)
    @lab_rental.lab_students.build if @lab_rental.kind == 2
  end

  def new_file
    @companies = Company.all.order(:title)
  end

  def upload
    return redirect_to root_path unless current_user && current_user.admin?
    if params[:lab_rental][:company].empty? || params[:lab_rental][:file].nil?
      flash[:alert] = "Failed to upload file! Please choose a company and select a file."
      return redirect_to :back
    else
      company = Company.find_by(title: params[:lab_rental][:company])
      upload = LabsUploader.upload(lab_rental_params[:file], company)
    end
    redirect_to :back
  end

  def create
    @lab_rental = LabRental.new(lab_rental_params)
    if @lab_rental.save
      flash[:success] = 'Lab Reservation successfully submitted!'
      LabReservationMailer.create_reservation(current_user, @lab_rental).deliver_now
      if user_signed_in? && (current_user.admin? || current_user.company)
	      redirect_to lab_rentals_path
      else
	      redirect_to :back
      end
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @lab_rental.assign_attributes(lab_rental_params)

    if @lab_rental.save
      flash[:success] = 'Lab Reservation successfully updated!'
      LabReservationMailer.update_reservation(current_user, @lab_rental).deliver_now
      redirect_to lab_rentals_path
    else
      render "edit"
    end
  end

  def destroy
    unless current_user.admin? == false && (@lab_rental.first_day - Date.today).to_i < 14
      @lab_rental.update(canceled: true)
      flash[:success] = 'Lab Reservation successfully canceled.'
      LabReservationMailer.destroy_reservation(current_user, @lab_rental).deliver_now
    else
      flash[:alert] = "Lab Reservations can't be canceled within 2 weeks of their start date."
    end
    redirect_to :back
  end

  def edit_pods
    return redirect_to root_url unless current_user.admin?
    prepare_pod_settings
    @pod_settings = Setting.pods
  end

  def update_pods
    return redirect_to root_url unless current_user.admin?
    if params[:available_pods_for_individuals].empty? || params[:available_pods_for_partners].empty?
      flash[:alert]     = "Failed to update settings. Data submitted was not a number."
    else
      Setting.pods      = {available_pods_for_individuals: params[:available_pods_for_individuals].to_i, available_pods_for_partners: params[:available_pods_for_partners].to_i}
      flash[:success]   = "Availability of pods currently set to #{Setting.pods[:available_pods_for_individuals]} for individuals, and #{Setting.pods[:available_pods_for_partners]} for partners."
    end
    redirect_to :back
  end

  def self_checkout
    return redirect_to new_user_registration_url unless user_signed_in?
    data        = params[:time_start].split
    @time_block = LabCourseTimeBlock.find(data[0])
    @time_zone  = params[:time_zone]
    @start_time = "#{data[1]} #{data[2]} #{data[3]}".to_time.in_time_zone(@time_zone)
    @end_time   = @start_time + 60 * 60 * @time_block.unit_quantity
    @first_day  = @start_time.to_date
    @last_day   = @end_time.to_date
    lab_rental  = LabRental.new(
      end_time: @end_time,
      first_day: @first_day,
      lab_course_id: @time_block.lab_course.id,
      last_day: @last_day,
      level: @time_block.level,
      notes: "Created through self checkout.",
      num_of_students: @time_block.ratio,
      start_time: @start_time,
      time_zone: @time_zone,
      user_id: current_user.id
    )

    if lab_rental.save
      order_item = OrderItem.new(
        orderable_type: "LabRental",
        orderable_id: lab_rental.id,
        cart_id: @cart.id,
        price: @time_block.price,
        user_id: current_user.id,
        note: "Created through self checkout."
      )
      if order_item.save
        flash[:success] = "Item successfully added to cart! Please go to #{view_context.link_to "My Cart", new_order_path} to complete transaction".html_safe
      else
        flash[:alert] = "Failed to add time block to cart!"
      end
    else
      flash[:alert] = "Failed to add time block to cart!"
    end
    redirect_to :back
  end

  private

  def set_lab_rental
    @lab_rental = LabRental.find(params[:id])
  end

  def verify_company
    redirect_to root_path if (!current_user.admin? && !current_user.company)
  end

  def prepare_pod_settings
    if Setting.pods.nil?
      Setting.pods = {
        available_pods_for_individuals: 0,
        available_pods_for_partners: 0
      }
    end
  end

  def lab_rental_params
    params.require(:lab_rental).permit(
      :user_id,
      :company_id,
      :lab_course_id,
      :first_day,
      :last_day,
      :num_of_students,
      :start_time,
      :end_time,
      :instructor,
      :instructor_email,
      :instructor_phone,
      :notes,
      :location,
      :confirmed,
      :kind,
      :time_zone,
      :twenty_four_hours,
      :file,
      :level,
      lab_students_attributes: [:id, :name, :email, :_destroy]
    )
  end
end
