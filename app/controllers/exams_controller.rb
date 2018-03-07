class ExamsController < ApplicationController
  before_action :authenticate_user!

  def new
    @platform = Platform.find(params[:platform_id])
    @exam     = Exam.new
  end

  def create
    @platform = Platform.find(params[:platform_id])
    @exam     = @platform.exams.build(exam_params)
    if @exam.save
      flash[:success] = 'Exam successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def select
    @platform = Platform.find(params[:platform_id])
    @exams    = @platform.exams.where.not(id: nil)
    @exam     = @platform.exams.build
  end

  def  select_to_edit
    if exam_params[:id] == 'none'
      redirect_to select_platform_exams_path(Platform.find(params[:platform_id]))
    else
      @platform = Platform.find(params[:platform_id])
      @exam     = Exam.find(exam_params[:id])
    end
  end

  def update
    @exam = Exam.find(params[:id])
    @exam.assign_attributes(exam_params)
    if @exam.save
      flash[:success] = 'Exam successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      @platform = Platform.find(params[:platform_id])
      render 'select_to_edit'
    end
  end

  def destroy
    exam = Exam.find(params[:id])
    if exam.destroy
      flash[:success] = 'Exam successfully deleted!'
    else
      flash[:alert] = 'Exam unsuccessfully deleted!'
    end
    redirect_to :back
  end

  private

  def exam_params
    params.require(:exam).permit(
      :id,
      :origin_region,
      :title,
      active_regions: [])
  end
end
