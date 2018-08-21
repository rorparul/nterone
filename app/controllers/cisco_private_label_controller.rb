class CiscoPrivateLabelController < ApplicationController
  include CiscoPrivateLabel

  before_action :authorize_user
  before_action :set_order, only: [:cpl_orders_post, :cpl_orders_cancel, :cpl_enrollments_post]

  def cpl_log
    @log = JSON.parse(cpl_get_log.body)
  end

  def cpl_orders
    @orders = JSON.parse(cpl_get_orders.body)
  end

  def cpl_orders_post
    cpl_post_orders(@order)
    redirect_to cpl_log_path
  end

  def cpl_orders_cancel
    @order ||= Order.new(id: params[:order_id])

    cpl_post_orders_cancel(@order)
    redirect_to cpl_log_path
  end

  def cpl_enrollments
    @enrollments = JSON.parse(cpl_get_enrollments.body)
  end

  def cpl_enrollments_post
    cpl_post_enrollments(@order)
    redirect_to cpl_log_path
  end

  private

  def authorize_user
    redirect_to root_path unless current_user.admin?
  end

  def set_order
    @order = Order.find_by(id: params[:order_id])
  end
end
