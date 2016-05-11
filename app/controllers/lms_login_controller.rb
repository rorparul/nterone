class LmsLoginController < ApplicationController
  def new
    if user_signed_in?
      redirect_to root_path
    else
      render 'devise/sessions/new', layout: 'layouts/devise'
    end
  end
end
