class IndustryArticlesController < ApplicationController
  before_action :authenticate_user!, except: :show

  def new
    @industry_article = IndustryArticle.new
  end

  def create
    @industry_article = IndustryArticle.new(industry_article_params)
    if @industry_article.save(industry_article_params)
      flash[:success] = "Industry Article successfully added."
      # render js: "window.location = '#{my_admin_website_path}';"
      redirect_to my_admin_website_path
    else
      render 'new'
    end
  end

  def page
    @industry_articles = IndustryArticle.page(params[:page]).per(5)
  end

  def show
    @industry_article = IndustryArticle.find(params[:id])
  end

  def edit
    @industry_article = IndustryArticle.find(params[:id])
  end

  def update
    @industry_article = IndustryArticle.find(params[:id])
    if @industry_article.update_attributes(industry_article_params)
      flash[:success] = "Industry Article successfully updated."
      # render js: "window.location = '#{my_admin_website_path}';"
      redirect_to my_admin_website_path
    else
      render 'edit'
    end
  end

  def destroy
    if IndustryArticle.find(params[:id]).destroy
      flash[:success] = "Industry Article successfully deleted."
    else
      flash[:alert] = "Industry Article failed to delete."
    end
    redirect_to :back
  end

  private

  def industry_article_params
    params.require(:industry_article).permit(:page_title,
                                             :title,
                                             :content,
                                             :bootsy_image_gallery_id,
                                             :page_description)
  end
end
