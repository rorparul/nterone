class ForumsController < ApplicationController
  def filter
    if forum_params[:forum_id] == 'all'
      @topics = Topic.all
    else
      @topics = Forum.find(forum_params[:forum_id]).topics
    end
  end

  def select
    @forums = Forum.all
    @forum  = Forum.new
  end

  def select_to_edit
    if forum_params[:id] == 'none'
      redirect_to select_forums_path
    else
      @forum = Forum.find(forum_params[:id])
    end
  end

  def update
    @forum = Forum.find(params[:id])
    @forum.assign_attributes(forum_params)
    if @forum.save
      flash[:success] = 'Category successfully updated!'
      render js: "window.location = '#{forums_path}'"
    else
      render 'select_to_edit'
    end
  end

  def index
    @topics = Topic.all
  end

  def show

  end

  def new
    @forum = Forum.new
  end

  def create
    @forum = Forum.new(forum_params)
    if @forum.save
      flash[:success] = 'Category successfully created!'
      render js: "window.location = '#{request.referrer}';"
    else
      render 'edit'
    end
  end

  def destroy
    forum = Forum.find(params[:id])
    if forum.destroy
      flash[:success] = 'Category successfully deleted!'
    else
      flash[:alert] = 'Category unsuccessfully deleted!'
    end
    redirect_to :back
  end

  private

  def forum_params
    params.require(:forum).permit(:id, :title, :description, :forum_id)
  end
end
