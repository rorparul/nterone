class InsightsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  layout "admin"

  def carts
    authorize :insight, :carts?
    carts_scope = params[:including_empty] == "1" ? Cart.includes(:order_items) : Cart.joins(:order_items)
    # carts_scope = carts_scope.search_without_items(params[:filter]) if params[:filter]
    # if params[:including_empty] == "1"
    #   carts_scope = Cart.includes(:order_items)
    #   carts_scope = carts_scope.search_without_items(params[:filter]) if params[:filter]
    # else
    #   carts_scope = Cart.joins(:order_items)
    #   carts_scope = carts_scope.search_with_items(params[:filter]) if params[:filter]
    # end

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
