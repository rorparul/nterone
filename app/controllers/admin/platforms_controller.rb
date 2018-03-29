class Admin::PlatformsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index]

  # layout 'admin'

  def index
    @platforms = Platform.all
  end

  private

  def authorize_admin
    current_user.admin?
  end
end
