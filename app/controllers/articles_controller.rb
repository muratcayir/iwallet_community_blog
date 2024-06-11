class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, only: %i[show edit update destroy]
  before_action :check_published, only: %i[edit update destroy]

  def index
    @articles = Article.published.includes(:tags)
  end

  def show
    @comments = @article.comments.approved.includes(:user).where(parent_comment_id: nil)
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      update_tags(@article)
      redirect_to @article, notice: 'Article was successfully created.', allow_other_host: true
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      update_tags(@article)
      redirect_to @article, notice: 'Article was successfully updated.', allow_other_host: true
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.', allow_other_host: true
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def check_published
    return unless @article.published?

    redirect_to @article, alert: 'Published articles cannot be edited or deleted.'
  end

  def update_tags(article)
    article.tags = Tag.where(id: params[:article][:tag_ids])
  end

  def article_params
    params.require(:article).permit(:title, :content, :status, tag_ids: [])
  end
end
