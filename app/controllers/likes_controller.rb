class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :find_article
  
    def create
      @article.likes.create(user: current_user)
      redirect_to @article, notice: 'Article liked!'
    end
  
    def destroy
      @article.likes.find_by(user: current_user).destroy
      redirect_to @article, notice: 'Like removed!'
    end
  
    private
  
    def find_article
      @article = Article.find(params[:article_id])
    end
  end
  