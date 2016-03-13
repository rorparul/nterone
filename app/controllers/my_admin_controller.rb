class MyAdminController < ApplicationController
  include MessageManager

  before_action :authenticate_user!
  before_action :validate_authorization

  def orders
    @orders = Order.order(created_at: :desc)
  end

  def orders_show
    @order = Order.find(params[:id])
  end

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
    @users = User.order("LOWER(last_name)").page(params[:page])
  end

  def website
    @static_pages      = Page.where(static: true).order(:title)
    @dynamic_pages     = Page.where(static: false).order(:title)
    @articles          = Article.order(created_at: :desc)
    @testimonials      = Testimonial.page(1).per(5)
  end

  private

  def validate_authorization
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
