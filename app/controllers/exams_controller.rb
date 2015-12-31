class ExamsController < ApplicationController
  def return_all

  end

  def new
    @platform = Platform.find(params[:platform_id])
    @exam     = Exam.new
  end

  def create
    @exam = Platform.find(params[:platform_id]).exams.build(exam_params)
    if @exam.save
      flash[:success] = "Exam successfully created."
      redirect_to :back
    else
      flash[:alert] = "Exam unsuccessfully created."
      render "new"
    end
  end

  def search
    @exams = Exam.where('title ilike ?', "%#{params[:query]}%")
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
      flash[:notice] = 'You have successfully updated Exam.'
      redirect_to platform_path(params[:platform_id])
    else
      render('edit')
    end
  end

  def destroy
    Exam.find(params[:id]).destroy
    flash[:notice] = 'Exam was successfully deleted.'
    redirect_to platform_path(params[:platform_id])
  end

  private

  def exam_params
    params.require(:exam).permit(:id, :title)
  end
end
