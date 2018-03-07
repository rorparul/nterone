class DiscountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discount, only: [:edit, :update]
  before_action :authorize_discount

  def new
    @discount = Discount.new
    @discount.build_discount_filter
  end

  def create
    @discount = Discount.new(discount_params)

    if @discount.save
      flash[:success] = 'Promotion successfully created.'
      redirect_to :back
    else
      flash[:alert] = 'Promotion failed to create.'
      redirect_to :back
    end
  end

  def edit
  end

  def update
    if @discount.update_attributes(discount_params)
      flash[:success] = 'Promotion successfully updated.'
      redirect_to :back
    else
      flash[:alert] = 'Promotion failed to update.'
      redirect_to :back
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
      :origin_region,
      :value,
      active_regions: [],
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
        :vod,
        :vod_lms,
        :vod_partner_led,
        :vod_platform_id
      ]
    )
  end

  def set_discount
    @discount = Discount.find(params[:id])
  end

  def authorize_discount
    @discount ||= Discount.new
		authorize @discount
  end
end
