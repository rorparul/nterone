class GeneralController < ApplicationController
  def new_search

  end

  def search
    @items = Subject.search(params[:query]) + Course.where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{params[:query].downcase}%")
  end

  def welcome
    @carousel_items = CarouselItem.all_active
  end

  def about_us

  end

  def consulting

  end

  def partners

  end

  def labs

  end

  def my_admin

  end

  def contact_us_new
  end

  def contact_us_create
    if ContactUsMailer.contact_us(brand, current_user, contact_us_params).deliver_now
      flash[:success] = "Message successfully sent!"
    else
      flash[:notice] = "Message unsuccussfully sent!"
    end
    redirect_to :back
  end

  private

  def contact_us_params
    params.require(:contact_us).permit(:inquiry, :feedback)
  end
end
