class ExamAndCourseDynamicsController < ApplicationController
  before_action :authenticate_user!

  def new
    @platform                = Platform.find(params[:platform_id])
    @exam_and_course_dynamic = ExamAndCourseDynamic.new
  end

  def create
    @platform = Platform.find(params[:platform_id])
    @exam_and_course_dynamic = @platform.exam_and_course_dynamics.build(exam_and_course_dynamic_params)
    @exam_and_course_dynamic.exams.each { |exam| exam.platform = @platform }
    @exam_and_course_dynamic.courses.each { |course| course.platform = @platform }
    if @exam_and_course_dynamic.save
      flash[:success] = "Exam and course dynamic successfully created!"
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def select
    @platform                 = Platform.find(params[:platform_id])
    @exam_and_course_dynamics = @platform.exam_and_course_dynamics.where.not(id: nil)
    @exam_and_course_dynamic  = @platform.exam_and_course_dynamics.build
  end

  def  select_to_edit
    if exam_and_course_dynamic_params[:id] == 'none'
      redirect_to select_platform_exams_path(Platform.find(params[:platform_id]))
    else
      @platform                = Platform.find(params[:platform_id])
      @exam_and_course_dynamic = ExamAndCourseDynamic.find(exam_and_course_dynamic_params[:id])
    end
  end

  def update
    @exam_and_course_dynamic = ExamAndCourseDynamic.find(params[:id])
    @platform = @exam_and_course_dynamic.platform
    @exam_and_course_dynamic.assign_attributes(exam_and_course_dynamic_params)
    @exam_and_course_dynamic.exams.each {|exam| exam.platform = @platform}
    @exam_and_course_dynamic.courses.each {|course| course.platform = @platform}
    if @exam_and_course_dynamic.save
      flash[:success] = "Exam and course dynamic successfully updated!"
      render js: "window.location = '#{request.referrer}';"
    else
      render 'select_to_edit'
    end
  end

  def destroy
    exam_and_course_dynamic = ExamAndCourseDynamic.find(params[:id])
    if exam_and_course_dynamic.destroy
      flash[:success] = "Exam and course dynamic successfully deleted!"
    else
      flash[:alert] = "Exam and course dynamic unsuccessfully deleted!"
    end
    redirect_to :back
  end

  private

  def exam_and_course_dynamic_params
    params.require(:exam_and_course_dynamic).permit(
      :id,
      :label,
      :origin_region,
      active_regions: [],
      course_ids: [],
      exam_ids: [])
  end
end
