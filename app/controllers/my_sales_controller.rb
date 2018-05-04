class MySalesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_authorization

  def classes
    @events = Event.order(guaranteed: :desc, start_date: :asc).page(params[:page])
  end

  def classes_show
    @event = Event.find(params[:id])
  end

  def queue
    if current_user.sales_manager?
      @sales_force      = Role.where(role: 3)
      @assigned_leads   = Lead.where(status: 'assigned').where.not(seller_id: [nil, 0], buyer_id: nil).order(created_at: :asc)
      @unassigned_leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).where.not(buyer_id: nil).order(created_at: :asc)
      @archived_leads   = Lead.where(status: 'archived').where.not(buyer_id: nil).order(created_at: :desc)
    elsif current_user.sales_rep?
      @assigned_leads   = Lead.where(status: 'assigned', seller_id: current_user.id).where.not(buyer_id: nil).order(created_at: :asc)
      @unassigned_leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).where.not(buyer_id: nil).order(created_at: :asc)
      @archived_leads   = Lead.where(seller_id: current_user.id, status: 'archived').where.not(buyer_id: nil).order(created_at: :desc)
    end
  end
  
  private

  def validate_authorization
    unless current_user.sales?
      redirect_to root_path
    end
  end
end
