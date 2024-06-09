class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :drafts, :published, :your_comments, :comments_on_your_articles]
  before_action :authenticate_user!, only: [:edit, :update]

  def show
    @articles = @user.articles
    @draft_articles = @articles.draft
    @published_articles = @articles.published
    @comments = @user.comments
    case params[:view]
    when 'draft'
      @articles = @draft_articles
    when 'comments'
      @comments = @comments
    else
      @articles = @published_articles
    end
  end

  def edit
  end

  def update
    old_username = @user.username
    if @user.update(user_params)
      if old_username != @user.username
        redirect_to user_path(@user.username), notice: 'Profile updated successfully.'
      else
        redirect_to @user, notice: 'Profile updated successfully.'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def drafts
    @draft_articles = @user.articles.where(published: false)
    render 'show'
  end

  def published
    @published_articles = @user.articles.where(published: true)
    render 'show'
  end

  def your_comments
    @your_comments = @user.comments
    render 'show'
  end

  def comments_on_your_articles
    @comments_on_your_articles = Comment.joins(:article).where(articles: { user_id: @user.id })
    render 'show'
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username])
  end

  def user_params
    allowed_params = [:username, :email]
    allowed_params += [:password, :password_confirmation] if params[:user][:password].present?
    params.require(:user).permit(allowed_params)
  end
end
