class JobApplicantsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper SmartListing::Helper

  before_action :authenticate_user!, except: [:new, :create]
  before_action :validate_authorization, only: [:index, :show]

  def index
    applicants_scope = JobApplicant.all
    applicants_scope = applicants_scope.custom_search(params[:filter]) if params[:filter].present?
    @job_applicants = smart_listing_create(
      :applicants,
      applicants_scope,
      partial: "job_applicants/contact",
      page_sizes: [100, 50, 10],
      sort_attributes: [[:email, "email"],
                        [:first_name, "first_name"],
                         [:last_name, "last_name"],
                        ],
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
    @page = Page.current_region.find_by(title: 'Employment Opportunity')
    @contact = JobApplicant.new(contact_info_params)
    if (params["g-recaptcha-response"].present? && verify_recaptcha)
      if @contact.save
        flash[:success] = "Job Application successfully created."
        redirect_to employment_opportunity_path
      else
        flash[:notice] = "Job Applicantion Failed"
        render "general/employment_opportunity"
      end     
    else
      flash[:notice] = "Job Applicantion Failed"
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
      unless current_user.admin?
        redirect_to root_path
      end
    end 

end
