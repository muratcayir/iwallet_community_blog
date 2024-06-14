class WelcomeController < ApplicationController
  layout 'welcome', only: :index
  def index
    @articles = Article.published.limit(5).order(created_at: :desc)
  end
end
