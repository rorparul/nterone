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

end
