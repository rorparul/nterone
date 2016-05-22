class LmsExamsController < ApplicationController
  before_action :authenticate_user!
  before_action :sanitize_page_params, only: [:create, :update]

  def new
    @exam = LmsExam.new
    @exam_types = LmsExam.exam_types
    @question_types = LmsExamQuestion.question_types
  end

  def create
    @platform = Platform.find(exam_params[:platform_id])
    @video_on_demand = VideoOnDemand.find(exam_params[:video_on_demand_id])
    @exam = LmsExam.new(exam_params.except(:platform_id, :video_on_demand_id))
    @question_types = LmsExamQuestion.question_types

    if @exam.save
      @exam.update(video_module_id: Video.find(exam_params[:video_id]).video_module.id)
      flash[:success] = "Exam was uploaded for the #{@exam.video.title} video of the #{@exam.video.video_module.title} module!"
      redirect_to edit_platform_video_on_demand_path(@platform, @video_on_demand)
    end
  end

  def edit
    @exam = LmsExam.find(params[:id])
    @exam_types = LmsExam.exam_types
  end

  def update

  end

  def destroy
    @exam = LmsExam.find(params[:id])

    if @exam.destroy
      flash[:success] = 'Exam successfully deleted!'
    else
      flash[:alert] = 'Exam unsuccessfully deleted!'
    end

    redirect_to :back
  end

  private

  def exam_params
    params.require(:lms_exam).permit(:id,
                                     :title,
                                     :description,
                                     :exam_type,
                                     :video_module_id,
                                     :video_id,
                                     :platform_id,
                                     :video_on_demand_id,
                                     lms_exam_questions_attributes: [:id,
                                                                    :question_text,
                                                                    :question_type,
                                                                    lms_exam_answers_attributes: [:id,
                                                                                                  :answer_text,
                                                                                                  :position,
                                                                                                  :correct]])
  end

  def sanitize_page_params
    params[:lms_exam][:exam_type] = LmsExam.exam_types.key(params[:lms_exam][:exam_type].to_i)
    params[:lms_exam][:lms_exam_questions_attributes].each do |key, question|
      params[:lms_exam][:lms_exam_questions_attributes][key][:question_type] =
        LmsExamQuestion.question_types.key(question[:question_type].to_i)
    end
  end
end
