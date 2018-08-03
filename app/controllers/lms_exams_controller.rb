class LmsExamsController < ApplicationController
  before_action :authenticate_user!, except: [:quiz_demo, :init_quiz]
  before_action :sanitize_page_params, only: [:create, :update]

  def new
    @exam = LmsExam.new
    @exam_types = LmsExam.exam_types
    @question_types = LmsExamQuestion.question_types
  end

  def create
    @platform = Platform.find(exam_params[:platform_id])
    @video = Video.find(exam_params[:video_id])
    @video_on_demand = VideoOnDemand.find(exam_params[:video_on_demand_id])
    @exam = LmsExam.new(exam_params.except(:platform_id, :video_on_demand_id))
    @question_types = LmsExamQuestion.question_types

    @exam.video_on_demand = @video_on_demand if @exam.exam_type == 'test'
    @exam.video_module = @video.video_module

    if @exam.save
      flash[:success] = "Exam was uploaded for the #{@exam.video.title} video of the #{@exam.video.video_module.title} module!"
      redirect_to edit_platform_video_on_demand_path(@platform, @video_on_demand)
    end
  end

  def edit
    @exam = LmsExam.find(params[:id])
    @exam_types = LmsExam.exam_types
  end

  def update
    @exam = LmsExam.find(params[:id])
    @exam.update(exam_params)
    redirect_to :back
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

  def quiz_demo
    @video_on_demand = VideoOnDemand.find_by(slug: 'quiz-demo-vod')
    render 'quiz_demo'
  end

  def init_quiz
    @video_on_demand = VideoOnDemand.find(params[:vod_id])
    @video = Video.find(params[:video_id])
    @quiz = LmsExam.find(params[:id])
    render 'video_on_demands/init_quiz'
  end

  def begin_quiz
    @video_on_demand = VideoOnDemand.find(params[:platform_id])
    @platform = @video_on_demand.platform
    @video = Video.find(params[:video_id])
    @quiz = LmsExam.find(params[:id])

    @lms_exam_attempt = LmsExamAttempt.create(lms_exam: @quiz, user: current_user, started_at: Time.now)

    all_questions = @quiz.lms_exam_questions.all
    taken_questions = []

    @lms_exam_attempt.lms_exam_attempt_answers.each{ |lms_exam_attempt_answer| taken_questions << lms_exam_attempt_answer.lms_exam_question }

    available_questions = all_questions - taken_questions

    @next_question = available_questions.sample

    respond_to do |format|
      format.html { render :action => 'show' }
      format.js { render :action => 'begin_quiz' }
    end
  end

  def next_quiz_question
    @video_on_demand = VideoOnDemand.find(params[:platform_id])
    @platform = @video_on_demand.platform
    @video = Video.find(params[:video_id])
    @quiz = LmsExam.find(params[:id])

    save_answer

    @lms_exam_attempt = LmsExamAttempt.find(params[:lms_exam_attempt])

    all_questions = @quiz.lms_exam_questions.all
    taken_questions = []

    @lms_exam_attempt.lms_exam_attempt_answers.each{ |lms_exam_attempt_answer| taken_questions << lms_exam_attempt_answer.lms_exam_question }

    available_questions = all_questions - taken_questions

    @next_question = available_questions.sample

    unless @next_question == nil
      respond_to do |format|
        format.html { render :action => 'show' }
        format.js { render :action => 'next_quiz_question' }
      end
    else
      @lms_exam_attempt.completed_at = Time.now
      @lms_exam_attempt.save

      respond_to do |format|
        format.html { render :action => 'show' }
        format.js { render :action => 'exit_quiz' }
      end
    end
  end

  def exit_quiz
    @video_on_demand = VideoOnDemand.find(params[:platform_id])
    @platform = @video_on_demand.platform

    lms_exam_attempt = LmsExamAttempt.find(params[:lms_exam_attempt])
    lms_exam_attempt.update(completed_at: Time.now)

    if params[:next_video_id]
      @video = Video.find(params[:next_video_id])

      respond_to do |format|
        format.html { render :action => 'show' }
        format.js { render :action => 'play_video' }
      end
    else
      redirect_to platform_video_on_demand_path(@platform, @video_on_demand)
    end
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
                                                                    :lms_exam_id,
                                                                    lms_exam_answers_attributes: [:id,
                                                                                                  :answer_text,
                                                                                                  :position,
                                                                                                  :lms_exam_question_id,
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
