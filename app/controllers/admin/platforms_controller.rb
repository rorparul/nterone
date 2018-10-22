class Admin::PlatformsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index]

  def index
    @platforms = Platform.active
  end

  private

  def authorize_admin
    current_user.admin?
  end
end
