class LabCoursesController < ApplicationController
	include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

	before_action :set_lab_course, except: [:new, :create]
	before_action :authorize_lab_course, except: [:show]

	def show
		@time_blocks	= @lab_course.lab_course_time_blocks.where(level: 'individual').order(:price)
	end

	def new
		@lab_course = LabCourse.new
	end

	def edit
	end

	def create
		@lab_course = LabCourse.new(lab_course_params)

		if @lab_course.save
			flash[:success] = "Lab Course successfully created!"
      redirect_to admin_website_path
		else
			render 'new'
		end
	end

	def update
		if @lab_course.update(lab_course_params)
			flash[:success] = "Lab Course successfully created!"
			redirect_to admin_website_path
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
		:title)
  end

	def set_lab_course
		@lab_course = LabCourse.friendly.find(params[:id])
	end

	def authorize_lab_course
		redirect_to root_url unless current_user.admin?
	end
end
