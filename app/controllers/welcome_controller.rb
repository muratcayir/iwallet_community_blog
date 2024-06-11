class WelcomeController < ApplicationController
  def index
    @articles = Article.published.limit(5).order(created_at: :desc)
  end
end
