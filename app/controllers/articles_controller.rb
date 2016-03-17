class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, except: [:new, :create, :index]

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:success] = "Article successfully created!"
      redirect_to my_admin_website_path
    else
      render "new"
    end
  end

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @article.update_attributes(article_params)
      flash[:success] = "Article successfully updated!"
      redirect_to my_admin_website_path
    else
      render "edit"
    end
  end

  def delete
    if @article.find(params[:id]).destroy
      flash[:success] = "Article successfully updated!"
    else
      flash[:alert] = "Article failed to delete!"
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:page_title,
                                    :page_description,
                                    :kind,
                                    :title,
                                    :content,
                                    :created_at,
                                    :bootsy_image_gallery_id)
  end
end