class CompaniesController < ApplicationController
	include SmartListing::Helper::ControllerExtensions
	helper  SmartListing::Helper

	before_action :set_company,       only: [:show, :edit, :update, :destroy]
	before_action :set_companies,     only: [:index, :new, :edit]
	before_action :set_owners,        only: [:new, :edit]
	before_action :authorize_company, except: [:pluck]

	layout 'admin'

	def index
		companies_scope = @companies
		companies_scope = companies_scope.custom_search(params[:filter]) if params[:filter]

		smart_listing_create(
			:companies,
			companies_scope,
			partial: 'companies/listing',
			default_sort: { title: 'asc' }
		)
	end

	def show
		respond_to do |format|
			format.html do
				list_leads
				list_contacts
				list_opportunities
			end

			format.js do
				keys        = params.keys
				listing_key = keys.find { |key| key =~ /_smart_listing/ }
				name        = listing_key.chomp("_smart_listing")
				symbol      = "list_#{name}".to_sym
				@list       = name.to_sym
				
				self.send(symbol)
			end
		end
	end

	def new
		@company = Company.new
		render 'shared/new'
	end

	def edit
		render 'shared/edit'
	end

	def create
		@company = Company.new(company_params)
		if @company.save
			flash[:success] = "Company successfully created."
      redirect_to :back
		else
			render 'shared/new'
		end
	end

	def update
		if @company.update(company_params)
			flash[:success] = "Company successfully updated."
			redirect_to :back
		else
			render 'shared/edit'
		end
	end

  def destroy
    if @company.destroy
      flash[:success] = "Company successfully deleted."
    else
      flash[:alert] = "Company failed to delete!"
    end
    redirect_to :back
  end

	def pluck
		@company = Company.find_by(id: params[:company_id])
	end

	private

	def set_company
		@company = Company.find(params[:id])
	end

	def set_companies
		@companies = Company.all
	end

	def set_owners
		@owners = User.all_sales
	end

	def authorize_company
		@company ||= Company.new
		authorize @company
	end

	def list_leads
		leads_scope = @company.users.leads
		leads_scope = leads_scope.custom_search(params[:filter]) if params[:filter]

		@leads = smart_listing_create(
			:leads,
			leads_scope,
			partial: 'users/listing',
			default_sort: { created_at: 'desc' }
		)
	end

	def list_contacts
		contacts_scope = @company.users.contacts
		contacts_scope = contacts_scope.custom_search(params[:filter]) if params[:filter]

		@contacts = smart_listing_create(
			:contacts,
			contacts_scope,
			partial: 'users/listing',
			default_sort: { last_name: 'asc' }
		)
	end

	def list_opportunities
		start_date = parse_date_select(params[:start_date], :start_date) if params[:start_date].present?
		end_date   = parse_date_select(params[:end_date], :end_date) if params[:end_date].present?

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
				opportunities_scope = Opportunity.closed.where(date_closed: start_date..end_date) if params[:selection] == 'closed'
			else
				sales_rep = User.find(params[:filter_user])

				@amount_open           = sales_rep.opportunities.amount_open
				@amount_waiting        = sales_rep.opportunities.amount_waiting
				@amount_won_mtd        = sales_rep.opportunities.amount_won_mtd
				@amount_won_last_month = sales_rep.opportunities.amount_won_last_month
				@amount_won_ytd        = sales_rep.opportunities.amount_won_ytd
				@amount_won_last_year  = sales_rep.opportunities.amount_won_last_year

				opportunities_scope = sales_rep.opportunities.pending if params[:selection] == 'open'
				opportunities_scope = sales_rep.opportunities.waiting if params[:selection] == 'waiting'
				opportunities_scope = sales_rep.opportunities.closed.where(date_closed: start_date..end_date) if params[:selection] == 'closed'
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
			opportunities_scope = current_user.opportunities.closed.where(date_closed: start_date..end_date) if params[:selection] == 'closed'
		end

		opportunities_scope = opportunities_scope.custom_search(params[:filter]) if params[:filter]

		@opportunities = smart_listing_create(
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

  def company_params
    params.require(:company).permit(
			:city,
			:form_type,
			:industry_code,
			:kind,
			:parent_id,
			:partner,
			:phone,
			:state,
			:street,
			:title,
			:user_id,
			:website,
			:zip_code
		)
  end
end
