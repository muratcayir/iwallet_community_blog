class TagsController < ApplicationController
  def show
    @tag = Tag.find_by!(name: params[:name])
    @articles = @tag.articles.published
  end
end
