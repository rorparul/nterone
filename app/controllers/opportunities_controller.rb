class OpportunitiesController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_opportunity,  only: [:show, :edit, :update, :destroy, :copy]
  before_action :set_associations, only: [:new, :edit, :copy]

  layout 'admin'

  def index
    start_date = params[:start_date]
    end_date   = params[:end_date]

    if current_user.admin? || current_user.sales_manager?
      @owners = User.all_sales

      unless params[:filter_user].present?
        @amount_open           = Opportunity.amount_open
        @amount_waiting        = Opportunity.amount_waiting
        @amount_won_mtd        = Opportunity.amount_won_mtd
        @amount_won_last_month = Opportunity.amount_won_last_month
        @amount_won_ytd        = Opportunity.amount_won_ytd
        @amount_won_last_year  = Opportunity.amount_won_last_year

        opportunities_scope = Opportunity.pending if params[:selection] == 'open' || params[:selection].nil?
        opportunities_scope = Opportunity.waiting if params[:selection] == 'waiting'
        opportunities_scope = Opportunity.closed  if params[:selection] == 'closed'
      else
        sales_rep = User.find(params[:filter_user])

        @amount_open           = sales_rep.opportunities.amount_open
        @amount_waiting        = sales_rep.opportunities.amount_waiting
        @amount_won_mtd        = sales_rep.opportunities.amount_won_mtd
        @amount_won_last_month = sales_rep.opportunities.amount_won_last_month
        @amount_won_ytd        = sales_rep.opportunities.amount_won_ytd
        @amount_won_last_year  = sales_rep.opportunities.amount_won_last_year

        opportunities_scope = sales_rep.opportunities.pending if params[:selection] == 'open' || params[:selection].nil?
        opportunities_scope = sales_rep.opportunities.waiting if params[:selection] == 'waiting'
        opportunities_scope = sales_rep.opportunities.closed  if params[:selection] == 'closed'
      end
    else
      @amount_open           = current_user.opportunities.amount_open
      @amount_waiting        = current_user.opportunities.amount_waiting
      @amount_won_mtd        = current_user.opportunities.amount_won_mtd
      @amount_won_last_month = current_user.opportunities.amount_won_last_month
      @amount_won_ytd        = current_user.opportunities.amount_won_ytd
      @amount_won_last_year  = current_user.opportunities.amount_won_last_year

      opportunities_scope = current_user.opportunities.pending if params[:selection] == 'open' || params[:selection].nil?
      opportunities_scope = current_user.opportunities.waiting if params[:selection] == 'waiting'
      opportunities_scope = current_user.opportunities.closed  if params[:selection] == 'closed'
    end

    if params[:selection] == 'closed'
      if params[:date_start].present? && params[:date_end].present?
        opportunities_scope  = opportunities_scope.where(date_closed: params[:date_start]..params[:date_end])
      elsif params[:date_start].present?
        opportunities_scope  = opportunities_scope.where("date_closed >= '#{params[:date_start]}'")
      elsif params[:date_end].present?
        opportunities_scope  = opportunities_scope.where("date_closed <= '#{params[:date_end]}'")
      end
    end

    opportunities_scope = opportunities_scope.custom_search(params[:filter]) if params[:filter]

    smart_listing_create(
      :opportunities,
      opportunities_scope,
      partial: 'opportunities/listing',
      sort_attributes: [
        [:created_at, 'opportunities.created_at'],
        [:stage, 'stage'],
        [:waiting, 'waiting']
      ],
      default_sort: { created_at: 'desc' }
    )
  end

  def show
  end

  def new
    @opportunity = Opportunity.new
    render 'shared/new'
  end

  def edit
    render 'shared/edit'
  end

  def create
    @opportunity = Opportunity.new(opportunity_params)
    if @opportunity.save
      flash[:success] = 'Opportunity successfully created.'
      redirect_to :back
    else
      render 'shared/new'
    end
  end

  def update
    if @opportunity.update(opportunity_params)
      flash[:success] = 'Opportunity successfully updated.'
      redirect_to :back
    else
      render 'shared/edit'
    end
  end

  def destroy
    if @opportunity.destroy
      flash[:success] = 'Opportunity successfully deleted.'
    else
      flash[:alert] = 'Company failed to delete!'
    end
    redirect_to :back
  end

  def copy
    @opportunity = @opportunity.dup
    @opportunity.stage = 10
    render 'shared/new'
  end

  def export_popup
    if current_user.admin? || current_user.sales_manager?
      @owners = User.all_sales
      @all_users = User.all
    else
      @owners = []
      @all_users = []
    end
    render 'shared/action_modal'
  end

  def export
    if current_user.admin? || current_user.sales_manager?
      if params[:filter][:user].present?
        opportunities_scope = User.find(params[:filter][:user]).opportunities
      else
        opportunities_scope = Opportunity
      end
    else
      opportunities_scope = current_user.opportunities
    end

    opportunities_scope = opportunities_scope.pending if params[:filter][:stage] == 'Open'
    opportunities_scope = opportunities_scope.waiting if params[:filter][:stage] == 'Waiting'
    if params[:filter][:stage] == 'Closed'
      opportunities_scope = opportunities_scope.closed

      if params[:filter][:date_start].present? && params[:filter][:date_end].present?
        opportunities_scope  = opportunities_scope.where(date_closed: params[:filter][:date_start]..params[:filter][:date_end])
      elsif params[:filter][:date_start].present?
        opportunities_scope  = opportunities_scope.where("date_closed >= '#{params[:filter][:date_start]}'")
      elsif params[:filter][:date_end].present?
        opportunities_scope  = opportunities_scope.where("date_closed <= '#{params[:filter][:date_end]}'")
      end
    end

    opportunities_scope = opportunities_scope.where(account_id: params[:filter][:account])  if params[:filter][:account].present?
    opportunities_scope = opportunities_scope.where(partner_id: params[:filter][:partner])  if params[:filter][:partner].present?
    opportunities_scope = opportunities_scope.where(employee_id: params[:filter][:employee])  if params[:filter][:employee].present?
    opportunities_scope = opportunities_scope.where(customer_id: params[:filter][:customer])  if params[:filter][:customer].present?
    opportunities_scope = opportunities_scope.where(course_id: params[:filter][:course])  if params[:filter][:course].present?

    @opportunities = opportunities_scope.all
  end

  private

  def set_opportunity
    if current_user.admin? || current_user.sales_manager?
    else
    end
    @opportunity = Opportunity.find(params[:id])
  end

  def set_associations
    @companies = Company.order('lower(title)')
    @courses   = Course.includes(:platform).order('platforms.title', 'lower(abbreviation)')
    @partners  = Company.partners.order('lower(title)')
    @owners    = User.all_sales
    @contacts  = User.contacts
  end

  def opportunity_params
    params.require(:opportunity).permit(
      :account_id,
      :amount,
      :billing_city,
      :billing_state,
      :billing_street,
      :billing_zip_code,
      :course_id,
      :customer_id,
      :employee_id,
      :email_optional,
      :event_id,
      :kind,
      :notes,
      :partner_id,
      :payment_kind,
      :reason_for_loss,
      :stage,
      :title
    )
  end
end
