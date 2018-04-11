class Users::InvitationsController < Devise::InvitationsController
  before_action :set_user, only: [:create]

  def new
    self.resource = resource_class.new
    @chosen_courses = self.resource.chosen_courses.build
    resource.assign_attributes(parent_id: current_user.id)
    resource.assign_attributes(status: 3) if request.path == '/users/contacts/new'
    resource.assign_attributes(email: "#{SecureRandom.hex(10)}@placeholder.email")
    render :new
  end

  def create
    if not_invited?
      super
      @user.roles.create
      @user.update_attributes(referring_partner_email_params)

      flash[:success] = 'Successfully Saved!' if skip_invitation?
    else
      flash[:alert] = "#{@user.full_name}, belonging to #{@user.parent.try(:full_name) || 'nobody'}, with specified email is already invited."
      redirect_to :back
    end
  end

  def resend
    if params[:id].present?
      user = User.find_by(id: params[:id])
      user.invite! if user.present?
      flash[:success] = 'Invitation resent!' if user.present?
    end

    redirect_to admin_people_path
  end

  def after_invite_path_for(resource)
    request.referrer
  end

  private

  def set_user
    if invite_params[:email].present?
      @user = User.find_by(email: invite_params[:email].downcase)
    end
  end

  def not_invited?
    @user.nil?
  end

  def skip_invitation?
    params[:skip_invitation] == 'true' ? true : false
  end

  def invite_resource
    super do |u|
      u.skip_invitation = skip_invitation?
    end
  end

  def invite_params
    params.require(:user).permit(
      :business_title,
      :company_id,
      :contact_number,
      :do_not_call,
      :do_not_email,
      :email_alternative,
      :email,
      :first_name,
      :last_name,
      :notes,
      :parent_id,
      :phone_alternative,
      :salutation,
      :status,
      :source_name,
      :customer_type,
      chosen_courses_attributes: [:course_id]
    )
  end

  def referring_partner_email_params
    params.require(:user).permit(:referring_partner_email)
  end
end
