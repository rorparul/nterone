class Admin::SalesController < Admin::BaseController
  def overview
    @yearly = true

    if params[:date] && params[:date][:year]
      @year = params[:date][:year].to_i
      @selected_date = Date.new(@year)
    else
      @selected_date = Date.today
    end

    if params[:date] && params[:date][:month]
      @yearly = false
      @month = params[:date][:month].to_i
      @selected_date = Date.new(@year, @month)
    end
    set_region_details
  end

  def top_five_courses
    if params[:course_id].present?
      course = Course.find(params[:course_id])
      if course.exclude_from_revenue
        course.update_attributes(exclude_from_revenue: false)
      else
        course.update_attributes(exclude_from_revenue: true)
      end
    end
    dates = date_range(params[:yearly], params[:date])
    @selected_date = dates[:start]
    
    if params[:yearly] == "true"
      @yearly = true
    else
      @yearly = false
    end
    @date_range_start = dates[:start]
    @date_range_end   = dates[:end]

    @top_five_courses_by_region = {}

    @top_five_courses_by_region['all_regions'] = Course.top_courses_by_revenue(
      nil,
      @date_range_start, 
      @date_range_end
    )

    if params[:show_exclude_from_revenue].present?
      @top_five_courses_by_region['all_regions'] = @top_five_courses_by_region['all_regions'].first(5)
    else
      @top_five_courses_by_region['all_regions'] = @top_five_courses_by_region['all_regions'].select{|course| course.exclude_from_revenue == false}.first(5)
    end
    
    set_region_details if params[:show_exclude_from_revenue].present? || params[:course_id].present? || params[:hide_excluded].present?

    Event.origin_regions.each do |region, region_value|
      @top_five_courses_by_region[region] = Course.top_courses_by_revenue(
        region_value,
        @date_range_start,
        @date_range_end
      )

      if params[:show_exclude_from_revenue].present?
        @top_five_courses_by_region[region] = @top_five_courses_by_region[region].first(5)
      else
        @top_five_courses_by_region[region] = @top_five_courses_by_region[region].select{|course| course.exclude_from_revenue == false}.first(5)
      end
    end

    @margin_by_region = {}
    events = nil
    if params[:show_exclude_from_revenue].present?
      events = Event.all
    else
      events = Event.joins(:course).where("courses.exclude_from_revenue = ?", false)
    end
    
    @margin_by_region['all_regions'] = events.average_margin(
      nil,
      @date_range_start,
      @date_range_end
    )

    Event.origin_regions.each do |region, region_value|
      @margin_by_region[region] = events.average_margin(
        region_value,
        @date_range_start,
        @date_range_end
      )
    end
  end


  def details
    if params[:report]
      @started_at = parse_date_select(report_params, :started_at)
      @ended_at = parse_date_select(report_params, :ended_at)
    end

    @started_at ||= Date.today.beginning_of_month
    @ended_at ||= Date.today.end_of_month

    opportunities_scope = Opportunity.where(date_closed: @started_at..@ended_at)

    if params[:report]
      @status = params[:report][:status]
      opportunities_scope = opportunities_scope.pending if @status == "open"
      opportunities_scope = opportunities_scope.waiting if @status == "waiting"
      opportunities_scope = opportunities_scope.won     if @status == "won"
    end
    @status ||= "open"

    @opportunities_filtered_sum = opportunities_scope.sum('amount')

    smart_listing_create(
      :opportunities,
      opportunities_scope,
      partial: 'admin/sales/listing',
      # sort_attributes: [
      #   [:created_at, 'opportunities.created_at'],
      #   [:stage, 'stage'],
      #   [:waiting, 'waiting'],
      #   [:date_closed, 'date_closed'],
      #   [:amount, 'amount']
      # ],
      default_sort: { date_closed: 'desc' }
    )
  end

  private

  def report_params
    params.require(:report)
  end

  def date_range(yearly, date)
    date_query = Date.parse(date)
    date_today = Date.today

    if true?(yearly)
      if date_query.all_year.include?(date_today)
        {start: date_query.beginning_of_year, end: date_today}
      else
        {start: date_query.beginning_of_year, end: date_query.end_of_year}
      end
    else
      if date_query.all_month.include?(date_today)
        {start: date_query.beginning_of_month, end: date_today}
      else
        {start: date_query.beginning_of_month, end: date_query.end_of_month}
      end
    end
  end

  def set_region_details
    @region_amounts = {}
    @region_percents = {}
    @region_goals = {} 
    
    if params[:show_exclude_from_revenue].present? || params[:course_id].present?
      @selected_date = Date.today
      @yearly = true
    end
    
    Event.origin_regions.each do |region, region_value|
      amount_scope = Opportunity.unscoped.won.where(origin_region: region_value)

      if @yearly
        amount_scope = amount_scope.where(date_closed: @selected_date.beginning_of_year..@selected_date.end_of_year)
      else
        amount_scope = amount_scope.where(date_closed: @selected_date.beginning_of_month..@selected_date.end_of_month)
      end
      
      if params[:show_exclude_from_revenue].present?
        amount = amount_scope.sum(:amount)
      else
        amount = amount_scope.includes(:course).where("courses.exclude_from_revenue = ? or opportunities.course_id IS NULL", false).references(:courses).sum(:amount)
      end
    
      goal_scope = SalesGoal.where(origin_region: region_value)

      if @yearly
        goal_scope = goal_scope.where(month: @selected_date.beginning_of_year..@selected_date.end_of_year)
      else
        goal_scope = goal_scope.where(month: @selected_date.beginning_of_month..@selected_date.end_of_month)
      end

      goal = goal_scope.sum(:amount)

      @region_percents[region_value] = goal.to_i > 0 ? (amount / goal * 100).round : 100
      @region_amounts[region_value] = amount
      @region_goals[region_value] = goal.to_i
    end

    @total_amount = @region_amounts.values.sum
    @total_goal = @region_goals.values.sum
    @total_percent = @total_goal.to_i > 0 ? (@total_amount / @total_goal * 100).round : 100
  end
end
