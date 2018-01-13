class Admin::SalesController < Admin::BaseController

  def overview
    if params[:date]
      year = params[:date][:year].to_i
      @selected_year = Date.new(year)
    else
      @selected_year = Date.today
    end

    @region_amounts = {}
    @region_percents = {}
    @region_goals = {}
    Event.origin_regions.each do |region, region_value|
      amount = Opportunity.unscoped.won.
        where(origin_region: region_value).
        where(date_closed: @selected_year.beginning_of_year..@selected_year.end_of_year).
        sum('amount')
      goal = SalesGoal.
        where(origin_region: region_value).
        where(month: @selected_year.beginning_of_year..@selected_year.end_of_year).
        sum(:amount)
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
