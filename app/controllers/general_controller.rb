class GeneralController < ApplicationController
  before_action :get_guaranteed_events,
                except: [:new_search,
                         :search,
                         :contact_us_new,
                         :contact_us_create]

  def new_search

  end

  def search
    @items = Subject.search(params[:query]) + Course.where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].downcase}%") + VideoOnDemand.where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].downcase}%")
  end

  def welcome
    @carousel_items = CarouselItem.all_active
  end

  def about_us
    @executive_bios  = Page.find_by(title: 'Executive Bios')
    @instructor_bios = Page.find_by(title: 'Instructor Bios')
    # @news            =
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

  def contact_us_new
    if user_signed_in?
      @user = current_user
    else
      @user = User.new
    end
  end

  def contact_us_create
    if ContactUsMailer.contact_us(contact_us_params).deliver_now
      flash[:success] = "Message successfully sent!"
    else
      flash[:notice] = "Message unsuccussfully sent!"
    end
    redirect_to :back
  end

  private

  def contact_us_params
    params.require(:contact_us).permit(:name, :phone, :email, :inquiry, :feedback)
  end

  def get_guaranteed_events
    @guaranteed_events = Event.guaranteed_upcoming_events
  end
end
