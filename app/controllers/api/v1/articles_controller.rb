module Api
  module V1
    class ArticlesController < BaseController
      def index
        articles = Article.published
        render json: articles, each_serializer: ArticleSerializer
      end

      def show
        article = Article.find(params[:id])
        render json: article, serializer: ArticleSerializer
      end
    end
  end
end
