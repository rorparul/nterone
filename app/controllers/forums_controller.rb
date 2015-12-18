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
      flash[:notice] = 'You have successfully updated Category.'
      render js: "window.location = '#{forums_path}'"
    else
      render('edit')
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
    @forum = Forum.create(forum_params)
  end

  def destroy
    Forum.find(params[:id]).destroy
    flash[:notice] = 'Category was successfully deleted.'
    redirect_to forums_path
  end

  private

  def forum_params
    params.require(:forum).permit(:id, :title, :description, :forum_id)
  end
end
