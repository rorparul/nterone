class TopicsController < ApplicationController
  def select
    @topics = Topic.all
    @topic  = Topic.new
  end

  def select_to_edit
    if topic_params[:id] == 'none'
      redirect_to select_forums_path
    else
      @topic = Topic.find(topic_params[:id])
    end
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.assign_attributes(topic_params)
    if @topic.save
      flash[:success] = 'Topic successfully updated!'
      render js: "window.location = '#{forums_path}';"
    else
      render 'select_to_edit'
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @post  = Post.new
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:success] = 'Topic successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'new'
    end
  end

  def destroy
    topic = Topic.find(params[:id])
    if topic.destroy
      flash[:success] = 'Topic successfully deleted!'
    else
      flash[:alert] = 'Topic unsuccessfully deleted!'
    end
    redirect_to :back
  end

  private

  def topic_params
    params.require(:topic).permit(:id, :title, :forum_id)
  end
end
