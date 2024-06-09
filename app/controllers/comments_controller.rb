class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy approve reject]
  before_action :set_article, only: %i[index create edit update destroy approve reject]
  before_action :authenticate_user!, only: %i[create edit update destroy approve reject]
  before_action :authorize_user!, only: %i[edit update destroy approve reject]

  def index
    @comments = @article.comments.approved.includes(:user).where(parent_comment_id: nil)
  end

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    @comment.status = 'pending'
    if @comment.save
      redirect_to article_path(@article), notice: 'Comment was successfully created.'
    else
      @comments = @article.comments.approved.includes(:user).where(parent_comment_id: nil)
      render 'articles/show', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to user_path(current_user.username), notice: 'Comment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to user_path(current_user.username), notice: 'Comment was successfully destroyed.'
  end

  def approve
    @comment.update(status: 'approved')
    redirect_to article_path(@comment.article), notice: 'Comment was successfully approved.'
  end

  def reject
    @comment.update(status: 'rejected')
    redirect_to article_path(@comment.article), notice: 'Comment was successfully rejected.'
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_comment_id)
  end

  def authorize_user!
    unless @comment.user == current_user || @article.user == current_user
      redirect_to @article, alert: 'You are not authorized to perform this action.'
    end
  end
end
