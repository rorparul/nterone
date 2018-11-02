class Admin::PlatformsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index]

  def index
    if current_user.developer?
      @platforms = Platform.all
    else
      @platforms = Platform.active
    end
  end

  private

  def authorize_admin
    current_user.admin?
  end
end
