class TestimonialsController < ApplicationController
  before_action :authenticate_user!,    except: :index
  before_action :set_testimonial,       except: [:index, :new, :create, :page]
  before_action :authorize_testimonial, only: [:new, :create, :edit, :update, :destroy]

  def index
    @page         = Page.find_by(title: 'Testimonials')
    @testimonials = Testimonial.all
  end

  def page
    @testimonials = Testimonial.page(params[:page]).per(5)
  end

  def new
    @testimonial = Testimonial.new
    @courses     = Course.all.order('lower(title)')
  end

  def create
    @testimonial = Testimonial.new(testimonial_params)
    if @testimonial.save
      flash[:success] = 'Testimonial successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      @courses = Course.all.order('lower(title)')
      render :new
    end
  end

  def edit
    @courses = Course.all.order('lower(title)')
  end

  def update
    if @testimonial.update_attributes(testimonial_params)
      flash[:success] = 'Testimonial successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      @courses = Course.all.order('lower(title)')
      render :edit
    end
  end

  def destroy
    if @testimonial.destroy
      flash[:success] = 'Testimonial successfully updated!'
    else
      flash[:alert] = 'Testimonial unsuccessfully updated!'
    end
    redirect_to :back
  end

  private

  def testimonial_params
    params.require(:testimonial).permit(:quotation, :author, :company, :course)
  end

  def set_testimonial
    @testimonial = Testimonial.find(params[:id])
  end

  def authorize_testimonial
    @testimonial ||= Testimonial.new
    authorize @testimonial
  end
end
