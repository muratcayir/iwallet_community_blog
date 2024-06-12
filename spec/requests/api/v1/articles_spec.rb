require 'rails_helper'

RSpec.describe 'Api::V1::Articles', type: :request do
  let!(:user) { create(:user) }
  let!(:published_articles) { create_list(:article, 5, status: 'published', user:) }
  let!(:draft_articles) { create_list(:article, 3, status: 'draft', user:) }

  describe 'GET /api/v1/articles' do
    it 'returns all published articles' do
      get '/api/v1/articles'
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(5)
      expect(json_response).to all(include('status' => 'published'))
    end
  end

  describe 'GET /api/v1/articles/:id' do
    it 'returns a single published article' do
      article = published_articles.first
      get "/api/v1/articles/#{article.id}"
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(article.id)
      expect(json_response['status']).to eq('published')
    end
  end
end
