Rails.application.routes.draw do
  devise_for :users

  resources :users, param: :username, only: [:show, :edit, :update] do
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
    resources :likes, only: [:create, :destroy]
  end

  root 'welcome#index'
end
