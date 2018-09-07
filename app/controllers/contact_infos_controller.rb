class ContactInfosController < ApplicationController
  include SmartListing::Helper::ControllerExtensions

  helper SmartListing::Helper

  before_action :authenticate_user! , except: [:new, :create]

  def index
    contacts = ContactInfo.all

    smart_listing_create(:contact_infos, contacts,
      partial: "contact_infos/contact",
      default_sort: { created_at: "desc" }
    )

    respond_to do |format|
      format.html
      format.js
    end
  end


  def new
    @contact = ContactInfo.new
  end
  

  def create
    @contact = ContactInfo.new(contact_info_params)
    if @contact.save
      flash[:success] = "Successfully Applied."
      redirect_to employment_opportunity_path
    else
      render :new
    end   
  end


  def show
    @conatct = ContactInfo.find(params["id"])
  end  


  private

    def contact_info_params
      params.require(:contact_info).permit(
        :first_name,
        :last_name,
        :email,
        :message,
        :resume_upload
      )
    end

  def validate_authorization
    unless current_user.admin? || current_user.sales?
      redirect_to root_path
    end
  end 

end
