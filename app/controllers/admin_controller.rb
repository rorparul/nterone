class AdminController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  include MessageManager

  before_action :authenticate_user!
  before_action :validate_authorization

  layout "admin"

  def queue
    if current_user.sales_manager? || current_user.admin?
      @sales_force      = Role.where(role: [2, 3])
      @assigned_leads   = Lead.where(status: 'assigned').where.not(seller_id: [nil, 0], buyer_id: nil).order(created_at: :asc)
      @unassigned_leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).where.not(buyer_id: nil).order(created_at: :asc)
      @archived_leads   = Lead.where(status: 'archived').where.not(buyer_id: nil).order(created_at: :desc)
    elsif current_user.sales_rep?
      @assigned_leads   = Lead.where(status: 'assigned', seller_id: current_user.id).where.not(buyer_id: nil).order(created_at: :asc)
      @unassigned_leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).where.not(buyer_id: nil).order(created_at: :asc)
      @archived_leads   = Lead.where(seller_id: current_user.id, status: 'archived').where.not(buyer_id: nil).order(created_at: :desc)
    end
  end

  def orders
    orders_scope = Order.all
    orders_scope = Order.custom_search(params[:filter]) if params[:filter]
    @orders = smart_listing_create(:orders, orders_scope, partial: "orders/listing", default_sort: { "orders.created_at": "desc"})

    respond_to do |format|
      format.html
      format.js
    end
  end

  def orders_show
    @order = Order.find(params[:id])
  end

  def classes
    events_scope = params[:including_past] == "1" ? Event.joins(:course) : Event.joins(:course).upcoming_events
    events_scope = events_scope.with_students                  if params[:only_registered] == "1" || params[:only_registered].blank?
    events_scope = events_scope.custom_search(params[:filter]) if params[:filter]

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
                                                     [:public, "public"],
                                                     [:guaranteed, "guaranteed"],
                                                     [:status, "Status"]],
                                   default_sort: { start_date: "asc"} )

    if should_group_classes?
      @grouped_events = @events.group_by(&:week_range)
      @range = Event.all.group_by(&:week_range)
      for i in 0..@grouped_events.length
        for j in 0..@range.length
          if @grouped_events[i][0] == @range[j][0]
            puts
            puts "True True True"
            puts
          end
        end
      end
    end

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
    # users_scope = params[:including_team] == "1" ? User.all : User.only_students
    users_scope = User.all
    users_scope = users_scope.search(params[:filter]) if params[:filter]

    @users = smart_listing_create(:users, users_scope,
      partial: "users/listing",
      default_sort: {last_name: "asc"}
    )

    respond_to do |format|
      format.html
      format.js
    end
  end

  def website
    @static_pages      = Page.where(static: true).order(:title)
    @dynamic_pages     = Page.where(static: false).order(:title)
    @companies         = Company.order(:title)
    @lab_courses       = LabCourse.order(:title)
    @articles          = Article.order(created_at: :desc)
    @testimonials      = Testimonial.page(1).per(5)
    @image_store_units = ImageStoreUnit.order(created_at: :desc)
  end

  private

  def validate_authorization
    unless current_user.admin? || current_user.sales?
      redirect_to root_path
    end
  end

  def should_group_classes?
    params.dig(:events_smart_listing, :sort, :start_date).present? ||
    params.dig(:events_smart_listing, :sort, 'events.start_date').present? ||
    params.dig(:events_smart_listing, :sort).blank?
  end
end
