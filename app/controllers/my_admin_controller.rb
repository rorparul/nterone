class MyAdminController < ApplicationController
  def classes
    @events = Event.order(:start_date)
  end

  def messages
    @messages = Message.active(current_user)
  end

  def announcements
    @announcements = Announcement.order('created_at DESC')
  end

  def people
    @users      = User.order(:last_name).page(params[:page])
  end

  def website
    @pages          = Page.order(:title)
    @carousel_items = CarouselItem.page(1)
    @testimonials   = Testimonial.page(1)
  end

  def settings
    @user = current_user
  end
end
