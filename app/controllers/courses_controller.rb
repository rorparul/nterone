class CoursesController < ApplicationController
  def new
    @platform   = Platform.find(params[:platform_id])
    @course     = Course.new
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end
  end

  def show
    @platform = Platform.find(params[:platform_id])
    @course   = Course.find(params[:id])
  end

  def create
    @platform   = Platform.find(params[:platform_id])
    @course     = @platform.courses.build(course_params)
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end
    if @course.save
      flash[:success] = 'Course successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def select
    @platform = Platform.find(params[:platform_id])
    @course   = @platform.courses.build
    @courses  = Course.where(platform_id: @platform.id)
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end
  end

  def select_to_edit
    if course_params[:id] == 'none'
      redirect_to select_platform_courses_path(Platform.find(params[:platform_id]))
    else
      @platform   = Platform.find(params[:platform_id])
      @course     = Course.find(course_params[:id])
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
    end
  end

  def update
    @course = Course.find(params[:id])
    @course.assign_attributes(course_params)
    if @course.save
      flash[:success] = 'Course successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      @platform   = Platform.find(params[:platform_id])
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
      render 'select_to_edit'
    end
  end

  def destroy
    course = Course.find(params[:id])
    if course.destroy
      flash[:success] = 'Course successfully deleted!'
    else
      flash[:alert] = 'Course unsuccessfully deleted!'
    end
    redirect_to :back
  end

  def download
    course = Course.find(params[:id])
    pdf = course.pdf
    send_file(pdf.current_path,
              filename: "#{course.abbreviation}.pdf",
              type: "application/pdf")
  end

  private

  def course_params
    params.require(:course).permit(:id,
                                   :title,
                                   :price,
                                   :active,
                                   :abbreviation,
                                   :sku,
                                   :intro,
                                   :overview,
                                   :outline,
                                   :intended_audience,
                                   :pdf,
                                   :video_preview,
                                   :bootsy_image_gallery_id,
                                   category_ids: [])
  end
end
