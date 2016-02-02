class VideoOnDemandsController < ApplicationController
  def new
    @platform        = Platform.find(params[:platform_id])
    @video_on_demand = @platform.video_on_demands.build
    @video_on_demand.video_modules.build.videos.build
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end
    @courses         = @platform.courses
    @instructors     = @platform.instructors
  end

  def create
    @platform        = Platform.find(params[:platform_id])
    @video_on_demand = @platform.video_on_demands.build(video_on_demand_params)
    if @video_on_demand.save
      flash[:success] = 'Video On Demand successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
      @courses     = @platform.courses
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
    @courses          = @platform.courses
    @instructors      = @platform.instructors
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
      @courses         = @platform.courses
      @instructors     = @platform.instructors
    end
  end

  def edit
    @platform        = Platform.find(params[:platform_id])
    @video_on_demand = VideoOnDemand.find(params[:id])
    @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
      category if category.parent
    end
    @courses         = @platform.courses
    @instructors     = @platform.instructors
  end

  def update
    @platform        = Platform.find(params[:platform_id])
    @video_on_demand = VideoOnDemand.find(params[:id])
    if @video_on_demand.update_attributes(video_on_demand_params)
      flash[:success] = 'Video On Demand successfully updated!'
      render js: "window.location = '#{request.referrer}';"
    else
      @categories = Category.where(platform_id: @platform.id).order(:title).select do |category|
        category if category.parent
      end
      @courses     = @platform.courses
      @instructors = @platform.instructors
      render 'select_to_edit'
    end
  end

  def destroy
    video_on_demand = VideoOnDemand.find(params[:id])
    if video_on_demand.destroy
      flash[:success] = 'Video On Demand successfully destroyed!'
    else
      flash[:alert] = 'Video On Demand unsuccessfully destroyed!'
    end
    redirect_to :back
  end

  def play_video
    @video = Video.find(params[:id])
    if user_signed_in?
      @video.users << current_user if @video.users.exclude?(current_user)
    end
  end

  private

  def video_on_demand_params
    params.require(:video_on_demand).permit(:id,
                                            :title,
                                            :abbreviation,
                                            :course_id,
                                            :instructor_id,
                                            :level,
                                            :price,
                                            category_ids: [],
                                            video_modules_attributes: [:id,
                                                                       :title,
                                                                       :_destroy,
                                                                       videos_attributes: [:id,
                                                                                           :title,
                                                                                           :embed_code,
                                                                                           :free,
                                                                                           :_destroy]])
  end
end
