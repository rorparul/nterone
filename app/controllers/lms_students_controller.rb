class LmsStudentsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_user!
  before_action :set_student, only: [:show]

  def index
    authorize :lms_student, :index?
    @students = smart_listing_create(:students, User.lms_students, partial: 'lms_students/listing')
  end

  def show
    authorize :lms_student, :show?
    @courses = VideoOnDemand.lms
  end

private

  def set_student
    @student = User.find(params[:id])
  end
end
