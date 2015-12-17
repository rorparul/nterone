class MyAdminController < ApplicationController
  def overview

  end

  def people
    # unless params[:filter] == 'archived'


    # @users = User.all.order(:last_name)
    @users = User.order(:last_name).page(params[:page])
    @user_count = User.count


      # @archived_users_count = User.where(archived: true).count
    # else
    #   @filter      = 'archived'
    #   @users       = User.where(archived: true).order(created_at: :asc)
    #   @users_count = @users.count
    # end
  end

  def website
    @carousel_items = CarouselItem.page(1).per(5)
    @testimonials   = Testimonial.page(1).per(5)
  end
end
