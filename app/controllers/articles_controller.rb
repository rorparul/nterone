class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article,        except: [:new, :create, :index]
  before_action :authorize_article,  only: [:new, :create, :edit, :update, :destroy]

  def new
    authorize @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:success] = "Article successfully created!"
      redirect_to admin_marketing_path
    else
      render "new"
    end
  end

  def index
  end

  def show
  end

  def edit
    authorize @article
  end

  def update
    if @article.update_attributes(article_params)
      flash[:success] = "Article successfully updated!"
      redirect_to admin_marketing_path
    else
      render "edit"
    end
  end

  def destroy
    if @article.destroy
      flash[:success] = "Article successfully deleted!"
    else
      flash[:alert] = "Article failed to delete!"
    end
    redirect_to :back
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(
      :page_title,
      :page_description,
      :kind,
      :title,
      :content,
      :created_at,
      active_regions: []
    )
  end

  def authorize_article
    @article ||= Article.new
		authorize @article
  end
end
