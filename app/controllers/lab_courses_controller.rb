class LabCoursesController < ApplicationController
	include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

	before_action :set_lab_course, except: [:new, :create]
	before_action :authorize_lab_course, except: [:show, :time_select]

	def show
		@time_blocks			= @lab_course.lab_course_time_blocks.where(level: 'individual').order(:price)
		@time_zones				= [["United States Time Zones", ActiveSupport::TimeZone.us_zones.uniq],["All Time Zones", ActiveSupport::TimeZone.all.uniq]]
		@time_zone 				= Time.zone.name
		@date_start				= Date.today
		filter_times
	end

	def time_select
		@date_start			= params[:date_start]
		@time_blocks 		= @lab_course.lab_course_time_blocks.where(level: 'individual').order(:price)
		@time_zone			= params[:time_zone].split
		@time_zone.delete_at(0)
		@time_zone = @time_zone.join(" ")
		filter_times
	end

	def new
		@lab_course = LabCourse.new
		@lab_course.build_image
	end

	def edit
		@lab_course.build_image unless @lab_course.image.present?
	end

	def create
		@lab_course = LabCourse.new(lab_course_params)
		@lab_course.set_image(url_param: params['lab_course'], for: :image)
		if @lab_course.save
			flash[:success] = "Lab Course successfully created!"
      redirect_to admin_website_path
		else
			render 'new'
		end
	end

	def update
		@lab_course.set_image(url_param: params['lab_course'], for: :image)
		if @lab_course.update(lab_course_params)
			flash[:success] = "Lab Course successfully updated!"
			redirect_to :back
		else
			render 'edit'
		end
	end

  def destroy
    if @lab_course.destroy
      flash[:success] = "Lab Course successfully deleted!"
    else
      flash[:alert] = "Lab Course failed to delete!"
    end

    redirect_to :back
  end

	private

  def lab_course_params
    params.require(:lab_course).permit(
			:abbreviation,
			:card_description,
			:company_id,
			:description,
			:title,
			:level
		)
  end

	def set_lab_course
		@lab_course = LabCourse.friendly.find(params[:id])
	end

	def authorize_lab_course
		redirect_to root_url unless current_user.admin?
	end

	def filter_times
		@filtered_blocks = {}
		@time_blocks.each do |time_block|
			duration = time_block.unit_quantity
			determine_pods(time_block)
			build_time_starts
			lab_rentals = LabRental.where(first_day: (@date_start.to_datetime - 1)..(@date_start.to_datetime + 1), level: 'individual')
			@time_starts.each_with_index do |time_start, index|
				count = 0
				lab_rentals.each do |lab_rental|
					if OrderItem.where(orderable_type: 'LabRental', orderable_id: lab_rental.id).exists?
						lab_rental_start = (lab_rental.first_day.to_s + lab_rental.start_time.strftime(" %H:%M %z")).to_time
						lab_rental_end   = (lab_rental.last_day.to_s + lab_rental.end_time.strftime(" %H:%M %z")).to_time
						overlap = ( lab_rental_start.utc - (time_start.utc + duration * 60 * 60) ) * ( time_start.utc - lab_rental_end.utc )
						count += 1 if overlap > 0
					end
				end
				@time_starts[index] = nil if count >= @pods || @time_starts[index].utc < Time.now.utc + 2.hours
			end
			@time_starts.each do |time|
				puts time
			end
			@filtered_blocks[time_block] = @time_starts.reject {|time| time.nil?}
		end
		@time_blocks = @filtered_blocks
	end

	def build_time_starts
    @time_starts =* (0..23).map do |n|
      n = Time.mktime(
      @date_start.to_time.year,
      @date_start.to_time.month,
      @date_start.to_time.day,
      n,
      0)
      @time_zone == nil ? set_in_timezone(n, Time.now.zone) : set_in_timezone(n, @time_zone)
    end
  end

	def set_in_timezone(time, zone)
    ActiveSupport::TimeZone[zone].parse(time.asctime)
  end

	def determine_pods(time_block)
    @pods = 0
    @pods += Setting.pods[:available_pods_for_partners] if time_block.level == "partner"
    @pods += Setting.pods[:available_pods_for_individuals] if time_block.level == 'individual'
  end

end
