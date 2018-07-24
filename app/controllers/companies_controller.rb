class CompaniesController < ApplicationController
	include SmartListing::Helper::ControllerExtensions
	helper  SmartListing::Helper

	before_action :set_company,       only: [:show, :edit, :update, :destroy, :merge]
	before_action :set_companies,     only: [:index, :new, :edit]
	before_action :set_owners,        only: [:new, :edit]
	before_action :authorize_company, except: [:pluck]

	# layout 'admin'

	def index
		respond_to do |format|
			format.html do
				companies_scope = @companies.where(user_id: current_user.id)
				smart_listing_create(:companies, companies_scope,
					partial: 'companies/listing',
					default_sort: {
						title: 'asc'
					}
				)
			end

			format.js do
				companies_scope = @companies
				companies_scope = companies_scope.where(clean_params(company_params[:filters]))  if params[:company]
				companies_scope = companies_scope.custom_search(params[:search]) if params[:search].present?
				smart_listing_create(:companies, companies_scope,
					partial: 'companies/listing',
					default_sort: {
						title: 'asc'
					}
				)
			end

			format.json do
        if params[:key] == 'state'
				  render json: { items: @companies.where("lower(state) like lower('%#{params[:q]}%')").pluck(:state).uniq }
				elsif params[:key] == 'zip_code'
					render json: { items: @companies.where("lower(zip_code) like lower('%#{params[:q]}%')").pluck(:zip_code).uniq }
        else
          render json: { items: @companies.custom_search(params[:q]).order(:title) }
        end
			end

			format.xlsx do
				@companies = @companies.where(clean_params(company_params[:filters]))
				@companies = @companies.custom_search(params[:search]) if params[:search].present?
				render xlsx: 'index', filename: "companies-#{DateTime.now}.xlsx"
			end
		end
	end

	def show
		@owners = User.all_sales

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

	def merge
	end

	def merge_companies
	  if params[:ids].any?
	    main_company    = Company.find(params[:id])
	    merge_companies = Company.find(params[:ids].select {|id| id != params[:id]})

	    merge_companies.each do |company|
	      company_id = company.id

	      ActiveRecord::Base.transaction do
					User.unscoped.where(company_id: company_id).update_all(company_id: main_company.id)
					LabRental.unscoped.where(company_id: company_id).update_all(company_id: main_company.id)
					LabCourse.unscoped.where(company_id: company_id).update_all(company_id: main_company.id)
					company.destroy
	      end
	    end

	    flash[:success] = "Companies successfully merged."
	  else
	    flash[:alert] = "Companies failed to merge!"
	  end
	  redirect_to action: :index
	end

	def create
		@company = Company.new(company_params)

		if @company.save
			flash[:success] = "Company successfully created."
      render js: "window.location = '#{request.referrer}';"
		else
			render 'shared/new'
		end
	end

	def update
		if @company.update(company_params)
			flash[:success] = "Company successfully updated."
			redirect_to :back
		else
			render 'edit'
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

	def mass_edit
	end

	def mass_update
		companies       = Company.where(clean_params(company_params[:filters]))
    companies       = companies.custom_search(params[:search]) if params[:search].present?
    companies_count = companies.count
    if companies.update_all(user_id:company_params[:user_id])
      flash[:success] = "Successfully updated #{companies_count} records."
    else
      flash[:alert] = "Failed to update #{companies_count} records."
    end

    render js: "window.location = '#{request.referrer}';"
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
	  user_ids = @company.children_and_self
	    .inject([]) {|res, company| res + company.users }
	    .map(&:id)
	  users = User.where(id: user_ids)

	  leads_scope = users.leads
		leads_scope = leads_scope.custom_search(params[:filter]) if params[:filter]

		@leads = smart_listing_create(
			:leads,
			leads_scope,
			partial: 'users/listing',
			default_sort: { created_at: 'desc' }
		)
	end

	def list_contacts
	  user_ids = @company.children_and_self
	    .inject([]) {|res, company| res + company.users }
	    .map(&:id)
	  users = User.where(id: user_ids)

		contacts_scope = users.contacts
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
		sales_rep  = (current_user.admin? || current_user.sales_manager?) ? User.find_by(id: params[:filter_user]) : current_user

		company_ids = @company.children_and_self.map(&:id)
		opportunities_scope = Opportunity.where(account_id: company_ids)
		opportunities_scope = opportunities_scope.where(employee_id: sales_rep.id) if sales_rep.present?
		opportunities_scope = opportunities_scope.pending if params[:selection] == 'open' || params[:selection].nil?
		opportunities_scope = opportunities_scope.waiting if params[:selection] == 'waiting'
		opportunities_scope = opportunities_scope.closed.where(date_closed: start_date..end_date) if params[:selection] == 'closed'

		opportunities_scope = opportunities_scope.custom_search(params[:filter]) if params[:filter]

		@opportunities_filtered_sum = opportunities_scope.sum(:amount)

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
			:zip_code,
			filters: [
				:parent_id,
				:user_id,
				:kind,
				:industry_code,
				:state,
				:zip_code
			]
		)
  end
end
