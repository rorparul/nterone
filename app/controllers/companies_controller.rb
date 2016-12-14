class CompaniesController < ApplicationController
	include SmartListing::Helper::ControllerExtensions
	helper  SmartListing::Helper

	before_action :set_company,   only: [:show, :edit, :update, :destroy]
	before_action :set_companies, only: [:index, :new, :edit]
	before_action :set_owners,    only: [:new, :edit]

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
		users_scope = @company.users
		users_scope = users_scope.custom_search(params[:filter]) if params[:filter]

		@users = smart_listing_create(
			:users,
			users_scope,
			partial: 'users/listing',
			default_sort: { last_name: 'asc' }
		)

		respond_to do |format|
			format.html
			format.js { render 'users/index' }
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

  def company_params
    params.require(:company).permit(
			:city,
			:form_type,
			:industry_code,
			:kind,
			:parent_id,
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
