class RegionsController < ApplicationController
  # skip_before_action :redirect_to_user_tld

  def switch
    tld = params[:tld]

    if user_signed_in?
      current_user.settings.user_tld = tld
    end

    url = "https://nterone.#{tld}"

    redirect_to url
  end
end
