class GeneralController < ApplicationController
  def new_search
  end

  def search
    @items = Subject.search(params[:query]) + Course.where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].downcase}%") + VideoOnDemand.where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].downcase}%")
  end

  def welcome
    @carousel_items = CarouselItem.all_active
  end

  def executives
    @executive_bios  = Page.find_by(title: 'Executive Bios')
  end

  def instructors
    @instructor_bios = Page.find_by(title: 'Instructor Bios')
  end

  def press
    @press_releases = PressRelease.order(created_at: :desc)
  end

  def blog
    @blog_posts = BlogPost.order(created_at: :desc)
  end

  def industry
    @industry_articles = IndustryArticle.order(created_at: :desc)
  end

  def consulting
    @consulting = Page.find_by(title: 'Consulting')
  end

  def partners
    @partners = Page.find_by(title: 'Partners')
  end

  def labs
    @labs = Page.find_by(title: 'Labs')
  end

  def featured_classes
    
  end

  def contact_us_new
    if user_signed_in?
      @user = current_user
    else
      @user = User.new
    end
  end

  def contact_us_create
    if ContactUsMailer.contact_us(contact_us_params).deliver_now
      flash[:success] = 'Message successfully sent.'
    else
      flash[:notice] = 'Message failed to send.'
    end
    redirect_to :back
  end

  private

  def contact_us_params
    params.require(:contact_us).permit(:recipient, :name, :phone, :email, :inquiry, :feedback)
  end
end
