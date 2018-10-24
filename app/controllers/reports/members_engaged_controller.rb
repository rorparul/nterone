class Reports::MembersEngagedController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    @members_engaged = User.members_engaged

    respond_to do |format|
      format.xlsx
    end
  end
end
