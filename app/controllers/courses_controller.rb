class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :download]
  before_action :set_course, only: [:clone_form, :clone]

  def page
    @courses = Course.order(:title).page(params[:page])
  end

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
      redirect_to session[:previous_request_url] || platform_course_path(@platform, @course)
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
      redirect_to edit_platform_course_path(@course.platform, @course)
    else
      @platform   = Platform.find(params[:platform_id])
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end

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
    redirect_to session[:previous_request_url]
  end

  def download
    course = Course.find(params[:id])
    pdf = course.pdf
    send_file(pdf.current_path,
              filename: "#{course.abbreviation}.pdf",
              type: "application/pdf")
  end

  def clone_form
  end

  def clone
    new_course = @course.dup
    new_course.slug = params[:course][:slug]
    new_course.categories << @course.categories.first

    if new_course.save
      flash[:success] = 'Course successfully cloned!'
    else
      flash[:alert] = 'Course unsuccessfully cloned!'
    end

    redirect_to session[:previous_request_url]
  end

  def export
    @courses = Course.order(:abbreviation)

    respond_to do |format|
      format.xlsx do
        render xlsx: 'export', filename: 'nterone-courses.xlsx'
      end
    end
  end

  private

  def course_params
    params.require(:course).permit(:id,
                                   :page_title,
                                   :page_description,
                                   :title,
                                   :slug,
                                   :price,
                                   :active,
                                   :abbreviation,
                                   :sku,
                                   :heading,
                                   :intro,
                                   :overview,
                                   :outline,
                                   :intended_audience,
                                   :pdf,
                                   :video_preview,
                                   :partner_led,
                                   :satellite_viewable,
                                   category_ids: [])
  end

  def set_course
    @course = Course.friendly.find(params[:id])
  end
end
