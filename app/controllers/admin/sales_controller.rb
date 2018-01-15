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

    @region_amounts = {}
    @region_percents = {}
    @region_goals = {}

    Event.origin_regions.each do |region, region_value|
      amount_scope = Opportunity.unscoped.won.where(origin_region: region_value)

      if @yearly
        amount_scope = amount_scope.where(date_closed: @selected_date.beginning_of_year..@selected_date.end_of_year)
      else
        amount_scope = amount_scope.where(date_closed: @selected_date.beginning_of_month..@selected_date.end_of_month)
      end

      amount = amount_scope.sum(:amount)

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

end
