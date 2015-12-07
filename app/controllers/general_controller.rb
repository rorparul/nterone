class GeneralController < ApplicationController
  def welcome
    if user_signed_in?
      @platforms = brand.platforms.eager_load(:image)
    else
      redirect_to new_user_session_path
    end
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
