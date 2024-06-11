class UsersController < ApplicationController
  before_action :set_user,
                only: %i[show edit update drafts published your_comments comments_on_your_articles]
  before_action :authenticate_user!, only: %i[edit update]

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

  def edit; end

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
    @articles = @user.articles.draft
    render 'show'
  end

  def published
    @articles = @user.articles.published
    render 'show'
  end

  def your_comments
    @comments = @user.comments
    render 'show'
  end

  def comments_on_your_articles
    @comments = Comment.joins(:article).where(articles: { user_id: @user.id })
    render 'show'
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username])
  end

  def user_params
    allowed_params = %i[username email]
    allowed_params += %i[password password_confirmation] if params[:user][:password].present?
    params.require(:user).permit(allowed_params)
  end
end
