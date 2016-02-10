class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.create(post_params)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if !@post.update_attributes(post_params)
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :topic_id, :content)
  end
end
