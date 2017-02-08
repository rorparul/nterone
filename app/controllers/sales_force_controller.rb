class SalesForceController < ApplicationController
  before_action :authorize_user

  def form
    @types = ["Companies", "Contacts", "Leads", "Opportunities"]
  end

  def upload
    if params[:upload][:file] == nil
      flash[:alert] = "Please upload a file!"
      return redirect_to :back
    end
    @file = params[:upload][:file]
    @type = params[:upload][:type]
    if @type == "Companies" || "Contacts"|| "Leads" || "Opportunities"
      upload = SalesForceUploader.upload(@file, @type)
    else
      flash[:alert] = "File type not valid!"
    end
    redirect_to :back
  end

  private

  def authorize_user
    return redirect_to root_path unless current_user.admin?
  end

end
