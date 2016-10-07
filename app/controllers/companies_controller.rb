class CompaniesController < ApplicationController
	def new
		@company = Company.new
		@company.lab_courses.build
	end

	def edit
		@company = Company.find(params[:id])
	end

	def create
		@company = Company.new(company_params)
		if @company.save
			flash[:success] = "Company successfully created!"
      redirect_to admin_website_path
		else
			render 'new'
		end
	end

	def update
		@company = Company.find(params[:id])
		if @company.update(company_params)
			flash[:success] = "Company successfully created!"
			redirect_to admin_website_path
		else
			render 'edit'
		end
	end

  def destroy
  	@company = Company.find(params[:id])
    if @company.destroy
      flash[:success] = "Company successfully deleted!"
    else
      flash[:alert] = "Company failed to delete!"
    end
    redirect_to :back
  end

	private

  def company_params
    params.require(:company).permit(:title, :form_type)
  end
end
