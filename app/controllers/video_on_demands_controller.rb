class VideoOnDemandsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :play_video, :begin_quiz, :next_quiz_question, :exit_quiz, :show_scores]
  skip_before_action :verify_authenticity_token, only: [:exit_quiz]

  def new
    @platform        = Platform.find(params[:platform_id])
    @video_on_demand = @platform.video_on_demands.build
    @video_on_demand.video_modules.build.videos.build
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end

    @instructors     = @platform.instructors
    @video_on_demand.build_image
  end

  def create
    @platform        = Platform.find(params[:platform_id])
    @video_on_demand = @platform.video_on_demands.build(video_on_demand_params)
    @video_on_demand.set_image(url_param: params['video_on_demand'], for: :image)
    if @video_on_demand.save
      flash[:success] = 'Video On Demand successfully created!'
      redirect_to platform_category_path(@platform, Category.parent_categories.first)
    else
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
      @instructors = @platform.instructors
      render 'new'
    end
  end

  def show
    @platform        = Platform.find(params[:platform_id])
    @video_on_demand = VideoOnDemand.find(params[:id])
  end

  def select
    @platform         = Platform.find(params[:platform_id])
    @video_on_demand  = @platform.video_on_demands.build
    @video_on_demands = @platform.video_on_demands.order('lower(title)')
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end
    @instructors      = @platform.instructors
    @video_on_demand.build_image
  end

  def  select_to_edit
    if video_on_demand_params[:id] == 'none'
      redirect_to select_platform_video_on_demands_path(Platform.find(params[:platform_id]))
    else
      @platform        = Platform.find(params[:platform_id])
      @video_on_demand = VideoOnDemand.find(video_on_demand_params[:id])
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
      @instructors     = @platform.instructors
      @video_on_demand.build_image unless @video_on_demand.image.present?
    end
  end

  def edit
    @platform        = Platform.find(params[:platform_id])
    @video_on_demand = VideoOnDemand.find(params[:id])
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end
    @instructors     = @platform.instructors
    @exam = LmsExam.new
    @exam_types = LmsExam.exam_types
    @question_types = LmsExamQuestion.question_types
    @video_on_demand.build_image unless @video_on_demand.image.present?

    @video_on_demand.video_modules.each do |video_module|
      unless video_module.videos.empty?
        @video_exists = true
      else
        @video_exists = false
      end
    end
  end

  def update
    @platform        = Platform.find(params[:platform_id])
    @video_on_demand = VideoOnDemand.find(params[:id])
    @video_on_demand.set_image(url_param: params['video_on_demand'], for: :image)
    if @video_on_demand.update_attributes(video_on_demand_params)
      flash[:success] = 'Video On Demand successfully updated!'
      redirect_to session[:previous_request_url]
    else
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
      @instructors = @platform.instructors
      render "edit"
    end
  end

  def destroy
    video_on_demand = VideoOnDemand.find(params[:id])
    if video_on_demand.destroy
      flash[:success] = 'Video On Demand successfully destroyed!'
    else
      flash[:alert] = 'Video On Demand unsuccessfully destroyed!'
    end
    redirect_to session[:previous_request_url]
  end

  def play_video
    @video = Video.find(params[:id])
    if user_signed_in?
      @video.users << current_user if @video.users.exclude?(current_user)
    end
  end

  def init_quiz
    @video_on_demand = VideoOnDemand.find(params[:platform_id])
    @video = Video.find(params[:video_id])
    @quiz = LmsExam.find(params[:id])
    if user_signed_in?
      @quiz.users << current_user if @quiz.users.exclude?(current_user)
    end
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

    LmsExamAttemptAnswer.create(lms_exam_attempt: LmsExamAttempt.find(params[:lms_exam_attempt]), lms_exam_question: LmsExamQuestion.find(params[:lms_exam_question]), lms_exam_answer: LmsExamAnswer.find(params[:answer]))

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
    TakenExam.create(lms_exam: lms_exam_attempt.lms_exam, user: current_user)

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

  def show_scores
    @video_on_demand = VideoOnDemand.find(params[:platform_id])
    @platform = @video_on_demand.platform
    @video = Video.find(params[:video_id])
    @quiz = LmsExam.find(params[:id])

    @lms_exam_attempts = LmsExamAttempt.where(lms_exam: @quiz, user: current_user)

    respond_to do |format|
      format.html { render :action => 'show' }
      format.js { render :action => 'show_scores' }
    end
  end

  private

  def video_on_demand_params
    params.require(:video_on_demand).permit(:id,
                                            :page_title,
                                            :page_description,
                                            :title,
                                            :abbreviation,
                                            :course_id,
                                            :instructor_id,
                                            :level,
                                            :price,
                                            :intro,
                                            :overview,
                                            :outline,
                                            :intended_audience,
                                            :partner_led,
                                            :active,
                                            :lms,
                                            :answer,
                                            :lms_exam_attempt,
                                            :lms_exam_question,
                                            :platform_id,
                                            :video_id,
                                            category_ids: [],
                                            video_modules_attributes: [:id,
                                                                       :position,
                                                                       :title,
                                                                       :_destroy,
                                                                       videos_attributes: [:id,
                                                                                           :position,
                                                                                           :title,
                                                                                           :embed_code,
                                                                                           :free,
                                                                                           :_destroy,
                                                                                            lms_exams_attributes: [:id]]])
  end
end
