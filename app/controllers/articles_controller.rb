class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    @article = Article.new
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(articles_param)
    if @article.save
      redirect_to articles_path
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(articles_param)
      redirect_to articles_path
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.destroy
      redirect_to articles_path
    end
  end

  private 
  def articles_param
    params.require(:article).permit!
  end
end