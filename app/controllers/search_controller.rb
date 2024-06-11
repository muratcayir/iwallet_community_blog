class SearchController < ApplicationController
  def index
    @query = params[:query]
    if @query.present?
      if @query.start_with?('tag:')
        tag_name = @query.split(':')[1]
        @articles = Article.joins(:tags).where(tags: { name: tag_name }).published
      else
        @articles = Article.published.where('title ILIKE ? OR content ILIKE ?', "%#{@query}%", "%#{@query}%")
        @tags = Tag.where('name ILIKE ?', "%#{@query}%")
        @users = User.where('username ILIKE ?', "%#{@query}%")
      end
    else
      @articles = Article.none
      @tags = Tag.none
      @users = User.none
    end
  end

  def preview
    query = params[:query]
    tags = Tag.where('name ILIKE ?', "%#{query}%")
    articles = Article.published.where('title ILIKE ? OR content ILIKE ?', "%#{query}%", "%#{query}%")

    render json: { tags: tags.as_json(only: %i[id name]), articles: articles.as_json(only: %i[id title]) }
  end

  private

  def search_articles(query)
    if query.present?
      Article.published.where('title ILIKE ? OR content ILIKE ?', "%#{query}%", "%#{query}%")
    else
      Article.none
    end
  end

  def search_tags(query)
    if query.present?
      Tag.joins(:articles).where('name ILIKE ?', "%#{query}%").distinct
    else
      Tag.none
    end
  end

  def search_users(query)
    if query.present?
      User.where('username ILIKE ?', "%#{query}%")
    else
      User.none
    end
  end
end
