class GeneralController < ApplicationController
  protect_from_forgery :except => [:upload_photo]

  def new_search
    respond_to do |format|
      format.js { render 'shared/new_search' }
      format.html { redirect_to root_path }
    end
  end

  def search
    courses  = Course.active.current_region.where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].try(:downcase)}%")
    subjects = Subject.active.current_region.search(params[:query])
    vods     = VideoOnDemand.active.current_region.where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].try(:downcase)}%")

    @items = subjects + courses + vods
  end

  def change_region
    respond_to do |format|
      format.js { render 'shared/change_region' }
      format.html { redirect_to root_path }
    end
  end

  def sign_up_confirmation
    @page = Page.current_region.find_by(title: 'Sign Up Confirmation')
  end

  def about_us
    @page = Page.current_region.find_by(title: 'About NterOne')
  end

  def executives
    @page  = Page.current_region.find_by(title: 'Executive Bios')
  end

  def instructors
    @page = Page.current_region.find_by(title: 'Instructor Bios')
  end

  def press
    @page           = Page.current_region.find_by(title: 'Press Index')
    @press_releases = Article.current_region.where(kind: "Press Release").order(created_at: :desc)
  end

  def blog
    @page       = Page.current_region.find_by(title: 'Blog Index')
    @blog_posts = Article.current_region.where(kind: "Blog Post").order(created_at: :desc)
  end

  def consulting
    @page = Page.current_region.find_by(title: 'Consulting')
  end

  def partners
    @page = Page.current_region.find_by(title: 'Partners')
  end

  def employment_opportunity
    @page = Page.current_region.find_by(title: 'Employment Opportunity')
  end

  def labs
    @page        = Page.current_region.find_by(title: 'Labs')
    @lab_courses = LabCourse.current_region.where.not(level: 'partner').order(:title)
  end

  def nterone_gives_back
    @page = Page.current_region.find_by(title: 'NterOne Gives Back')
  end

  def featured_classes
    @page      = Page.current_region.find_by(title: 'Featured Classes')
    @platforms = Platform.active.current_region.order(:title)

    respond_to do |format|
      format.xlsx
      format.html
    end
  end

  def contact_us_new
    respond_to do |format|
      format.js do
        if user_signed_in?
          @user = current_user
        else
          @user = User.new
        end
      end

      format.html do
        redirect_to root_path
      end
    end
  end

  def contact_us_create
    if Rails.application.config.blacklisted_emails.include?(contact_us_params[:email])
      flash[:alert] = 'The action you requested is not permitted.'
      redirect_to :back
    else
      if params["g-recaptcha-response"].nil? || (!params["g-recaptcha-response"].nil? && verify_recaptcha)
        success = ContactUsMailer.contact_us(contact_us_params).deliver_now
      else
        success = false
      end

      respond_to do |format|
        format.html do
          if success
            submission_params = contact_us_params
            submission_params.delete('M360-Source')

            ContactUsSubmission.create(submission_params)

            if params[:origin] == "course"
              redirect_to course_inquiry_confirmation_path
            elsif params[:origin] == "learning_credits"
              redirect_to learning_credits_inquiry_confirmation_path
            else
              redirect_to general_inquiry_confirmation_path
            end
          else
            flash[:notice] = 'Message failed to send.'
            redirect_to :back
          end
        end

        format.js do
          if success
            render 'contact_success'
          else
            render nothing: true
          end
        end
      end
    end
  end

  def contact_us_confirmation
    @page = Page.current_region.find_by(title: 'Contact Us Confirmation')
  end

  def sims
  end

  def support
    @page = Page.current_region.find_by(title: 'Support')
  end

  def sitemap
    @page = Page.current_region.find_by(title: "Sitemap")
  end

  def editor_upload_photo
    uploaded_photo = params[:file].tempfile
    uploader = FroalaImageUploader.new(original_filename: params[:file].original_filename)
    uploader.store!(uploaded_photo)

    img_url_res = { link: uploader.url }

    render json: img_url_res
  end

  def email_signature_tool
  end

  def set_la_info
    case params[:region]
    when "republica_dominicana"
      @flag_class = "flag-icon strong flag-icon-do"
      @contact = '+809-542-2476'
    when "venezuela"
      @flag_class = "flag-icon strong flag-icon-ve"
      @contact = '+582-129-930634'
    when "panama"
      @flag_class = "flag-icon strong flag-icon-pa"
      @contact = '+507-833-6419'
    when "colombia"
      @flag_class = "flag-icon strong flag-icon-co"
      @contact = '+571-639-8444'
    end
  end

  private

  def contact_us_params
    params.require(:contact_us).permit(
      :email,
      :message,
      :name,
      :phone,
      :recipient,
      :subject,
      'M360-Source'
    )
  end

  def lms_path?
    request.referer.present? && request.referer.include?('/lms')
  end

  def lms_signup_path?
    request.referer.present? && request.referer.include?('/lms/signup')
  end
end
