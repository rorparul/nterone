class UsersController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  include SmartListingConcerns

  before_action :set_user,       only: [:show, :show_as_lead, :show_as_contact, :edit, :edit_from_sales, :assign, :edit_from_my_queue, :update, :toggle_archived, :destroy]
  before_action :authorize_user, except: [:show, :toggle_archived]

  def index
    respond_to do |format|
			format.any(:html, :js) do
        users_scope = current_user.partner? ? users_scope.where(company: current_user.company) : User.all

        users_scope = users_scope.custom_search(params[:filter]) if params[:filter].present?
        prepare_smart_listing(users_scope)

        if params[:role].present?
          prepare_role_smart_listing(params[:role], get_users_by_role)
        else
          ["students", "instructors", "admins", "partners"].each do |role|
            prepare_role_smart_listing(role, users_scope.limit(1))
          end
        end
      end

      format.json do
        if params[:key] == 'state'
				  render json: { items: User.where("lower(state) like lower('%#{params[:q]}%')").pluck(:state).uniq }
        else
          render nothing: true
        end
			end
    end
  end

  def show
    @planned_subjects = @user.planned_subjects.where(active: true)
    @user.planned_subjects.where(active: true).update_all(read: true)
    @my_plan_count = @user.new_my_plan_count
    @activities = PublicActivity::Activity.where("owner_id = ? OR recipient_id = ?", @user.id, @user.id).order(created_at: :desc)
  end

  def show_as_lead
    list_tasks
    list_orders
  end

  def show_as_contact
    list_tasks
    list_orders
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

  def people
    params[:stage] ||= "all_stage"
    respond_to do |format|
      format.html do
        users_scope = User.send(params[:stage]).where(parent_id: current_user.id)
        prepare_smart_listing(users_scope)
      end

      format.js do
        if params[:user]
          users_scope = User.send(params[:stage]).where(clean_params(user_params[:filters]))
        else
          users_scope = User.send(params[:stage]).where(parent_id: current_user.id)
        end
        users_scope = users_scope.custom_search(params[:search]) if params[:search].present?
        prepare_smart_listing(users_scope)
      end

      format.json do
        render json: { items: User.send(params[:stage]).custom_search(params[:q]).order(:last_name) }
      end

      format.xlsx do
        @users = User.send(params[:stage]).where(clean_params(user_params[:filters])).order(:last_name)
        @users = @users.custom_search(params[:search]) if params[:search].present?
        render xlsx: 'index', filename: "#{params[:stage]}-#{DateTime.now}.xlsx"
      end
    end
  end

  def leads_unsubscribe_new
  end

  def leads_unsubscribe
    User.unsubscribe_from_email(params[:user_file])
    flash[:success] = "List Unsubscribes successfully"
    redirect_to people_users_path
  end

  def mark_customers_type
    params[:user_ids].each do |user_id|
      user = User.find(user_id)
      user.update_attributes(customer_type: params[:mark_as])
    end
    render json: { message: "Users are successfully marked as #{params[:mark_as]}"}
  end

  def members
    render json: { items: User.members.custom_search(params[:q]).order(:last_name) }
  end

  def sales_reps
    render json: { items: User.active_sales.custom_search(params[:q]).order(:last_name) }
  end

  def mass_edit
    @type = params[:type]
  end

  def mass_update
    if params[:type] == 'leads'
      users = User.leads.where(id: params[:user_ids])
    elsif params[:type] == 'contacts'
      users = User.contacts.where(id: params[:user_ids])
    else
      users = User.where(id: params[:user_ids])
    end

    users       = users.custom_search(params[:search]) if params[:search].present?
    parent_name = nil
    parent_name = User.find(user_params[:parent_id]).full_name if user_params[:parent_id]
    update_params = {parent_id: user_params[:parent_id]}

    if users.update_all(update_params)
      render json: { parent_name: parent_name }
    else
      render nothing: true
    end
  end

  private

  def get_users_by_role
    case params[:role]
    when "students"
      users_scope = current_user.partner? ? users_scope.where(company: current_user.company).students : User.students
    when "instructors"
      users_scope = current_user.partner? ? users_scope.where(company: current_user.company).instructors : User.instructors
    when "admins"
      users_scope = current_user.partner? ? users_scope.where(company: current_user.company).admins : User.admins
    when "partners"
      users_scope = current_user.partner? ? users_scope.where(company: current_user.company).partners : User.partners
    end
    users_scope = users_scope.custom_search(params[:filter]) if params[:filter]
    users_scope
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    @user ||= User.new
    authorize @user
  end

  def user_params
    params.require(:user).permit(
      :active,
      :archive,
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
      :onsite_daily_rate,
      :online_daily_rate,
      :email,
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
      :customer_type,
      :source_name,
      :street,
      :video_bio,
      :zipcode,
      :employement_type,
      :rating, 
      filters: [
        :parent_id,
        :source_name,
        :status,
        :state,
        :company_id,
        :customer_type,
        escort: [
          :value
        ]
      ],
      roles_attributes: [
        :id,
        :role,
        :_destroy
      ],
      chosen_courses_attributes: [
        :id,
        :course_id,
        :audit_complete,
        :completed_all_labs,
        :met_with_course_director,
        :audit_complete_by_user,
        :audit_complete_by_date,
        :completed_all_labs_by_user,
        :completed_all_labs_by_date,
        :met_with_course_director_by,
        :met_with_course_director_by_date,
        :_destroy
      ]
    )
  end

  def prepare_smart_listing(users_scope)
    smart_listing_create(
      :users,
      users_scope,
      partial: 'listing',
      sort_attributes: [[:first_name, "first_name"],
                        [:last_name, "last_name"],
                        [:email, "email"]],
      default_sort: { updated_at: 'desc' }
    )
  end

  def prepare_role_smart_listing(role, users_scope)
    smart_listing_create(
      role.to_sym,
      users_scope,
      partial: "#{role}_listing",
      sort_attributes: [[:first_name, "first_name"],
                        [:last_name, "last_name"],
                        [:email, "email"]],
      default_sort: { updated_at: 'desc' }
    )
  end

  def list_orders
    orders_scope = @user.buyer_orders.all
    orders_scope = orders_scope.custom_search(params[:filter]) if params[:filter]
    @orders_scope = smart_listing_create(:orders,
                         orders_scope,
                         partial: "orders/listing",
                         sort_attributes: [[:id, "orders.id"],
                                           [:status_position, "status_position"],
                                           [:total, "total"],
                                           [:paid, "paid"],
                                           [:balance, "balance"],
                                           [:source, "source"],
                                           [:auth_code, "auth_code"],
                                           [:clc_quantity, "clc_quantity"],
                                           [:created_at, "orders.created_at"]],
                         default_sort: { id: "desc"})
  end

  def list_tasks
    if params[:selection] == "complete"
      tasks_scope = Task.where(user_id: @user.id, complete: true)
    elsif params[:selection] == "due"
      tasks_scope = Task.where(user_id: @user.id, complete: false)
    else
      tasks_scope = Task.where(user_id: @user.id)
    end

    tasks_scope = tasks_scope.custom_search(params[:filter]) if params[:filter]
    @tasks      = smart_listing_create(:tasks,
                                       tasks_scope,
                                       partial: 'tasks/listing',
                                       sort_attributes: [[:activity_date, "activity_date"],
                                                         [:description, "description"],
                                                         [:priority, "priority"],
                                                         [:subject, "subject"],
                                                         [:complete, "complete"]],
                                                         default_sort: { activity_date: "asc" })
  end
end
