class MySalesController < ApplicationController
  before_action :redirect_if_not_permitted

  def classes
    @events = Event.order(guaranteed: :desc, start_date: :asc)
  end

  def queue
    if current_user.sales_manager?
      @sales_force      = Role.where(role: 3)
      @assigned_leads   = Lead.where(status: 'assigned').where.not(seller_id: [nil, 0]).order(created_at: :asc)
      @unassigned_leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).order(created_at: :asc)
      @archived_leads   = Lead.where(status: 'archived').order(created_at: :desc)
    elsif current_user.sales_rep?
      @assigned_leads   = Lead.where(status: 'assigned', seller_id: current_user.id).order(created_at: :asc)
      @unassigned_leads = Lead.where(status: 'unassigned', seller_id: [nil, 0]).order(created_at: :asc)
      @archived_leads   = Lead.where(seller_id: current_user.id, status: 'archived').order(created_at: :desc)
    end
  end

  def messages
    @messages = Message.active(current_user)
  end

  def announcements
    @announcements = Announcement.where(poster: 'Sales Manager').order('created_at DESC')
  end

  def settings
    @user = current_user
  end

  private

  def redirect_if_not_permitted
    redirect_to root_path if !user_signed_in? || !current_user.sales?
  end
end
