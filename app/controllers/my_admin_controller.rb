class MyAdminController < ApplicationController
  def overview

  end

  def announcements
    @announcements = Announcement.order('created_at DESC')
  end

  def people
    @users      = User.order(:last_name).page(params[:page])
    @user_count = User.count
  end

  def website
    @carousel_items = CarouselItem.page(1).per(5)
    @testimonials   = Testimonial.page(1).per(5)
  end

  def settings
    @user = current_user
  end
end
