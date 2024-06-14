class TagsController < ApplicationController
  def search
    tags = if params[:query].present?
             Tag.where('name ILIKE ?', "%#{params[:query]}%")
           else
             Tag.all
           end
    render json: tags.map { |tag| { id: tag.id, name: tag.name } }
  end

  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find_by!(name: params[:name])
    if @tag.nil?
      redirect_to tags_path, alert: 'Tag not found'
    else
      @articles = @tag.articles
    end
  end
end
