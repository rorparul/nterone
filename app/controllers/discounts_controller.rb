class DiscountsController < ApplicationController

  def new
    @discount         = Discount.new
  end

  def create
    @discount           = Discount.new(discount_params)
    if @discount.save
      flash[:success] = 'Discount successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def edit
    @discount         = Discount.find(params[:id])
  end

  def update
    @discount         = Discount.find(params[:id])
    if @discount.update_attributes(discount_params)
      flash[:success] = 'Discount successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  private
    def discount_params
      params.require(:discount).permit(
                                  :active,
                                  :code,
                                  :date_end,
                                  :date_start,
                                  :kind,
                                  :limit,
                                  :value,
                                  discount_filter_attributes: [
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
                                  ]
                                  )
    end
end
