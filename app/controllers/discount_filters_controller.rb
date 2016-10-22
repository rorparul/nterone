class DiscountFiltersController < ApplicationController

  def new
    @discount_filter = DiscountFilter.new
  end

  def create
    @discount_filter = DiscountFilter.new(discount_filter_params)
    if @discount_filter.save
      redirect_to '/admin/website'
    else
      render 'new'
    end
  end

  def edit
    @discount_filter = DiscountFilter.find(params[:id])
  end

  def update
    @discount_filter = DiscountFilter.find(params[:id])
    if @discount_filter.update_attributes(discount_filter_params)
      redirect_to '/admin/website'
    else
      render 'new'
    end
  end

  private
    def discount_filter_params
      params.require(:discount_filter).permit(
                                        :discount_id,
                                        :event,
                                        :event_city,
                                        :event_course_id,
                                        :event_format,
                                        :event_language,
                                        :event_partner_led,
                                        :event_state,
                                        :event_guaranteed,
                                        :id,
                                        :vod,
                                        :vod_lms,
                                        :vod_partner_led,
                                        :vod_platform_id
                                        )

end
