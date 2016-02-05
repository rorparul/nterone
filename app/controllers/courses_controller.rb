class CoursesController < ApplicationController
  def new
    @platform   = Platform.find(params[:platform_id])
    @course     = Course.new
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end
    @course.build_image
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
    @course.set_image(url_param: params['course'], for: :image)
    if @course.save
      flash[:success] = 'Course successfully created!'
      # render js: "window.location = '#{request.referrer}';"
      redirect_to platform_path(@course.platform)
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
    @course.build_image
  end

  def select_to_edit
    @platform   = Platform.find(params[:platform_id])
    @categories = @platform.categories.order(:title).select do |category|
      category if category.parent
    end
    if course_params[:id] == 'none'
      @course   = @platform.courses.build
      @courses  = Course.where(platform_id: @platform.id)
    else
      @course     = Course.find(course_params[:id])
    end
    @course.build_image unless @course.image.present?
  end

  def edit
    @platform   = Platform.find(params[:platform_id])
    @categories = @platform.categories.order(:title).select do |category|
      category if category.parent
    end
    @course     = Course.find(params[:id])
    @course.build_image unless @course.image.present?
  end

  def update
    @course = Course.find(params[:id])
    @course.assign_attributes(course_params)
    @course.set_image(url_param: params['course'], for: :image)
    if @course.save
      flash[:success] = 'Course successfully updated!'
      # render js: "window.location = '#{request.referrer}';"
      redirect_to platform_path(@course.platform)
    else
      @platform   = Platform.find(params[:platform_id])
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
      # render 'select_to_edit'
      render "edit"
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
