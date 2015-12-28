class TestimonialsController < ApplicationController
  before_action :set_testimonial, except: [:index, :new, :create, :page]

  def index
    @testimonials = Testimonial.all
  end

  def page
    @testimonials = Testimonial.page(params[:page])
  end

  def new
    @testimonial = Testimonial.new
    @courses     = Course.all.order('lower(title)')
  end

  def create
    @testimonial = Testimonial.new(testimonial_params)
    if @testimonial.save
      flash[:success] = "Testimonial successfully created!"
      redirect_to :back
    else
      flash[:alert] = "Testimonial unsuccessfully created!"
      render :new
    end
  end

  def edit
    @courses = Course.all.order('lower(title)')
  end

  def update
    if @testimonial.update_attributes(testimonial_params)
      flash[:success] = "Testimonial successfully updated!"
      redirect_to :back
    else
      flash[:alert] = "Testimonial unsuccessfully updated!"
      render :new
    end
  end

  private

  def testimonial_params
    params.require(:testimonial).permit(:quotation, :author, :company, :course)
  end

  def set_testimonial
    @testimonial = Testimonial.find(params[:id])
  end
end
