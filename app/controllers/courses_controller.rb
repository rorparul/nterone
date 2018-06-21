class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :download]
  before_action :set_course, only: [:clone_form, :clone]

  def page
    @courses = Course.order(:title).page(params[:page])
  end

  def new
    @platform = Platform.find(params[:platform_id])
    @course   = @platform.courses.new
    set_categories
    @course.build_image
  end

  def show
    @platform = Platform.find(params[:platform_id])
    authorize @course = Course.find(params[:id])
  end

  def create
    @platform = Platform.find(params[:platform_id])
    @course   = @platform.courses.build(course_params)
    set_categories

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
    set_categories

    @course.build_image
  end

  def select_to_edit
    @platform   = Platform.find(params[:platform_id])
    set_categories

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
    set_categories
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
      set_categories

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
    if pdf.url.present?
      redirect_to pdf.url
    else
      redirect_to root_path
    end
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
    @courses = Course.active.order(:abbreviation)

    respond_to do |format|
      format.xlsx do
        render xlsx: 'export', filename: 'nterone-courses.xlsx'
      end
      format.csv do
        send_data CSV::ExportCourseService.new(@courses).to_csv, filename: 'nterone-courses.csv'
      end
    end
  end

  def pluck
    @course = Course.find_by(id: params[:course_id])
  end

  private

  def course_params
    params.require(:course).permit(
      :abbreviation,
      :active,
      :archived,
      :book_cost_per_student,
      :cisco_id,
      :featured_course_summary,
      :heading,
      :id,
      :intended_audience,
      :intro,
      :origin_region,
      :outline,
      :overview,
      :page_description,
      :page_title,
      :partner_led,
      :pdf,
      :price,
      :satellite_viewable,
      :sku,
      :slug,
      :title,
      :video_preview,
      :exclude_from_revenue,
      active_regions: [],
      category_ids: [])
  end

  def set_course
    @course = Course.friendly.find(params[:id])
  end

  def set_categories
    categories  = Category.current_region.active.select { |category| category if category.parent }
    @categories = categories.sort_by { |category| [category.platform.title, category.parent.title, category.title] }
  end
end
