Rails.application.routes.draw do
  resources :tags, only: [:show]

  get 'search', to: 'search#index', as: 'search'
  get 'search_preview', to: 'search#preview'
  get 'tags/:name', to: 'tags#show', as: 'tag_name'

  devise_for :users

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
