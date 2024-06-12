require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:user) { create(:user) }
  let(:article) { create(:article, user:) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @articles' do
      article = create(:article)
      get :index
      expect(assigns(:articles)).to eq([article])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: article.id }
      expect(response).to be_successful
    end

    it 'assigns @article' do
      get :show, params: { id: article.id }
      expect(assigns(:article)).to eq(article)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new article' do
        expect do
          post :create, params: { article: attributes_for(:article) }
        end.to change(Article, :count).by(1)
      end

      it 'redirects to the new article' do
        post :create, params: { article: attributes_for(:article) }
        expect(response).to redirect_to(Article.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new article' do
        expect do
          post :create, params: { article: attributes_for(:article, title: nil) }
        end.to_not change(Article, :count)
      end

      it 're-renders the new template' do
        post :create, params: { article: attributes_for(:article, title: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the article' do
        patch :update, params: { id: article.id, article: { title: 'New Title' } }
        article.reload
        expect(article.title).to eq('New Title')
      end

      it 'redirects to the updated article' do
        patch :update, params: { id: article.id, article: { title: 'New Title' } }
        expect(response).to redirect_to(article)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the article' do
        patch :update, params: { id: article.id, article: { title: nil } }
        article.reload
        expect(article.title).to_not eq(nil)
      end

      it 're-renders the edit template' do
        patch :update, params: { id: article.id, article: { title: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the article' do
      article = create(:article)
      expect do
        delete :destroy, params: { id: article.id }
      end.to change(Article, :count).by(-1)
    end

    it 'redirects to articles#index' do
      delete :destroy, params: { id: article.id }
      expect(response).to redirect_to(articles_path)
    end
  end
end
