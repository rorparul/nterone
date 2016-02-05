class BlogPostsController < ApplicationController
  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = BlogPost.new(blog_post_params)
    if @blog_post.save(blog_post_params)
      flash[:success] = "Blog Post successfully added."
      # render js: "window.location = '#{my_admin_website_path}';"
      redirect_to my_admin_website_path
    else
      render 'new'
    end
  end

  def page
    @blog_posts = BlogPost.page(params[:page]).per(5)
  end

  def show
    @blog_post = BlogPost.find(params[:id])
  end

  def edit
    @blog_post = BlogPost.find(params[:id])
  end

  def update
    @blog_post = BlogPost.find(params[:id])
    if @blog_post.update_attributes(blog_post_params)
      flash[:success] = "Blog Post successfully updated."
      # render js: "window.location = '#{my_admin_website_path}';"
      redirect_to my_admin_website_path
    else
      render 'edit'
    end
  end

  def destroy
    if BlogPost.find(params[:id]).destroy
      flash[:success] = "Blog Post successfully deleted."
    else
      flash[:alert] = "Blog Post failed to delete."
    end
    redirect_to :back
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:page_title, :title, :content)
  end
end
