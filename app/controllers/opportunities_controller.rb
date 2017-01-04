class OpportunitiesController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_opportunity,  only: [:show, :edit, :update, :destroy, :copy]
  before_action :set_associations, only: [:new, :edit, :copy]

  layout 'admin'

  def index
    opportunities_scope = Opportunity.all
    opportunities_scope = opportunities_scope.custom_search(params[:filter]) if params[:filter]

    smart_listing_create(
      :opportunities,
      opportunities_scope,
      partial: 'opportunities/listing',
      sort_attributes: [[:created_at, 'opportunities.created_at']],
      default_sort: { created_at: 'desc' }
    )
  end

  # def show
  #   users_scope = @company.users
  #   users_scope = users_scope.custom_search(params[:filter]) if params[:filter]
  #
  #   @users = smart_listing_create(
  #     :users,
  #     users_scope,
  #     partial: 'users/listing',
  #     default_sort: { last_name: 'asc' }
  #   )
  #
  #   respond_to do |format|
  #     format.html
  #     format.js { render 'users/index' }
  #   end
  # end

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
    render 'shared/new'
  end

  private

  def set_opportunity
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
      :event_id,
      :kind,
      :partner_id,
      :payment_kind,
      :reason_for_loss,
      :stage,
      :title
    )
  end
end
