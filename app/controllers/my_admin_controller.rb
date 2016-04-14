class MyAdminController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  include MessageManager

  before_action :authenticate_user!
  before_action :validate_authorization

  layout "admin"

  def orders
    orders_scope = Order.all
    orders_scope = Order.search(params[:filter]) if params[:filter]
    @orders = smart_listing_create(:orders, orders_scope, partial: "orders/listing", default_sort: { created_at: "desc"} )
    respond_to do |format|
      format.html
      format.js
    end
  end

  def orders_show
    @order = Order.find(params[:id])
  end

  def classes
    events_scope = Event.all.joins(:course)
    events_scope = Event.custom_search(params[:filter]) if params[:filter]
    events_scope = events_scope.with_students if params[:with_students] == "1"
    @events = smart_listing_create(:events,
                                   events_scope,
                                   partial: "events/listing",
                                   sort_attributes: [[:id, "id"],
                                                     [:status, "status"],
                                                     [:course, "courses.abbreviation"],
                                                     [:start_date, "start_date"],
                                                     [:start_time, "start_time"],
                                                     [:end_time, "end_time"],
                                                     [:format, "format"],
                                                     [:lab_source, "lab_source"],
                                                     [:guaranteed, "guaranteed"]],
                                   default_sort: { start_date: "asc"} )
    respond_to do |format|
      format.html
      format.js
    end
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
    users_scope = User.all
    users_scope = User.search(params[:filter]) if params[:filter]
    @users = smart_listing_create(:users, users_scope, partial: "users/listing", default_sort: { last_name: "asc"} )
    respond_to do |format|
     format.html
     format.js
   end
  end

  def website
    @static_pages      = Page.where(static: true).order(:title)
    @dynamic_pages     = Page.where(static: false).order(:title)
    @articles          = Article.order(created_at: :desc)
    @testimonials      = Testimonial.page(1).per(5)
    @image_store_units = ImageStoreUnit.order(created_at: :desc)
  end

  private

  def validate_authorization
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
