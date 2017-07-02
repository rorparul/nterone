class GeneralController < ApplicationController
  protect_from_forgery :except => [:upload_photo]

  def new_search
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end

  def search
    @items = Subject.search(params[:query]) + Course.where(active: true).where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].try(:downcase)}%") + VideoOnDemand.where(active: true).where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].try(:downcase)}%")
  end

  def welcome
    @page = Page.find_by(title: 'Welcome')
  end

  def sign_up_confirmation
    @page = Page.find_by(title: 'Sign Up Confirmation')
  end

  def about_us
    @page = Page.find_by(title: 'About NterOne')
  end

  def executives
    @page  = Page.find_by(title: 'Executive Bios')
  end

  def instructors
    @page = Page.find_by(title: 'Instructor Bios')
  end

  def press
    @page           = Page.find_by(title: 'Press Index')
    @press_releases = Article.active_in_current_region.where(kind: "Press Release").order(created_at: :desc)
  end

  def blog
    @page       = Page.find_by(title: 'Blog Index')
    @blog_posts = Article.active_in_current_region.where(kind: "Blog Post").order(created_at: :desc)
  end

  def industry
    redirect_to root_path unless Setting.tld == "com"
    @page              = Page.find_by(title: 'Industry Index')
    @industry_articles = Article.active_in_current_region.where(kind: "Industry Article").order(created_at: :desc)
  end

  def consulting
    @page = Page.find_by(title: 'Consulting')
  end

  def partners
    @page = Page.find_by(title: 'Partners')
  end

  def labs
    @page        = Page.find_by(title: 'Labs')
    @lab_courses = LabCourse.where.not(level: 'partner').order(:title)
  end

  def nterone_gives_back
    @page = Page.find_by(title: 'NterOne Gives Back')
  end

  def featured_classes
    @page      = Page.find_by(title: 'Featured Classes')
    @platforms = Platform.order(:title)

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
    success = ContactUsMailer.contact_us(contact_us_params).deliver_now

    respond_to do |format|
      format.html do
        if success
          flash[:success] = 'Message successfully sent.'
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

  def contact_us_confirmation
    @page = Page.find_by(title: 'Contact Us Confirmation')
  end

  def sims
  end

  def nci
    @page = Page.find_by(title: 'NCI')
  end

  def support
    @page = Page.find_by(title: 'Support')
  end

  def sitemap
    @page = Page.find_by(title: "Sitemap")
  end

  def editor_upload_photo
    uploaded_photo = params[:file].tempfile
    uploader = FroalaImageUploader.new(original_filename: params[:file].original_filename)
    uploader.store!(uploaded_photo)

    img_url_res = { link: uploader.url }

    render json: img_url_res
  end

  private

  def contact_us_params
    params.require(:contact_us).permit(:recipient, :name, :phone, :email, :inquiry, :subject, :feedback)
  end

  def lms_path?
    request.referer.present? && request.referer.include?('/lms')
  end

  def lms_signup_path?
    request.referer.present? && request.referer.include?('/lms/signup')
  end
end
