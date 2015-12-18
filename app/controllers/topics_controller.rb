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
      flash[:notice] = 'You have successfully updated Topic.'
      render js: "window.location = '#{forums_path}'"
    else
      render('edit')
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
    @topic = Topic.create(topic_params)
  end

  def destroy
    Topic.find(params[:id]).destroy
    flash[:notice] = 'Topic was successfully deleted.'
    redirect_to forums_path
  end

  private

  def topic_params
    params.require(:topic).permit(:id, :title, :forum_id)
  end
end
