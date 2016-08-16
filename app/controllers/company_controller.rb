class CompanyController < ApplicationController
	def new
		@company = Company.new
	end

	def edit
		@company = Company.find(params[:id])
	end

	def create
		@company = Company.new(company_params)
		if @company.save
			flash[:success] = "Article successfully created!"
      redirect_to admin_website_path
		else
			render 'new'
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
    params.require(:company).permit(:title)
  end
end
