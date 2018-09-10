class JobApplicantsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions

  helper SmartListing::Helper

  before_action :authenticate_user! , except: [:new, :create]

  def index
    contacts = JobApplicant.all

    smart_listing_create(:contact_infos, contacts,
      page_sizes: [10, 50, 100],
      sort_attributes: [[:email, "email"],
                        [:first_name, "first_name"],
                         [:last_name, "last_name"],
                        ],
      partial: "job_applicants/contact",
      default_sort: { created_at: "desc" }
    )

    respond_to do |format|
      format.html
      format.js
    end
  end


  def new
    @contact = JobApplicant.new
  end
  

  def create
    @contact = JobApplicant.new(contact_info_params)
    if @contact.save
      flash[:success] = "Job Application successfully created."
      redirect_to employment_opportunity_path
    else
      @page = Page.current_region.find_by(title: 'Employment Opportunity')
      render "general/employment_opportunity"
    end   
  end


  def show
    @conatct = JobApplicant.find(params["id"])
  end  


  private

    def contact_info_params
      params.require(:job_applicant).permit(
        :first_name,
        :last_name,
        :email,
        :message,
        :resume_upload,
        :phone
      )
    end

  def validate_authorization
    unless current_user.admin? || current_user.sales?
      redirect_to root_path
    end
  end 

end
