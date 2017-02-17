class SalesForceController < ApplicationController
  before_action :authorize_user

  def form_for_other
    @types = ["Companies", "Contacts", "Leads", "Opportunities"]
  end

  def upload_other
    if params[:upload][:file] == nil
      flash[:alert] = "Please upload a file!"
      return redirect_to :back
    end
    @file = params[:upload][:file]
    @type = params[:upload][:type]
    if @type == "Companies" || "Contacts"|| "Leads" || "Opportunities"
      upload = SalesForceUploader.upload_other(@file, @type)
    else
      flash[:alert] = "File type not valid!"
    end
    redirect_to :back
  end

  def form_for_tasks
    "/giphy"
  end

  def upload_tasks
    return redirect_to :back unless params[:upload]
    @contacts = params[:upload][:contacts]
    @leads    = params[:upload][:leads]
    @users    = params[:upload][:users]
    @tasks    = params[:upload][:tasks]
    if @contacts.nil? || @leads.nil? || @users.nil? || @tasks.nil?
      flash[:alert] = "One or more files missing!!!"
    else
      upload = SalesForceUploader.upload_tasks(@contacts, @leads, @users, @tasks)
    end
    redirect_to :back
  end

  private

  def authorize_user
    return redirect_to root_path unless current_user.admin?
  end

end
