class InsightsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  layout "admin"

  def carts
    authorize :insight, :carts?
    carts_scope = Cart.includes(:order_items)

    @carts = smart_listing_create(:carts,
                                  carts_scope,
                                  partial: "carts/listing",
                                  sort_attributes: [
                                    [:created_at, "created_at"],
                                    [:updated_at, "updated_at"]
                                  ],
                                  default_sort: { created_at: "desc"})
    render 'admin/insights/carts'
  end
end
