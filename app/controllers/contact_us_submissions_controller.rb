class ContactUsSubmissionsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions

  helper  SmartListing::Helper

  before_action :authenticate_user!
  before_action :validate_authorization

  # layout 'admin'

  def index
    contact_us_submission_scope = ContactUsSubmission.all

    smart_listing_create(:contact_us_submissions, contact_us_submission_scope,
      partial: "contact_us_submissions/listing",
      default_sort: { created_at: "desc" }
    )

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @contact_us_submission = ContactUsSubmission.find(params[:id])
  end

  private

  def validate_authorization
    unless current_user.admin? || current_user.sales?
      redirect_to root_path
    end
  end
end
