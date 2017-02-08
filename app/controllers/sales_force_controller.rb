class SalesForceController < ApplicationController
  before_action :authorize_user

  def form
    "/giphy"
  end

  def upload
    return redirect_to :back unless params[:upload]
    @contacts = params[:upload][:contacts]
    @leads    = params[:upload][:leads]
    @tasks    = params[:upload][:tasks]
    if @contacts.nil? || @leads.nil? || @tasks.nil?
      flash[:alert] = "One or more files missing!!!"
    else
      SalesForceUploader.upload(@contacts, @leads, @tasks)
    end
    redirect_to :back
  end

  private

  def authorize_user
    return redirect_to root_path unless current_user.admin?
  end

end
