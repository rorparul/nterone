class UsersController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :set_user, only: [:show, :show_as_lead, :show_as_contact, :edit, :edit_from_sales, :assign, :edit_from_my_queue, :update, :toggle_archived, :destroy]
  before_action :authorize_user, except: [:show, :toggle_archived]

  layout 'admin'

  def index
    users_scope = User.all
    users_scope = users_scope.custom_search(params[:filter]) if params[:filter]
    prepare_smart_listing(users_scope)
  end

  def show
    @planned_subjects = @user.planned_subjects.where(active: true)
    @user.planned_subjects.where(active: true).update_all(read: true)
    @my_plan_count = @user.new_my_plan_count
    @activities = PublicActivity::Activity.where("owner_id = ? OR recipient_id = ?", @user.id, @user.id).order(created_at: :desc)
  end

  def show_as_lead
  end

  def show_as_contact
  end

  def show_as_sales_rep
  end

  def edit
  end

  def edit_from_sales
    @owners    = User.all_sales
    @companies = Company.all
  end

  def assign
    @owners = User.all_sales
  end

  # def edit_from_my_queue
  # end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html do
          flash[:success] = 'User successfully updated!'
          redirect_to :back
        end
        format.js
      else
        format.html do
          flash[:alert] = 'User unsuccessfully updated!'
          redirect_to :back
        end
        format.js
      end
    end
  end

  def toggle_archived
    @user.toggle(:archived)
    if @user.save
      flash[:success] = "User successfully #{@user.archived ? 'archived' : 'unarchived'}!"
    else
      flash[:alert] = "User unsuccessfully #{@user.archived ? 'unarchived' : 'archived'}"
    end
    redirect_to :back
  end

  def destroy
    if @user.destroy
      flash[:success] = 'User successfully deleted!'
    else
      flash[:alert] = 'User unsuccessfully deleted!'
    end
    redirect_to :back
  end

  def leads
    users_scope = User.leads
    users_scope = users_scope.custom_search(params[:filter]) if params[:filter]
    prepare_smart_listing(users_scope)
  end

  def contacts
    respond_to do |format|
      format.any(:html, :js) do
        users_scope = User.contacts
        users_scope = users_scope.custom_search(params[:filter]) if params[:filter]
        prepare_smart_listing(users_scope)
      end

      format.json do
        render json: { items: User.contacts.custom_search(params[:q]).order(:last_name) }
      end
    end
  end

  def sales_reps
    render json: { items: User.all_sales.custom_search(params[:q]).order(:last_name) }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    @user ||= User.new
    authorize @user
  end

  def user_params
    params.require(:user).permit(
      :about,
      :archived,
      :billing_city,
      :billing_company,
      :billing_first_name,
      :billing_last_name,
      :billing_state,
      :billing_street,
      :billing_zip_code,
      :city,
      :company_id,
      :contact_number,
      :country,
      :daily_rate,
      :email_alternative,
      :first_name,
      :last_name,
      :notes,
      :parent_id,
      :phone_alternative,
      :same_addresses,
      :shipping_city,
      :shipping_company,
      :shipping_first_name,
      :shipping_last_name,
      :shipping_state,
      :shipping_street,
      :shipping_zip_code,
      :state,
      :status,
      :street,
      :video_bio,
      :zipcode,
      roles_attributes: [
        :id,
        :role,
        :_destroy
      ]
    )
  end

  def prepare_smart_listing(users_scope)
    smart_listing_create(
      :users,
      users_scope,
      partial: 'listing',
      default_sort: { created_at: 'desc' }
    )
  end
end
