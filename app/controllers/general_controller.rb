class GeneralController < ApplicationController
  protect_from_forgery :except => [:upload_photo]

  def new_search
  end

  def search
    @items = Subject.search(params[:query]) + Course.where(active: true).where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].downcase}%") + VideoOnDemand.where(active: true).where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].downcase}%")
  end

  def welcome
    @page = Page.find_by(title: 'Welcome')

    return redirect_to lms_assign_manager_index_path if lms_signup_path?

    if current_user && current_user.lms_manager? && lms_path?
      redirect_to lms_manager_path
    elsif current_user && current_user.lms_student? && lms_path?
      redirect_to lms_student_path(current_user)
    elsif current_user && current_user.lms_business? && lms_path?
      redirect_to lms_business_index_path
    else
      render :welcome
    end
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
    @press_releases = Article.where(kind: "Press Release").order(created_at: :desc)
  end

  def blog
    @page       = Page.find_by(title: 'Blog Index')
    @blog_posts = Article.where(kind: "Blog Post").order(created_at: :desc)
  end

  def industry
    @page              = Page.find_by(title: 'Industry Index')
    @industry_articles = Article.where(kind: "Industry Article").order(created_at: :desc)
  end

  def consulting
    @page = Page.find_by(title: 'Consulting')
  end

  def partners
    @page = Page.find_by(title: 'Partners')
  end

  def labs
    @page = Page.find_by(title: 'Labs')
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
    if ContactUsMailer.contact_us(contact_us_params).deliver_now
      flash[:success] = 'Message successfully sent.'
    else
      flash[:notice] = 'Message failed to send.'
    end
    redirect_to contact_us_confirmation_path
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
    params.require(:contact_us).permit(:recipient, :name, :phone, :email, :inquiry, :feedback)
  end

  def lms_path?
    request.referer.present? && request.referer.include?('/lms')
  end

  def lms_signup_path?
    request.referer.present? && request.referer.include?('/lms/signup')
  end
end
