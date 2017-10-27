class Admin::SalesController < Admin::BaseController

  def overview
    if params[:date]
      month = params[:date][:month].to_i
      year = params[:date][:year].to_i
      @selected_month = Date.new(year, month)
    else
      @selected_month = Date.today
    end

    @total_amount = Opportunity.unscoped.
      where(date_closed: @selected_month.beginning_of_month..@selected_month.end_of_month).
      sum('amount')

    @region_amounts = {}
    @region_percents = {}
    Event.origin_regions.each do |region, region_value|
      amount = Opportunity.unscoped.
        where(origin_region: region_value).
        where(date_closed: @selected_month.beginning_of_month..@selected_month.end_of_month).
        sum('amount')
      @region_percents[region_value] = (amount / @total_amount * 100).round
      @region_amounts[region_value] = amount
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
      opportunities_scope = opportunities_scope.pending if params[:report][:status] == "open"
      opportunities_scope = opportunities_scope.waiting if params[:report][:status] == "waiting"
      opportunities_scope = opportunities_scope.won     if params[:report][:status] == "won"
    end

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
