class MyAdminController < ApplicationController
  include MessageManager

  before_action :authenticate_user!
  before_action :validate_authorization

  def classes
    @events = Event.order(guaranteed: :desc, start_date: :asc).page(params[:page])
  end

  def classes_show
    @event = Event.find(params[:id])
  end

  def courses
    @courses = Course.order(:title).page(params[:page])
  end

  def messages
    @messages = Message.active(current_user)
    mark_messages_read(current_user)
    get_alert_counts
  end

  def announcements
    @announcements = Announcement.order('created_at DESC')
  end

  def people
    @users = User.order(:last_name).page(params[:page])
  end

  def website
    @pages             = Page.order(:title)
    @carousel_items    = CarouselItem.page(1).per(5)
    @testimonials      = Testimonial.page(1).per(5)
    @press_releases    = PressRelease.page(1).per(5)
    @blog_posts        = BlogPost.page(1).per(5)
    @industry_articles = IndustryArticle.page(1).per(5)
  end

  private

  def validate_authorization
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
