class LmsStudentsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_user!

  def index
    @students = smart_listing_create(:students, User.lms_students, partial: 'lms_students/listing')
  end
end
