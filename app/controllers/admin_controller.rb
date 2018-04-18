class AdminController < ApplicationController
  include CiscoPrivateLabel
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  include SmartListingConcerns
  include MessageManager

  before_action :authenticate_user!
  before_action :authorize_admin

  layout 'admin'

  def become
    sign_in(:user, User.find(params[:id]), { bypass: true })
    redirect_to root_url
  end

  def orders
    orders_scope = Order.all
    orders_scope = orders_scope.custom_search(params[:filter]) if params[:filter]
    smart_listing_create(:orders,
                         orders_scope,
                         partial: "orders/listing",
                         sort_attributes: [[:id, "orders.id"],
                                           [:status_position, "status_position"],
                                           [:total, "total"],
                                           [:paid, "paid"],
                                           [:balance, "balance"],
                                           [:source, "source"],
                                           [:auth_code, "auth_code"],
                                           [:clc_quantity, "clc_quantity"],
                                           [:created_at, "orders.created_at"]],
                         default_sort: { id: "desc"})

    respond_to do |format|
      format.html
      format.js
    end
  end

  def orders_show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: 'NterOne Receipt',
          margin: { bottom: 32 },
          template: 'orders/receipt.html.slim',
          locals: { order: @order },
          footer:  { html: { template: 'layouts/_footer.html.slim' } }
        )
      end
    end
  end

  def classes
    cookies[:only_registered] = params[:only_registered] if params[:only_registered]
    cookies[:filter]          = params[:filter]          if params[:filter]

    @start_date = Date.parse params[:date_start].values.join("-") if params[:date_start]
    @end_date   = Date.parse params[:date_end].values.join("-")   if params[:date_end]

    @start_date = Date.parse params[:start] if params[:start]
    @end_date   = Date.parse params[:end]   if params[:end]
    
    # if params[:region]
    #   @region = params[:region]
    # end

    if params[:origin_region].present?
      @origin_region = params[:origin_region]
    end

    events_scope = (@start_date && @end_date) ? Event.unscoped.includes(:course).where(start_date: [@start_date..@end_date]) : Event.unscoped.includes(:course).upcoming_events
    # events_scope = events_scope.where("events.active_regions @> ?", "{#{@region}}")  if @region
    events_scope = events_scope.where(origin_region: @origin_region) if @origin_region

    events_scope = events_scope.with_students if cookies[:only_registered] == "1" || cookies[:only_registered].blank?
    events_scope = events_scope.custom_search(cookies[:filter]) if cookies[:filter]
    
    unless request.format.json?
      @start_date = events_scope.minimum("events.start_date")
      @end_date   = events_scope.maximum("events.start_date")

      @queried_events = events_scope
      
      @events = smart_listing_create(:events,
                                     events_scope,
                                     partial: "events/listing",
                                     page_sizes: [100, 50, 10],
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
    end  

    respond_to do |format|
      format.html
      format.js
      format.json do
        render json: events_scope.map{|event| {'title': event.title_with_instructor, 'start': event.start_date.strftime("%Y-%m-%d"), 'end': event.end_date.strftime("%Y-%m-%d")}}.to_json
      end
    end
  end

  def classes_show
    @event = Event.find(params[:id])
  end

  def courses
    @courses = Course.active.order(:title).page(params[:page])
  end

  def people
    users_scope = current_user.partner? ? users_scope.where(company: current_user.company) : User.all
    users_scope = users_scope.custom_search(params[:filter]) if params[:filter]

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
    manage_smart_listing(
      [
        'list_articles',
        'list_lab_courses',
        'list_pages_dynamic',
        'list_pages_static',
        'list_testimonials',
        'list_promotions'
      ]
    )
  end

  def tools
  end

  def cpl_log
    @log = JSON.parse(cpl_get_log.body)
  end

  private

  def authorize_admin
    authorize :admin
  end

  def should_group_classes?
    params.dig(:events_smart_listing, :sort, :start_date).present? ||
    params.dig(:events_smart_listing, :sort, 'events.start_date').present? ||
    params.dig(:events_smart_listing, :sort).blank?
  end

  def list_articles
    @articles = smart_listing_create(:articles,
                                     Article.unscoped.all,
                                     partial: "articles/listing",
                                     sort_attributes: [[:created_at, "created_at"],
                                                       [:kind, "kind"],
                                                       [:title, "title"]],
                                     default_sort: { created_at: "asc" })
  end

  def list_lab_courses
    @lab_courses = smart_listing_create(:lab_courses,
                                        LabCourse.all,
                                        partial: "lab_courses/listing",
                                        default_sort: { title: "asc" })
  end

  def list_pages_static
    @static_pages = smart_listing_create(:pages_static,
                                         Page.unscoped.where(static: true),
                                         partial: "pages/listing_static",
                                         sort_attributes: [[:title, "title"]],
                                         default_sort: { title: "asc" })
  end

  def list_pages_dynamic
    @dynamic_pages = smart_listing_create(:pages_dynamic,
                                          Page.unscoped.where(static: false),
                                          partial: "pages/listing_dynamic",
                                          sort_attributes: [[:title, "title"]],
                                          default_sort: { title: "asc" })
  end

  def list_promotions
    @promotions = smart_listing_create(:promotions,
                                       Discount.joins(:discount_filter),
                                       partial: "discounts/listing",
                                       sort_attributes: [[:code, "code"],
                                                         [:value, "value"],
                                                         [:kind, "kind"],
                                                         [:date_start, "date_start"],
                                                         [:date_end, "date_end"],
                                                         [:active, "active"]],
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
