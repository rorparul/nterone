class OpportunitiesController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_opportunity,   only: [:show, :edit, :update, :destroy]
  before_action :set_companies,     only: [:new, :edit]
  before_action :set_owners,        only: [:new, :edit]
  before_action :set_contacts,      only: [:new, :edit]

  layout 'admin'

  def index
    opportunities_scope = Opportunity.all
    opportunities_scope = companies_scope.custom_search(params[:filter]) if params[:filter]

    smart_listing_create(
      :companies,
      opportunities_scope,
      partial: 'opportunities/listing',
      default_sort: { title: 'asc' }
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

  private

  def set_opportunity
    @company = Opportunity.find(params[:id])
  end

  def set_companies
    @companies = Company.all
  end

  def set_owners
    @owners = User.all_sales
  end

  def set_contacts
    @owners = User.contacts
  end

  def opportunity_params
    params.require(:opportunity).permit(
      :amount,
      :company,
      :customer_id,
      :employee_id,
      :kind,
      :reason_for_loss,
      :stage,
      :title
    )
  end
end
