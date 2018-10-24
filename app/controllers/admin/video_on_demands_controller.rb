class Admin::VideoOnDemandsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index]

  def index
    @video_on_demands = VideoOnDemand.all
  end

  private

  def authorize_admin
    current_user.has_any_role?(%i(admin webmaster))
  end
end
