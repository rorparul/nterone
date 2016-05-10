class LmsStudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:show]

  def index
    authorize :lms_student, :index?
    @students = User.lms_students
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
