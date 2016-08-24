class LabCoursesController < ApplicationController
	def new
		@lab_course = LabCourse.new
	end

	def edit
		@lab_course = LabCourse.find(params[:id])
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
		@lab_course = LabCourse.find(params[:id])

		if @lab_course.update(lab_course_params)
			flash[:success] = "Lab Course successfully created!"
			redirect_to admin_website_path
		else
			render 'edit'
		end
	end

  def destroy
  	@lab_course = LabCourse.find(params[:id])

    if @lab_course.destroy
      flash[:success] = "Lab Course successfully deleted!"
    else
      flash[:alert] = "Lab Course failed to delete!"
    end

    redirect_to :back
  end

	private

  def lab_course_params
    params.require(:lab_course).permit(:title)
  end
end
