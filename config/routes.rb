Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  namespace :api do
    namespace :v1 do
      resources :articles, only: %i[index show]
    end
  end

  resources :tags, only: [:show], param: :name

  get 'search', to: 'search#index', as: 'search'
  get 'search_preview', to: 'search#preview'
  get 'change_locale/:locale', to: 'application#change_locale', as: :change_locale

  resources :users, param: :username, only: %i[show edit update] do
    member do
      get :drafts
      get :published
      get :your_comments
      get :comments_on_your_articles
    end
  end

  resources :articles do
    resources :comments do
      member do
        patch :approve
        patch :reject
      end
    end
    resources :likes, only: %i[create destroy]
  end

  root 'welcome#index'
end
