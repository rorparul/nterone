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
    events_scope = events_scope.where(company: current_user.company.title) if current_user.partner?
    events_scope = events_scope.with_students                              if params[:only_registered] == "1" || params[:only_registered].blank?
    events_scope = events_scope.custom_search(params[:filter])             if params[:filter]

    @queried_events = events_scope

    @events = smart_listing_create(:events,
                                   events_scope,
                                   partial: "events/listing",
                                   sort_attributes: [[:start_date, "start_date"],
                                                     [:course, "courses.abbreviation"],
                                                     [:id, "id"],
                                                     [:status, "status"],
                                                     [:resell, "Resell"],
                                                     [:start_time, "start_time"],
                                                     [:end_time, "end_time"],
                                                     [:format, "format"],
                                                     [:lab_source, "lab_source"],
                                                     [:public, "public"],
                                                     [:guaranteed, "guaranteed"],
                                                     [:status, "Status"]],
                                   default_sort: { start_date: "asc", course: "asc" })

    if should_group_classes?
      @grouped_events = @events.group_by(&:week_range)
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
    users_scope = User.all
    users_scope = users_scope.where(company: current_user.company) if current_user.partner?
    users_scope = users_scope.search(params[:filter])              if params[:filter]

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
    respond_to do |format|
      format.html do
        list_articles
        list_companies
        list_lab_courses
        list_pages_dynamic
        list_pages_static
        list_testimonials
        list_promotions
      end

      format.js do
        name = params.keys.first.chomp("_smart_listing")
        symbol = "list_#{name}".to_sym
        self.send(symbol)
        @list = name.to_sym
      end
    end
  end

  private

  def validate_authorization
    unless current_user.admin? || current_user.sales? || current_user.partner?
      redirect_to root_path
    end
  end

  def should_group_classes?
    params.dig(:events_smart_listing, :sort, :start_date).present? ||
    params.dig(:events_smart_listing, :sort, 'events.start_date').present? ||
    params.dig(:events_smart_listing, :sort).blank?
  end

  def list_articles
    @articles = smart_listing_create(:articles,
                                     Article.all,
                                     partial: "articles/listing",
                                     sort_attributes: [[:created_at, "created_at"],
                                                       [:kind, "kind"],
                                                       [:title, "title"]],
                                     default_sort: { created_at: "asc" })
  end

  def list_companies
    @companies = smart_listing_create(:companies,
                                      Company.all,
                                      partial: "companies/listing",
                                      default_sort: { title: "asc" })
  end

  def list_lab_courses
    @lab_courses = smart_listing_create(:lab_courses,
                                        LabCourse.all,
                                        partial: "lab_courses/listing",
                                        default_sort: { title: "asc" })
  end

  def list_pages_static
    @static_pages = smart_listing_create(:pages_static,
                                         Page.where(static: true),
                                         partial: "pages/listing_static",
                                         sort_attributes: [[:title, "title"]],
                                         default_sort: { title: "asc" })
  end

  def list_pages_dynamic
    @dynamic_pages = smart_listing_create(:pages_dynamic,
                                          Page.where(static: false),
                                          partial: "pages/listing_dynamic",
                                          sort_attributes: [[:title, "title"]],
                                          default_sort: { title: "asc" })
  end

  def list_promotions
    @promotions = smart_listing_create(:promotions,
                                      Discount.joins(:discount_filter),
                                      partial: "discounts/listing",
                                      sort_attributes: [
                                        [:code, "code"],
                                        [:value, "value"],
                                        [:kind, "kind"],
                                        [:date_start, "date_start"],
                                        [:date_end, "date_end"],
                                        [:active, "active"]
                                        ],
                                        default_sort: { date_start: "asc" })
  end

  def list_testimonials
    @testimonials = smart_listing_create(:testimonials,
                                         Testimonial.all,
                                         partial: "testimonials/listing",
                                         sort_attributes: [[:company, "company"],
                                                           [:created_at, "created_at"],
                                                           [:author, "author"]],
                                         default_sort: { created_at: "asc" })
  end
end
