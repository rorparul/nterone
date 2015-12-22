class InstructorsController < ApplicationController
  def new
    @platform   = Platform.find(params[:platform_id])
    @instructor = Instructor.new
  end

  def create
    @instructor = Platform.find(params[:platform_id]).instructors.build(instructor_params)
    if @instructor.save
      flash[:notice] = 'Instructor successfully created!'
      redirect_to :back
    else
      render 'new'
    end
  end

  def select
    @platform    = Platform.find(params[:platform_id])
    @instructor  = @platform.instructors.build
    @instructors = Instructor.where(platform_id: @platform.id)
  end

  def  select_to_edit
    if instructor_params[:id] == 'none'
      redirect_to select_platform_instructors_path(Platform.find(params[:platform_id]))
    else
      @platform   = Platform.find(params[:platform_id])
      @instructor = Instructor.find(instructor_params[:id])
    end
  end

  def update
    @instructor = Instructor.find(params[:id])
    if @instructor.update_attributes(instructor_params)
      flash[:notice] = 'Instructor successfully updated!'
      redirect_to :back
    else
      flash[:alert] = 'Instructor unsuccessfully updated!'
      render 'edit'
    end
  end

  def destroy
    instructor = Instructor.find(params[:id])
    if instructor.destroy
      flash[:notice] = 'Instructor successfully destroyed!'
    else
      flash[:alert] = 'Instructor unsuccessfully destroyed!'
    end
    redirect_to :back
  end

  private

  def instructor_params
    params.require(:instructor).permit(:id,
                                       :first_name,
                                       :last_name,
                                       :email,
                                       :phone,
                                       :biography)
  end
end
