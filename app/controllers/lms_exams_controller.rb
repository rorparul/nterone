class LmsExamsController < ApplicationController
  before_action :authenticate_user!
  before_action :sanitize_page_params

  def index

  end

  def show

  end

  def new
    @exam = LmsExam.new
    @exam_types = LmsExam.exam_types
  end

  def create
    @exam = LmsExam.create(exam_params)
    if @exam.save
      flash[:success] = 'Exam successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def update

  end

  def destroy

  end

  private

  def exam_params
    params.require(:lms_exam).permit(:id,
                                     :title,
                                     :description,
                                     :exam_type)
  end

  def sanitize_page_params
    params[:lms_exam][:exam_type] = LmsExam.exam_types.key(params[:lms_exam][:exam_type].to_i)
  end
end
