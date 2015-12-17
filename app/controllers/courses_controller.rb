class CoursesController < ApplicationController
  autocomplete :course, :title, full: true, extra_data: [:url, :price]

  def return_all
    # render json: {apple: "Bingo!!!"}
  end

  def new
    @platform = Platform.find(params[:platform_id])
    @course   = Course.new
    @categories = Category.where(platform_id: @platform.id).select do |category|
      category if category.parent
    end
  end

  def show
    @platform = Platform.find(params[:platform_id])
    @course   = Course.find(params[:id])
  end

  def create
    @course = Platform.find(params[:platform_id]).courses.build(course_params)
    if @course.save
      flash[:success] = 'You have successfully created Course.'
      redirect_to platform_path(params[:platform_id])
    else
      render 'new'
    end
  end

  def select
    @platform = Platform.find(params[:platform_id])
    @course   = @platform.courses.build
    @courses  = Course.where(platform_id: @platform.id)
  end

  def  select_to_edit
    if course_params[:id] == 'none'
      redirect_to select_platform_courses_path(Platform.find(params[:platform_id]))
    else
      @platform = Platform.find(params[:platform_id])
      @course   = Course.find(course_params[:id])
    end
  end

  def update
    @course = Course.find(params[:id])
    @course.assign_attributes(course_params)
    if @course.save
      flash[:success] = 'You have successfully updated Course.'
      redirect_to platform_path(params[:platform_id])
    else
      render('edit')
    end
  end

  def destroy
    Course.find(params[:id]).destroy
    flash[:notice] = 'Course was successfully deleted.'
    redirect_to platform_path(params[:platform_id])
  end

  private

  def course_params
    params.require(:course).permit(:id,
                                   :title,
                                   :url,
                                   :price,
                                   :active,
                                   :abbreviation,
                                   :sku,
                                   :length,
                                   :intro,
                                   :overview,
                                   :outline,
                                   :intended_audience,
                                   category_ids: [])
  end
end
