class Admin::InstructorsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  include SmartListingConcerns

  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index]

  # layout 'admin'

  def index
    @instructors = User.all_instructors
    if params[:instructors_smart_listing].present? and params[:instructors_smart_listing][:sort].present?
      @instructors = @instructors.unscope(:order) 
    end
    unless request.format.json?
      @instructors = @instructors.custom_search(params[:filter]) if params[:filter].present?
      prepare_smart_listing(@instructors)
    end
    respond_to do |format|
      format.html
      format.js
      format.json do
        render json: @instructors 
      end
    end
  end

  private
  
  def prepare_smart_listing(users_scope)
    smart_listing_create(
      :instructors,
      users_scope,
      partial: 'listing',
      sort_attributes: [[:first_name, "first_name"],
                        [:last_name, "last_name"],
                        [:email, "email"]
                      ],
      default_sort: { updated_at: 'desc' }
    )
  end
  
  def authorize_admin
    current_user.admin?
  end
end
